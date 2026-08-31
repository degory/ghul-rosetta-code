#!/bin/bash

# Emit Rosetta Code wiki markup for a task: heading, syntax-highlighted source, and the output
# the program produces. Reads the source from tasks/<slug>/<slug>.ghul and gets the output by
# running the task, so editing a solution and generating its markup needs nothing in between.
#
# A task worth showing more than one way holds parts instead: tasks/<slug>/NN-name/, each a whole
# program with its own project and test. Each becomes a ===heading=== section with its own source
# and output, in the order the numbers give.
#
#   scripts/generate-wiki.sh <slug>          markup to stdout, ready to paste
#   scripts/generate-wiki.sh --all           writes wiki-out/<slug>.wiki for every working task
#   scripts/generate-wiki.sh --solved        the same, for the tasks not yet on the wiki
#   scripts/generate-wiki.sh --out <slug>... the same, for the tasks named
#
# Generating builds and runs each task, so --all costs a couple of minutes on a full repository.
# Publishing reads wiki-out/, and a publish run posts either named slugs or every solved task, so
# --solved and --out generate exactly what such a run will read and nothing else.
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

# Run the task and print what it writes to stdout. The program is built first, separately, and
# everything the build prints is discarded: MSBuild writes compiler warnings to stdout whatever
# the verbosity, and a warning captured here would go into the {{out}} block as though the
# program had printed it - carrying the absolute path of this checkout onto a public page. Only
# the built program's own output is captured. It is rebuilt when the source is newer, so an edit
# is always picked up.
run_task() {
    local DIR=$1
    local NAME=$2

    local BUILT="$DIR/bin/Debug/net10.0/$NAME"

    if [ ! -x "$BUILT" ] || [ ! "$BUILT" -nt "$DIR/$NAME.ghul" ] ; then
        dotnet build "$DIR" --nologo -v quiet >/dev/null 2>&1 || return 1
    fi

    "$BUILT"
}

# The parts of a task, in order, or nothing when it is an ordinary single-program task.
task_parts() {
    local TASK=$ROOT/tasks/$1
    local PART

    for PART in "$TASK"/[0-9][0-9]-*/ ; do
        if [ -d "$PART" ] ; then
            basename "$PART"
        fi
    done

    # A task with no parts is the ordinary case, not a failure: saying so explicitly keeps the
    # unmatched glob's false test from taking the whole script down under set -e.
    return 0
}

# 01-using-map becomes "Using map": the number orders the parts and does not belong in the
# heading, and the rest is the heading with its hyphens opened out.
part_heading() {
    local NAME=${1#*-}

    NAME=${NAME//-/ }

    echo "${NAME^}"
}

# One program's source and output: the body of an entry, or of one part of one.
emit_body() {
    local DIR=$1
    local NAME=$2
    local TEST=$ROOT/integration-tests/$3

    local SOURCE="$DIR/$NAME.ghul"
    local EXPECTED="$TEST/run.expected"

    if [ ! -f "$SOURCE" ] ; then
        echo "no source: $SOURCE" >&2
        return 1
    fi

    local OUTPUT

    if ! OUTPUT=$(run_task "$DIR" "$NAME") ; then
        echo "$3: does not build or run" >&2
        return 1
    fi

    if [ -f "$EXPECTED" ] && [ "$OUTPUT" != "$(cat "$EXPECTED")" ] ; then
        echo "$3: output differs from integration-tests/$3/run.expected - recapture the test" >&2
    fi

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

emit() {
    local SLUG=$1
    local PARTS

    PARTS=$(task_parts "$SLUG")

    echo "=={{header|ghul}}=="

    if [ -z "$PARTS" ] ; then
        emit_body "$ROOT/tasks/$SLUG" "$SLUG" "$SLUG"
        return
    fi

    local PART
    local FIRST=yes

    for PART in $PARTS ; do
        [ "$FIRST" = yes ] || echo

        FIRST=no

        echo "===$(part_heading "$PART")==="

        emit_body "$ROOT/tasks/$SLUG/$PART" "$PART" "$SLUG-$PART" || return 1
    done
}

working() {
    local SLUG=$1
    local PARTS

    PARTS=$(task_parts "$SLUG")

    if [ -z "$PARTS" ] ; then
        [ ! -f "$ROOT/integration-tests/$SLUG/disabled" ]
        return
    fi

    local PART

    for PART in $PARTS ; do
        [ -f "$ROOT/integration-tests/$SLUG-$PART/disabled" ] && return 1
    done

    return 0
}

# Write one task's markup to wiki-out/, reporting what happened. Returns non-zero only for a
# caller that needs to know a named task was not written; a bulk run carries on regardless.
generate_to_out() {
    local SLUG=$1
    local OUT=$ROOT/wiki-out

    if ! working "$SLUG" ; then
        printf '%-28s skipped (disabled)\n' "$SLUG"
        return 1
    fi

    if ! emit "$SLUG" > "$OUT/$SLUG.wiki" ; then
        rm -f "$OUT/$SLUG.wiki"
        printf '%-28s skipped (does not run)\n' "$SLUG"
        return 1
    fi

    printf '%-28s %-9s %s\n' \
        "$SLUG" "$(task_status "$ROOT/tasks/$SLUG")" "$(task_url "$ROOT/tasks/$SLUG")"
}

# The slugs of every task the ledger holds in the given state. A rejected task carries no slug,
# having no solution to name, so the state has to be matched on the same entry as the slug rather
# than on whichever line happens to come next.
slugs_in_state() {
    jq -r --arg state "$1" \
        '.tasks[] | select(.state == $state and .slug != null) | .slug' \
        "$ROOT/TASKS.json"
}

if [ "$1" = "--all" ] || [ "$1" = "--solved" ] || [ "$1" = "--out" ] ; then
    MODE=$1
    shift

    OUT=$ROOT/wiki-out
    mkdir -p "$OUT"

    case $MODE in
        --all)
            SLUGS=$(for dir in "$ROOT"/tasks/*/ ; do basename "$dir" ; done)
            ;;
        --solved)
            SLUGS=$(slugs_in_state solved)

            if [ -z "$SLUGS" ] ; then
                echo "no solved tasks - everything with a solution is already on the wiki" >&2
                exit 0
            fi
            ;;
        --out)
            if [ $# -eq 0 ] ; then
                echo "--out needs at least one slug" >&2
                exit 1
            fi

            SLUGS=$*

            for SLUG in $SLUGS ; do
                if [ ! -d "$ROOT/tasks/$SLUG" ] ; then
                    echo "no such task: $SLUG" >&2
                    exit 1
                fi
            done
            ;;
    esac

    FAILED=0

    for SLUG in $SLUGS ; do
        generate_to_out "$SLUG" || FAILED=$((FAILED + 1))
    done

    echo
    echo "written to wiki-out/ - paste each into the ghul section of the page above it"

    # A named task that produced nothing is the caller's problem: they asked for it by name and a
    # publish run would read a file that is missing or stale. A bulk run skipping a broken task is
    # the documented behaviour and stays a success.
    if [ "$MODE" = "--out" ] && [ "$FAILED" -gt 0 ] ; then
        exit 1
    fi
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
    echo "       scripts/generate-wiki.sh --solved"
    echo "       scripts/generate-wiki.sh --out <slug>..."
    exit 1
fi
