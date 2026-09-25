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

# A line is measured in characters, because what the limit is about is how wide
# it looks. awk counts characters only under a UTF-8 locale and bytes otherwise,
# so one is chosen here rather than inherited: a developer shell usually has
# one and a container usually does not, which had this reporting an accented
# 61-character line as 91 over the limit on CI and inside the limit locally.
for CANDIDATE in C.UTF-8 C.utf8 en_US.UTF-8 ; do
    if locale -a 2>/dev/null | grep -qxF "$CANDIDATE" ; then
        export LC_ALL=$CANDIDATE
        break
    fi
done

if [ "$(printf '\303\251' | awk '{print length($0)}')" != 1 ] ; then
    echo "no UTF-8 locale available: measuring bytes, not characters" >&2
fi

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

measure() {
    sources | tr '\n' '\0' | xargs -0 awk -v limit="$1" \
        'length > limit { printf "%4d %s:%d\n", length, FILENAME, FNR }'
}

OVER=$(measure "$LIMIT" | sort -rn)

if [ -n "$OVER" ] ; then
    echo "$OVER"
    echo
fi

TOO_WIDE=$(measure "$HARD" | wc -l)

echo "$(echo -n "$OVER" | grep -c . || true) over $LIMIT, $TOO_WIDE over the hard limit of $HARD"

[ "$TOO_WIDE" -eq 0 ]
