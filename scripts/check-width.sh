#!/bin/bash

# Report solution lines that are too wide to read where a solution is read: a fixed-width block on
# Rosetta Code, and a prose column on ghul.dev. See AGENTS.md.
#
#   scripts/check-width.sh          every line over the soft limit, worst first
#   scripts/check-width.sh --hard   only lines over the hard limit
#
# A task whose source cannot be narrowed without becoming a different program carries a
# width-exempt file naming the sources to skip, one path per line relative to the task
# directory, with the reason on a # line above them. A quine is the case this exists for.
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

cd "$ROOT"

# Every source, less the ones a width-exempt file in the same task names.
sources() {
    local exempt
    exempt=$(mktemp)

    while IFS= read -r marker ; do
        local task
        task=$(dirname "$marker")

        grep -v '^[[:space:]]*\(#.*\)\?$' "$marker" | while IFS= read -r path ; do
            echo "$task/$path"
        done
    done < <(find tasks -name width-exempt) >"$exempt"

    find tasks -name '*.ghul' | grep -vxF -f "$exempt"

    rm -f "$exempt"
}

# A line is measured in characters, because what the limit is about is how wide
# it looks where the solution is read. awk's own length counts characters under
# a UTF-8 locale and bytes otherwise, and the container CI runs in has no UTF-8
# locale at all, which measured an accented 61-character line as 91. So the
# characters are counted here instead of asked for: in UTF-8 every byte of a
# character after its first is a continuation byte, so the count is the bytes
# less those. Same answer under any locale, and under mawk as under gawk.
measure() {
    sources | tr '\n' '\0' | xargs -0 awk -v limit="$1" '
        {
            rest = $0
            width = length($0) - gsub(/[\200-\277]/, "", rest)

            if (width > limit) {
                printf "%4d %s:%d\n", width, FILENAME, FNR
            }
        }'
}

OVER=$(measure "$LIMIT" | sort -rn)

if [ -n "$OVER" ] ; then
    echo "$OVER"
    echo
fi

TOO_WIDE=$(measure "$HARD" | wc -l)

echo "$(echo -n "$OVER" | grep -c . || true) over $LIMIT, $TOO_WIDE over the hard limit of $HARD"

[ "$TOO_WIDE" -eq 0 ]
