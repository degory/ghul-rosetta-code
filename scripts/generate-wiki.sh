#!/bin/bash

# Emit Rosetta Code wiki markup for a task: heading, syntax-highlighted source, and captured
# output. Reads the source from tasks/<slug>/<slug>.ghul and the output from the matching
# integration test's run.expected.
#
#   scripts/generate-wiki.sh <slug>
#   scripts/generate-wiki.sh --all

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)

emit() {
    local SLUG=$1
    local TASK=$ROOT/tasks/$SLUG
    local TEST=$ROOT/integration-tests/$SLUG

    if [ ! -d "$TASK" ] ; then
        echo "no task: tasks/$SLUG" >&2
        return 1
    fi

    local SOURCE="$TASK/$SLUG.ghul"
    local EXPECTED="$TEST/run.expected"

    if [ ! -f "$SOURCE" ] ; then
        echo "no source: $SOURCE" >&2
        return 1
    fi

    # skip tasks that aren't working yet
    if [ -f "$TEST/disabled" ] ; then
        return 0
    fi

    echo "=={{header|ghul}}=="
    echo
    echo "<syntaxhighlight lang=\"ghul\">"
    cat "$SOURCE"
    echo "</syntaxhighlight>"
    echo

    if [ -f "$EXPECTED" ] && [ -s "$EXPECTED" ] ; then
        echo "{{out}}"
        echo "<pre>"
        cat "$EXPECTED"
        echo "</pre>"
        echo
    fi
}

if [ "$1" = "--all" ] ; then
    for dir in "$ROOT"/tasks/*/ ; do
        SLUG=$(basename "$dir")
        emit "$SLUG" || true
    done
elif [ -n "$1" ] ; then
    emit "$1"
else
    echo "usage: scripts/generate-wiki.sh <slug>"
    echo "       scripts/generate-wiki.sh --all"
    exit 1
fi
