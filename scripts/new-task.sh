#!/bin/bash

# Scaffold a task: its runnable project under tasks/, and the matching test folder under
# integration-tests/ with the source symlinked in.
#
#   scripts/new-task.sh <slug> "<Rosetta task title>"
#
# The slug is the task title lowercased, with anything that is not a letter or a digit collapsed
# to a single hyphen, so "Hello world/Text" is hello-world-text.

set -e

SLUG=$1
TITLE=$2

if [ -z "$SLUG" ] || [ -z "$TITLE" ] ; then
    echo "usage: scripts/new-task.sh <slug> \"<Rosetta task title>\""
    exit 1
fi

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TASK=$ROOT/tasks/$SLUG
TEST=$ROOT/integration-tests/$SLUG

if [ -e "$TASK" ] ; then
    echo "task already exists: tasks/$SLUG"
    exit 1
fi

# The wiki URL is the title with spaces underscored. Everything else, including the slash in a
# subtask like Hello world/Text, is left as it stands.
URL_TITLE=${TITLE// /_}

mkdir -p "$TASK"

cat >"$TASK/$SLUG.ghulproj" <<'EOF'
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

cat >"$TASK/ghul.json" <<'EOF'
{
    "restore_tools": true
}
EOF

cat >"$TASK/task.json" <<EOF
{
    "task": "$TITLE",
    "url": "https://rosettacode.org/wiki/$URL_TITLE",
    "status": "draft"
}
EOF

cat >"$TASK/$SLUG.ghul" <<'EOF'
use IO.Std.write_line;

write_line("not written yet");
EOF

mkdir -p "$TEST"
cp "$ROOT/integration-tests/template/test.ghulproj" "$TEST/test.ghulproj"
ln -s "../../tasks/$SLUG/$SLUG.ghul" "$TEST/$SLUG.ghul"

for f in ghulflags err.expected warn.expected run.expected ; do
    : >"$TEST/$f"
done

echo "created tasks/$SLUG and integration-tests/$SLUG"
echo
echo "write the solution, then:"
echo "    dotnet run --project tasks/$SLUG"
echo "    dotnet ghul-test --use-dotnet-build integration-tests/$SLUG"
echo "    integration-tests/capture.sh integration-tests/$SLUG"
