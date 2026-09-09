#!/bin/bash

# Publish solutions to the wiki and land the record of it in one invocation.
#
#   scripts/publish.sh <slug>...      publish those tasks
#   scripts/publish.sh --solved       publish every task not yet on the wiki
#
# Any other argument is passed through to `rosetta publish`, so --dry-run and
# --replace work as they do there, in any position.
#
# The record is the point of this script. `rosetta publish` writes each page's
# new digest into TASKS.json as it goes, and that digest is the only thing a
# later run can use to tell an edit made on the wiki from one made here. A run
# whose record never reaches main leaves every one of those pages unpublishable
# until somebody works out by hand what happened to them, which is what this
# repository spent a fortnight doing. So the branch, the commit, the push and
# the pull request happen here, in the same invocation, rather than being left
# to whoever remembers.
#
# The pull request merges itself: .github/workflows/ledger.yml approves a
# change that touches only the ledger. Nothing else this script does is
# reviewed, because nothing else this script does changes a solution.

set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)

cd "$ROOT"

if [ $# -eq 0 ] ; then
    echo "usage: scripts/publish.sh <slug>... | --solved" >&2
    exit 1
fi

if [ -n "$(git status --porcelain)" ] ; then
    echo "the working tree has changes; commit or discard them first" >&2
    echo "the record this writes has to be the only thing in its commit" >&2
    exit 1
fi

BRANCH=ghul-coder/publish-record-$(date +%Y-%m-%d-%H%M%S)

# Where to go back to if nothing publishes. `main` is checked out in the primary
# clone, so a worktree cannot return to it by name.
WAS=$(git symbolic-ref --quiet --short HEAD || git rev-parse HEAD)

git fetch --quiet origin main
git checkout --quiet -b "$BRANCH" origin/main

# Publishing reads the markup from wiki-out/, and markup generated from some
# earlier state of the tree would put that state on the wiki. Regenerate the
# tasks about to be published, and nothing else: --solved and an explicit list
# generate exactly what the publish run will read.
# The flags can come in any order, so which tasks to generate is decided by
# reading all of them rather than by looking at the first. A flag left in the
# slug list generates nothing and then publishes nothing.
SLUGS=()
SOLVED=

for argument in "$@" ; do
    case "$argument" in
        --solved) SOLVED=yes ;;
        --*)      ;;
        *)        SLUGS+=("$argument") ;;
    esac
done

if [ -n "$SOLVED" ] ; then
    scripts/generate-wiki.sh --solved
elif [ ${#SLUGS[@]} -gt 0 ] ; then
    scripts/generate-wiki.sh --out "${SLUGS[@]}"
fi

# A refusal is per page and the rest of the batch carries on, so a non-zero
# exit still leaves records worth keeping. Take the status and continue.
STATUS=0
dotnet run --project tools/rosetta -- publish "$@" || STATUS=$?

if [ -z "$(git status --porcelain TASKS.json)" ] ; then
    echo "nothing was published, so there is no record to land"
    git checkout --quiet "$WAS"
    git branch --quiet -D "$BRANCH"
    exit "$STATUS"
fi

PUBLISHED=$(git diff --unified=0 TASKS.json | grep -c '^+.*published_hash' || true)

git add TASKS.json tasks/*/task.json
git commit --quiet -m "Record $PUBLISHED published sections' digests

Written by scripts/publish.sh from the run that made the edits."

git push --quiet -u origin "$BRANCH"

gh pr create \
    --head "$BRANCH" \
    --title "Record $PUBLISHED published sections' digests" \
    --technical "Record the digest of each section the publish run put on the wiki"

echo
echo "recorded $PUBLISHED sections; the pull request merges itself once the shards pass"

exit "$STATUS"
