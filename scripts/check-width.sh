#!/bin/bash

# Report solution lines that are too wide to read where a solution is read: a fixed-width block on
# Rosetta Code, and a prose column on ghul.dev. See AGENTS.md.
#
#   scripts/check-width.sh          every line over the soft limit, worst first
#   scripts/check-width.sh --hard   only lines over the hard limit
#
# Exits non-zero if anything is over the hard limit.

set -e

SOFT=64
HARD=76

ROOT=$(cd "$(dirname "$0")/.." && pwd)

LIMIT=$SOFT

if [ "$1" = "--hard" ] ; then
    LIMIT=$HARD
fi

OVER=$(cd "$ROOT" && find tasks -name '*.ghul' -print0 \
    | xargs -0 awk -v limit="$LIMIT" \
        'length > limit { printf "%4d %s:%d\n", length, FILENAME, FNR }' \
    | sort -rn)

if [ -n "$OVER" ] ; then
    echo "$OVER"
    echo
fi

TOO_WIDE=$(cd "$ROOT" && find tasks -name '*.ghul' -print0 \
    | xargs -0 awk -v limit="$HARD" 'length > limit' | wc -l)

echo "$(echo -n "$OVER" | grep -c . || true) over $LIMIT, $TOO_WIDE over the hard limit of $HARD"

[ "$TOO_WIDE" -eq 0 ]
