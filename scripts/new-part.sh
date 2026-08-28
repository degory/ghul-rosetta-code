#!/bin/bash

# Add a part to a task, for the tasks worth showing more than one way. Each part is a whole
# program with its own project and its own test, and becomes one `===heading===` section of the
# entry, in the order the leading number gives.
#
#   scripts/new-part.sh <slug> <NN-name>
#
# The heading comes from the directory name: 01-using-map becomes "Using map". A task with parts
# has no source of its own - move the existing one into a part first, and delete the task's
# .ghulproj and ghul.json, or the two will collide over the entry point.

set -e

SLUG=$1
PART=$2

if [ -z "$SLUG" ] || [ -z "$PART" ] ; then
    echo "usage: scripts/new-part.sh <slug> <NN-name>"
    exit 1
fi

if [[ ! $PART =~ ^[0-9][0-9]-[a-z0-9-]+$ ]] ; then
    echo "part name must be NN-lower-case-name, for example 01-using-map"
    exit 1
fi

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TASK=$ROOT/tasks/$SLUG
DIR=$TASK/$PART
TEST=$ROOT/integration-tests/$SLUG-$PART

if [ ! -d "$TASK" ] ; then
    echo "no such task: tasks/$SLUG"
    exit 1
fi

if [ -e "$DIR" ] ; then
    echo "part already exists: tasks/$SLUG/$PART"
    exit 1
fi

mkdir -p "$DIR"

cat >"$DIR/$PART.ghulproj" <<'EOF'
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <GhulSources Include="**/*.ghul" />
  </ItemGroup>
</Project>
EOF

cat >"$DIR/ghul.json" <<'EOF'
{
    "restore_tools": true
}
EOF

cat >"$DIR/$PART.ghul" <<'EOF'
use IO.Std.write_line;

write_line("not written yet");
EOF

mkdir -p "$TEST"
cp "$ROOT/integration-tests/template/test.ghulproj" "$TEST/test.ghulproj"
ln -s "../../tasks/$SLUG/$PART/$PART.ghul" "$TEST/$PART.ghul"

for f in ghulflags err.expected warn.expected run.expected ; do
    : >"$TEST/$f"
done

echo "created tasks/$SLUG/$PART and integration-tests/$SLUG-$PART"
echo
echo "write the part, then:"
echo "    dotnet run --project tasks/$SLUG/$PART"
echo "    dotnet ghul-test --use-dotnet-build integration-tests/$SLUG-$PART"
echo "    integration-tests/capture.sh integration-tests/$SLUG-$PART"
