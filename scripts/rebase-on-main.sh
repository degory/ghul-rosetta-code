#!/bin/bash

# Rebase the current branch onto origin/main, or onto the branch named.
#
#   scripts/rebase-on-main.sh [upstream]
#
# Almost every branch here changes TASKS.json and index.json, so two branches in flight at once
# conflict in them as soon as either lands. A conflict in those two files is resolved by starting
# from main's ledger, applying the ledger entries the commit being replayed changed, through
# `rosetta set` so the ledger keeps its own order and format, and regenerating the index. A
# conflict anywhere else, or a changed entry `set` cannot express (a published digest), stops the
# rebase for a person to finish.
#
# The index is checked once the rebase is done, since a clean textual merge of index.json can
# still leave it out of step with the tasks; a stale one is regenerated in a commit of its own.

set -euo pipefail

UPSTREAM=${1:-origin/main}
ROOT=$(git rev-parse --show-toplevel)
cd "$ROOT"

rosetta() {
    dotnet run --project tools/rosetta -- "$@" >/dev/null
}

conflicted() {
    git diff --name-only --diff-filter=U
}

resolve_ledger() {
    local changed

    changed=$(jq -c --slurpfile before <(git show :1:TASKS.json) \
        '.tasks[] as $entry
            | select(any($before[0].tasks[]; . == $entry) | not)
            | $entry' \
        <(git show :3:TASKS.json))

    git show :2:TASKS.json >TASKS.json

    while IFS= read -r entry; do
        [ -z "$entry" ] && continue

        if [ "$(jq -r 'has("published_hash")' <<<"$entry")" = true ]; then
            echo "rebase-on-main: $(jq -r .title <<<"$entry") carries a published digest; finish this one by hand" >&2
            exit 1
        fi

        local arguments=()

        mapfile -t arguments < <(jq -r '.title, .state, (.reason // empty), (.note // empty)' <<<"$entry")

        rosetta set "${arguments[@]}"
    done <<<"$changed"

    rosetta index
    git add TASKS.json index.json
}

git fetch -q origin

if ! git rebase -q "$UPSTREAM" 2>/dev/null; then
    while [ -n "$(conflicted)" ]; do
        others=$(conflicted | grep -v -x -e TASKS.json -e index.json || true)

        if [ -n "$others" ]; then
            echo "rebase-on-main: conflicts outside the ledger, finish the rebase by hand:" >&2
            echo "$others" >&2
            exit 1
        fi

        if conflicted | grep -q -x TASKS.json; then
            resolve_ledger
        else
            git checkout -q --theirs index.json
            rosetta index
            git add index.json
        fi

        GIT_EDITOR=true git rebase --continue >/dev/null 2>&1 || true
    done
fi

if ! dotnet run --project tools/rosetta -- index --check >/dev/null 2>&1; then
    rosetta index
    git commit -q -m "Regenerate the task index" index.json
fi

echo "rebased onto $UPSTREAM: $(git log --oneline "$UPSTREAM"..HEAD | wc -l) commits ahead"
