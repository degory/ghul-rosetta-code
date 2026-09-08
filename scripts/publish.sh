#!/bin/bash

# Publish solutions to the wiki and land the record of it in one invocation.
#
#   scripts/publish.sh <slug>...      publish those tasks
#   scripts/publish.sh --solved       publish every task not yet on the wiki
#
# Any other argument is passed through to `rosetta publish`, so --dry-run and
# --replace work as they do there.
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

git fetch --quiet origin main
git checkout --quiet -b "$BRANCH" origin/main

# Publishing reads the markup from wiki-out/, and markup generated from some
# earlier state of the tree would put that state on the wiki. Regenerate the
# tasks about to be published, and nothing else: --solved and an explicit list
# generate exactly what the publish run will read.
case "$1" in
    --solved) scripts/generate-wiki.sh --solved ;;
    --*)      ;;
    *)        scripts/generate-wiki.sh --out "$@" ;;
esac

# A refusal is per page and the rest of the batch carries on, so a non-zero
# exit still leaves records worth keeping. Take the status and continue.
STATUS=0
dotnet run --project tools/rosetta -- publish "$@" || STATUS=$?

if [ -z "$(git status --porcelain TASKS.json)" ] ; then
    echo "nothing was published, so there is no record to land"
    git checkout --quiet main
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
