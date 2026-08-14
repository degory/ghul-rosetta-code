#!/bin/bash

# Emit Rosetta Code wiki markup for a task: heading, syntax-highlighted source, and captured
# output. Reads the source from tasks/<slug>/<slug>.ghul and the output from the matching
# integration test's run.expected, so what it prints is what was tested.
#
#   scripts/generate-wiki.sh <slug>     markup to stdout, ready to paste
#   scripts/generate-wiki.sh --all      writes wiki-out/<slug>.wiki for every working task
#
# Tasks whose test carries a `disabled` marker are skipped: they are not working, and an entry
# that does not run should not be posted.

set -e

ROOT=$(cd "$(dirname "$0")/.." && pwd)

task_url() {
    local TASK=$1

    if [ -f "$TASK/task.json" ] ; then
        sed -n 's/.*"url"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$TASK/task.json"
    fi
}

task_status() {
    local TASK=$1

    if [ -f "$TASK/task.json" ] ; then
        sed -n 's/.*"status"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$TASK/task.json"
    fi
}

emit() {
    local SLUG=$1
    local TASK=$ROOT/tasks/$SLUG
    local TEST=$ROOT/integration-tests/$SLUG

    local SOURCE="$TASK/$SLUG.ghul"
    local EXPECTED="$TEST/run.expected"

    if [ ! -f "$SOURCE" ] ; then
        echo "no source: $SOURCE" >&2
        return 1
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
    fi
}

working() {
    local SLUG=$1

    [ ! -f "$ROOT/integration-tests/$SLUG/disabled" ]
}

if [ "$1" = "--all" ] ; then
    OUT=$ROOT/wiki-out
    mkdir -p "$OUT"

    for dir in "$ROOT"/tasks/*/ ; do
        SLUG=$(basename "$dir")

        if ! working "$SLUG" ; then
            printf '%-28s skipped (disabled)\n' "$SLUG"
            continue
        fi

        emit "$SLUG" > "$OUT/$SLUG.wiki"

        printf '%-28s %-9s %s\n' \
            "$SLUG" "$(task_status "$dir")" "$(task_url "$dir")"
    done

    echo
    echo "written to wiki-out/ - paste each into the ghul section of the page above it"
elif [ -n "$1" ] ; then
    if ! working "$1" ; then
        echo "$1 is disabled - its test does not pass, so it should not be posted" >&2
        exit 1
    fi

    # to stderr, so stdout stays exactly what gets pasted
    echo "paste into: $(task_url "$ROOT/tasks/$1")" >&2

    emit "$1"
else
    echo "usage: scripts/generate-wiki.sh <slug>"
    echo "       scripts/generate-wiki.sh --all"
    exit 1
fi
