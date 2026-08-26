#!/bin/bash

# Emit this repository's solutions as ghul.dev pages, so they highlight, hover and run rather than
# sitting on Rosetta Code as plain text. See degory/ghul#2182.
#
#   scripts/generate-site.sh <ghul-dev-checkout>          every published task
#   scripts/generate-site.sh <ghul-dev-checkout> <slug>   one, for a look at the output
#
# Writes, per task:
#
#   examples/rosetta-<slug>[-<part>]/…​.ghul     the source, which example-tool compiles and runs
#   src/rosetta/<slug>.md                       the page
#   src/rosetta/index.md                        the contents
#
# and nothing else: the pages are derived, so they are never edited in ghul-dev. A solution is
# improved here and regenerated there. The alternative - maintaining a second copy by hand - is
# what left fourteen wiki entries disagreeing with this repository.
#
# example-tool turns each source into example-data/<name>.json, capturing the output by running
# the program, so a page cannot show output the code does not produce. What this script must not
# do is write that output itself.

set -e

DEV=$1
ONLY=$2

if [ -z "$DEV" ] || [ ! -d "$DEV/examples" ] ; then
    echo "usage: scripts/generate-site.sh <ghul-dev-checkout> [slug]" >&2
    exit 1
fi

ROOT=$(cd "$(dirname "$0")/.." && pwd)
PAGES=$DEV/src/rosetta

mkdir -p "$PAGES"

# Task metadata lives in each task.json, which sync writes from the ledger.
task_field() {
    sed -n "s/.*\"$2\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" "$ROOT/tasks/$1/task.json"
}

# Same convention as the wiki markup: NN-name orders the parts and names the section.
part_heading() {
    local NAME=${1#*-}

    NAME=${NAME//-/ }

    echo "${NAME^}"
}

emit_example() {
    local NAME=$1
    local SOURCE=$2

    mkdir -p "$DEV/examples/$NAME"
    cp "$SOURCE" "$DEV/examples/$NAME/$NAME.ghul"

    echo "<GhulExample name=\"$NAME\" />"
}

emit_page() {
    local SLUG=$1
    local TITLE
    local URL

    TITLE=$(task_field "$SLUG" task)
    URL=$(task_field "$SLUG" url)

    {
        echo "# $TITLE"
        echo
        echo "::: tip editable example"
        echo "Click the pencil to open this in an editor, change it, and run it in your browser."
        echo "It is the same solution posted to [Rosetta Code]($URL)."
        echo ":::"
        echo

        local PARTS
        PARTS=$(cd "$ROOT/tasks/$SLUG" && ls -d [0-9][0-9]-*/ 2>/dev/null | tr -d /)

        if [ -z "$PARTS" ] ; then
            emit_example "rosetta-$SLUG" "$ROOT/tasks/$SLUG/$SLUG.ghul"
        else
            local PART

            for PART in $PARTS ; do
                echo "## $(part_heading "$PART")"
                echo
                emit_example "rosetta-$SLUG-$PART" "$ROOT/tasks/$SLUG/$PART/$PART.ghul"
                echo
            done
        fi
    } >"$PAGES/$SLUG.md"

    echo "$SLUG"
}

published() {
    local DIR

    for DIR in "$ROOT"/tasks/*/ ; do
        local SLUG
        SLUG=$(basename "$DIR")

        if [ "$(task_field "$SLUG" status)" = published ] ; then
            echo "$SLUG"
        fi
    done
}

if [ -n "$ONLY" ] ; then
    emit_page "$ONLY"

    exit 0
fi

SLUGS=$(published)

for SLUG in $SLUGS ; do
    emit_page "$SLUG" >/dev/null
done

{
    echo "# Rosetta Code"
    echo
    echo "[Rosetta Code](https://rosettacode.org) sets the same task in many languages, which makes"
    echo "it a fair way to see what a language reads like next to its neighbours. Every solution"
    echo "here is posted there too, and each one is built and run by a test in"
    echo "[ghul-rosetta-code](https://github.com/degory/ghul-rosetta-code) before it goes anywhere."
    echo

    for SLUG in $SLUGS ; do
        echo "- [$(task_field "$SLUG" task)](/rosetta/$SLUG)"
    done
} >"$PAGES/index.md"

echo "$(echo "$SLUGS" | wc -w) tasks written to $PAGES"
echo
echo "next, in the ghul-dev checkout:"
echo "    dotnet run --project example-tool -- examples src/.vitepress/example-data"
echo "and add the section to src/.vitepress/pages.ts"
