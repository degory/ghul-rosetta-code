#!/bin/bash

# Whether a change is ledger-only: the changed paths, one a line on standard
# input, are all ledger entries or task.json files. Exits zero when they are
# and non-zero otherwise, including when there are none.
#
#   git diff --name-only BASE HEAD | scripts/ledger-only.sh
#
# ledger.yml approves such a change unread, review.yml does not review it, and
# ci.yml runs no tasks for it in the merge queue, so all three ask here rather
# than each carrying its own copy of the test.

set -euo pipefail

CHANGED=$(cat)

if [ -z "$CHANGED" ] ; then
    exit 1
fi

# Tested for a non-empty result rather than by grep's exit status: -q with -v
# does not mean the same thing in every grep.
OTHER=$(echo "$CHANGED" | grep -vE '^(ledger/[^/]+\.json|tasks/[^/]+/task\.json)$' || true)

[ -z "$OTHER" ]
