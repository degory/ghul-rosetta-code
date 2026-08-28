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

## Write ghūl, not C# with odd syntax

Most of these pages carry a C# entry, and the two languages are close enough
that a reader could get from ours to theirs by swapping keywords. When that is
true of an entry, it is showing them nothing, and there was no reason to write
it.

So, in rough order of how often it comes up:

- **Thread with `|>` and the global pipe functions**, not `|` and the fluent
  methods. `xs |> map(f) |> filter(p) |> join(", ")` over
  `xs | .map(f) | .filter(p) | .join(", ")`. Both compile and mean the same
  thing; the first is the one that reads as this language rather than as LINQ.
- **Prefer functions to classes.** A class earns its place when the task is
  itself about objects, or when it is plainly clearer than the alternative.
  A task solved with a class holding two fields and one method, where three
  functions would do, is a transliteration of somebody else's entry.
- **Prefer an expression body.** `=>` over `is` ... `si` wherever the body is an
  expression, including where that expression is an `if`, a `case`, or a
  `val` ... `lav` block.
- **Reach for what has no equivalent in the language next door.** `let x = e in`
  and `assert c else "..." in` as expressions, `if let` and `while let` in place
  of a test followed by a cast, unions with `case` pattern matching in place of
  a class hierarchy and a chain of type tests, generators in place of building a
  list to return, `rec` for a recursive function literal.

None of this is a licence to be clever. A solution that reaches for a construct
it does not need is as bad as one that reaches for none of them; the point is
that where ghūl has its own way of saying something, the entry should say it
that way.

## Keep lines narrow

A solution is read in a column, not in your editor: on Rosetta Code it sits in a fixed-width block,
and on ghul.dev it sits in a prose column narrower than that. A line that runs past the edge either
wraps in the middle of an expression or scrolls out of sight, and neither reads well.

**Aim for 64 columns. Never exceed 76.** Those come from where the code is read rather than from
habit. ghul.dev renders an example in a prose column about 77 characters wide at the size it uses,
so a line past that scrolls out of sight - and the examples written for that site sit well inside
it, 99% of their lines at 68 columns or less. The usual 80 and 100 are already too wide here.

```sh
scripts/check-width.sh            # every line over the limits, worst first
```

The compiler's formatter can do the wrapping where an expression is simply long, though it targets
100 columns and cannot yet be told otherwise (degory/ghul#2191), so it will not get a line under 76
on its own:

```sh
dotnet ghul-compiler --format tasks/<slug>/<slug>.ghul
```

It writes to standard output rather than rewriting the file, so redirect it somewhere and compare
before replacing anything - the formatter is faithful but it is not the author, and a solution's
line breaks are often deliberate.

Where a line is long because of what it says rather than how it is laid out, break it up: a local
variable for a sub-expression usually reads better than a continuation, and a long string of
output is better built than written out.

## Reaching shared state from a function

A solution with no `namespace` runs its top-level statements as the entry point,
and a `let` written there is a local **of that entry point**. A named function
declared in the same file cannot see it, and says `symbol not found` - which
reads as though the name were misspelled rather than out of scope. Two patterns
get around it, and which one to reach for depends on the shape of the solution.

**A global variable**, written at the top level as a name and a type with no
`let`:

```ghul
rows: string[];

widest() -> int =>
    rows |> reduce(0, (w, r) => if r.length > w then r.length else w fi);

rows = ["one", "three", "seventeen"];

write_line("{widest()}");
```

It cannot carry an initializer, so it is declared in one place and assigned in
another, in the top-level statements. Definitions hoist above the statements, so
until the assignment runs the variable holds the default for its type - and a
function that reads it before then gets `null` or zero rather than a diagnostic.
Keep the assignment near the top of the statements for that reason.

**A function literal in a `let`**, which captures the other top-level locals the
same way any closure captures its enclosing scope:

```ghul
let rows = ["one", "three", "seventeen"];

let widest = (of_at_least: int) -> int =>
    rows |> filter(r => r.length >= of_at_least) |> reduce(0, ...);
```

Nothing is declared apart from where it is given a value, and nothing is
readable before it holds something. A literal takes explicit argument and return
types when they help - write them where the literal is long enough that the
reader would otherwise have to work its signature out, or where inference does
not get there on its own.

Prefer the literal. The global is the answer when the state is genuinely shared
across several functions, or when a named recursive function needs it; reaching
for it because a `let` did not resolve is how a solution ends up with a mutable
top-level variable it never needed.

Neither is a reason to move a solution's working data into a global just so
named functions can be written. Passing what a function needs as an argument is
usually shorter than either, and always clearer.

## Comments are published under someone else's name

**No comment at all beats a bad one.** That is the starting position, not a
last resort. A comment is worse than nothing when it is hard to read, when it
reaches for odd or academic terminology, when it reads as showing off, or when
it says what the line underneath already says. Most comments that get written
here fail at least one of those, so the question is not "is this comment true?"
but "does this earn the space it takes on the page?" - and usually the answer is
no, because the code is short and the reader is looking at it.

What survives that test is a fact the reader cannot get from the code in front
of them and would be misled without. Everything else comes out.

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

## Showing a task more than one way

A task worth showing two ways - the library call, and the same thing written out - is held as
parts: `tasks/<slug>/NN-name/`, each a whole program with its own project and its own test, each
becoming one `===heading===` section of the entry. `scripts/new-part.sh <slug> <NN-name>` scaffolds
one. `README.md` has the layout.

Reach for it when the two ways are genuinely different things a reader would want to see side by
side. A solution that prints several results is one part, not several.

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
