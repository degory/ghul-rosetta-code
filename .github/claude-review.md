# Cloud code review brief

What this repository is, and what to watch for in it. Everything else - what PR
context is available, how to post a review, what makes a finding worth raising,
comment hygiene, PR-description shape, the versioning mechanism - comes from the
review workflow's runtime notes. Don't restate it here: this file is read first,
so a stale copy would silently override the current text.

Not loaded by local Claude Code; only the cloud reviewer reads this.

## What this repo is

`ghul-rosetta-code` holds ghūl solutions to [Rosetta Code](https://rosettacode.org)
tasks. Each is a runnable project under `tasks/<slug>/` with a `run.expected`
snapshot of what the program prints, so a compiler change that breaks a posted
solution fails a test here rather than leaving a wrong answer on a public page.
`TASKS.json` is the ledger recording every task that has been solved, queued,
rejected or blocked, and why.

A solution is posted to a wiki page beside implementations in fifty other
languages, under the maintainer's account, and is read far more often than it is
run. So the diff's audience is a stranger reading the page, not a maintainer
reading the repository, and that is the standard to hold it to.

`AGENTS.md` is the authority on how a solution is written, and `STYLE.md` from
`degory/ghul-style` governs its identifiers and this repository's prose. Read both
rather than restating them here.

## What to watch for here

- **The solution answers the task as stated.** Solving a tidier nearby problem,
  or skipping a part of the task's wording that looks arbitrary, is the single
  thing most likely to draw an objection on the wiki. The task's own text is
  linked from `tasks/<slug>/task.json`.
- **`run.expected` is what the task asks for.** It is captured from whatever the
  program printed, so a wrong answer becomes the permanent expectation and every
  later run agrees with it. Read it as output, not as a fixture.
- **A test that is not deterministic.** A clock, a local path, an unseeded
  generator, or an input fetched over the network at build time.
- **C# with odd syntax.** A pipe chain written as nested calls, a class where
  three functions would do, `is` ... `si` where an expression body fits, a type
  written where inference already has it. An entry that a reader could reach from
  the C# entry by swapping keywords had no reason to be written.
- **Comments.** Solutions carry none. The bar for an exception is that the
  maintainer could defend it on the talk page by pointing at the code beneath it.
- **A compiler bug worked around rather than reported.** A solution reshaped to
  avoid a bug ships the workaround to the wiki, where it outlives the bug. The
  task is marked blocked against an issue in `degory/ghul` instead.
- **Line width.** 64 columns is the aim and 76 the limit, because the page renders
  the code in a fixed-width block and ghul.dev in a narrower prose column.
- **Statement terminators.** Sources here carry none: the line break is the
  terminator, and a `;` at the end of a line is a finding.

## Versioning

This repository publishes nothing and has no `VERSION` file. Version bumps are not
a concern here.
