#!/bin/bash

# Emit Rosetta Code wiki markup for a task: heading, syntax-highlighted source, and the output
# the program produces. Reads the source from tasks/<slug>/<slug>.ghul and gets the output by
# running the task, so editing a solution and generating its markup needs nothing in between.
#
#   scripts/generate-wiki.sh <slug>     markup to stdout, ready to paste
#   scripts/generate-wiki.sh --all      writes wiki-out/<slug>.wiki for every working task
#
# Where that output differs from the matching test's run.expected, the entry is emitted anyway
# and the difference is reported on stderr: the test needs recapturing, which is worth knowing
# but is not a reason to withhold the markup.
#
# Tasks whose test carries a `disabled` marker are skipped: they are not working, and an entry
# that does not run should not be posted. So is a task that fails to build or run.

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

# Run the task and print what it writes to stdout. The built program is used when it is newer
# than the source, and rebuilt through `dotnet run` when it is not, so an edit is always picked
# up.
run_task() {
    local SLUG=$1
    local TASK=$ROOT/tasks/$SLUG

    local BUILT="$TASK/bin/Debug/net10.0/$SLUG"

    if [ -x "$BUILT" ] && [ "$BUILT" -nt "$TASK/$SLUG.ghul" ] ; then
        "$BUILT"
    else
        dotnet run --project "$TASK" --nologo -v quiet
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

    local OUTPUT

    if ! OUTPUT=$(run_task "$SLUG") ; then
        echo "$SLUG: does not build or run" >&2
        return 1
    fi

    if [ -f "$EXPECTED" ] && [ "$OUTPUT" != "$(cat "$EXPECTED")" ] ; then
        echo "$SLUG: output differs from integration-tests/$SLUG/run.expected - recapture the test" >&2
    fi

    echo "=={{header|ghul}}=="
    printf '%s' "<syntaxhighlight lang=\"ghul\">"
    cat "$SOURCE"
    echo "</syntaxhighlight>"
    echo

    if [ -n "$OUTPUT" ] ; then
        echo "{{out}}"
        echo "<pre>"
        echo "$OUTPUT"
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

        if ! emit "$SLUG" > "$OUT/$SLUG.wiki" ; then
            rm -f "$OUT/$SLUG.wiki"
            printf '%-28s skipped (does not run)\n' "$SLUG"
            continue
        fi

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
