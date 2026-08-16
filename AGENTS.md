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

## Comments are published under someone else's name

Everything here goes on a public wiki under the account of the person who posts
it. They will be taken to have written it, and if a contributor disputes a claim
on the talk page, they are the one who has to answer.

So the standard for a comment is not "true". It is **"the person posting this
could explain it, unprompted, to someone who challenged it"**. A sentence that
is correct but that they would have to go and research before defending is worse
than no sentence, because it reads as expertise being claimed rather than
exercised. Under-claim.

That gives a few concrete rules:

- **Say what the code does and why it is shaped that way.** Those are claims a
  reader checks against the code sitting in front of them, and the author can
  defend by pointing at it.
- **Don't assert facts about a field** - its terminology, its history, who
  invented what, what another language does - unless the task page itself says
  so. Where it does, that is a citable source and using it is fine.
- **Don't name a concept to show it has a name.** If the name does no work for a
  reader who does not already know it, it is decoration. If it does real work,
  it also has to be defensible.
- **Never carry over a claim from a review, a paper or anywhere else that you
  cannot verify from the code.** Borrowed authority is exactly what fails on a
  talk page: the author cannot say where it came from.
- **Prefer the plain word.** Where a plain description and a technical term both
  work, the plain description is not a simplification, it is the better comment.
  "It would call itself forever" beats "it diverges".

Worked example. This was written for the Y combinator entry and is accurate:

> Its field is the roll and unroll of that recursive type, not mutable state.

and this says the part that matters, checkably:

> The field is set once, by the constructor, and never changes.

The first asks the reader to know what an iso-recursive type is, and asks the
author to defend that framing. The second is verifiable by looking three lines
down.

Ask, before every comment: *if someone replies "why do you say that?", is the
answer in the file?*

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

Then record it in the ledger:

```sh
dotnet run --project tools/rosetta -- sync
```

`TASKS.json` is the authority on what has been done and what has been decided against. Never
edit a `task.json` status by hand - `sync` writes it. When a task turns out not to be worth
doing, say so once and for all rather than leaving it to be reassessed:

```sh
dotnet run --project tools/rosetta -- set "Animate a pendulum" rejected needs-gui
```

The reasons are a fixed set - `needs-gui`, `needs-network`, `needs-interaction`,
`nondeterministic`, `needs-native-lib`, `output-unbounded`, `task-unclear` - and `blocked` is the one state that
comes back: it names a compiler or runtime issue and is retried when that closes.

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
