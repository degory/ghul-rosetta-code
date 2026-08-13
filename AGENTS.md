# AI Agent Guide for the ghūl Rosetta Code solutions

## Purpose

This guide is for AI agents and other automated contributors working in this repository. It holds
ghūl solutions to [Rosetta Code](https://rosettacode.org) tasks, which are written and tested here
before being posted to the wiki.

Read [README.md](./README.md) first for the layout and the workflow. Read
[GHUL.md](./GHUL.md) rather than working from what you remember of the language: the syntax is
unusual enough that a half-remembered version of it produces confident, wrong code, and the build
is where you find out.

## The wiki page is the audience

A solution here is not a test fixture that happens to be readable. It is the artefact that goes on
a public page beside implementations in fifty other languages, and it is read far more often than
it is run. So:

- Follow the task's own wording, including the parts that look arbitrary. Solving a tidier nearby
  problem is the single thing most likely to draw an objection there.
- No scaffolding. No commented-out alternatives, no unused helpers, no `// TODO`.
- Prefer idiomatic ghūl to short ghūl. If a generator, a pipe chain, a union or an `if let` is the
  natural way to express the task, use it - that is the reason for the entry existing.
- Comment only where a reader who does not know ghūl would otherwise misread the code. A comment
  explaining what the task is, or narrating the algorithm line by line, is noise.
- Output must be deterministic: no clocks, no random numbers, no local paths.

## Adding a task

```sh
scripts/new-task.sh <slug> "<Rosetta task title>"
```

Then write the solution, run it, and capture the output:

```sh
dotnet run --project tasks/<slug>
dotnet ghul-test --use-dotnet-build integration-tests/<slug>
integration-tests/capture.sh integration-tests/<slug>
```

Read the produced output before capturing it. `capture.sh` turns whatever the program printed into
the permanent expectation, so capturing without reading is how a wrong answer gets pinned as
correct.

Set `status` in the task's `task.json` to `published` only once the solution is actually on the
wiki, and record the wiki URL there.

## Test requirements

Both must pass before opening a pull request.

| Step | How to run | Typical duration |
|------|-----------|------------------|
| Build | `dotnet build` | seconds |
| Integration tests | `dotnet ghul-test --use-dotnet-build integration-tests` | seconds to minutes |

- One test folder per task, with the task's source symlinked in. Preserve the symlinks.
- Tests assert the program's output. There are deliberately no IL snapshots - a test folder with
  no `il.expected` has its IL ignored, and `capture.sh` will not create one.
- A failing test is your change. This repository's tests are pinned to output that was read and
  captured deliberately, so a failure means either the solution changed or the compiler did. Find
  out which before touching an expectation file.

## The root project

`rosetta-code.ghulproj`, with `root/entry.ghul`, names every task's source so the ghūl VS Code
extension loads them in one analysis session.

**It is not buildable, and that is expected.** Each task is a whole program, so compiling them
together reports `duplicate entrypoint` and the build dies with an error that names no file. Only
a root build is affected: analysis mode does not run code generation, so the editor is fine, and
CI builds each task through its own test project.

Don't try to fix it by wrapping solutions in an `entry()` function. A task's source should read
the way it will read on the wiki, and top-level statements are the reason a ghūl entry there needs
no wrapper at all.

## Keeping GHUL.md in sync

`GHUL.md` is not authored here. The master copy is `GHUL.md` in the
[`ghul`](https://github.com/degory/ghul) compiler repo. Refresh the copy here when it has fallen
behind and you are already touching this repository; never hand-edit it to correct a language
reference error, fix it in the compiler repo instead.

## See also

- [README.md](./README.md) - layout and workflow
- [GHUL.md](./GHUL.md) - language reference
