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
- The test has to be deterministic, which is not the same as the task being deterministic. A task
  built on randomness seeds its generator, or asserts the invariant the task is about - a cipher
  round-tripping, a generated position being legal - and prints that. A task whose input is a
  remote file ships the file here instead of fetching it: a fetched input makes the build depend
  on somebody else's uptime, and silently pins a wrong answer when the file changes.
- No clocks and no local paths, which have no reproducible form at all.

## The style guide applies here

[`STYLE.md`](https://github.com/degory/ghul-style/blob/main/STYLE.md) in
[degory/ghul-style](https://github.com/degory/ghul-style) holds the terminology, tone and
code-style rules for everything in the ghūl ecosystem that a person reads. It was written for
`ghul-examples` and `ghul-dev`, and it governs the solutions here too: they are posted to a public
wiki, and they are carried on ghul.dev as runnable examples, so a reader meets them in the same
places they meet everything else that guide covers.

Read it before writing a solution or editing this repository's prose. What it asks for most often:

- **Ordinary domain words for identifiers.** `running_totals`, `smallest_factor`, `left`, `right`.
  Not abbreviations, and not an alias that shortens a name the reader already knows - `use wl =
  IO.Std.write_line` saves eight characters and costs every reader the lookup. A single letter is
  right only where the task itself uses it, or where it is the notation the problem is stated in.
- **Its vocabulary rules**, in the repository's prose and in a solution's identifiers alike:
  *anonymous function* rather than *lambda*, *local variable* rather than *binding* for what `let`
  defines. Each rule is about a sense rather than a spelling, and the guide says how to tell.
- **Its register** for `README.md` and for anything else here a person reads: plain declarative
  sentences, the mechanism as the subject, no em-dashes.

Three of its sections do not apply, because this repository's own rules are stricter or its
programs are shaped differently:

- **Code comments.** The guide says when to comment and how; "Solutions carry no comments" below
  says not to, and that wins. The guide's comment rules apply to this file, `README.md`, and the
  tooling under `tools/` and `scripts/`.
- **`entry()` first, with the work in named subroutines.** That is the shape of a tour file in
  `ghul-examples`. A solution here is a program with top-level statements.
- **Its "imitate these" and "flag these" lists.** Both name files in other repositories.

`AGENTS.md` is written for agents rather than for users, which the guide exempts from its register
rules; the vocabulary rules still apply to it.

## Write ghūl, not C# with odd syntax

Most of these pages carry a C# entry, and the two languages are close enough
that a reader could get from ours to theirs by swapping keywords. When that is
true of an entry, it is showing them nothing, and there was no reason to write
it.

So, in rough order of how often it comes up:

- **Thread with `|>` and the global pipe functions.** They are global
  functions and `Pipe[T]` declares none of its own, so a chain of them either
  threads or nests, and here it threads:
  `xs |> map(f) |> filter(p) |> join(", ")`, never
  `join(filter(map(xs, f), p), ", ")`.
- **Lean towards functions, but use the right tool.** A class earns its place
  when the task is itself about objects, when state and the operations on it
  belong together - a bitmap and its pixels, a parser and its cursor - or when
  it is otherwise plainly clearer than the alternative. What the lean is
  against is the class that carries no weight: two fields and one method where
  three functions would do is a transliteration of somebody else's entry, not
  encapsulation.
- **Prefer an expression body.** `=>` over `is` ... `si` wherever the body is an
  expression, including where that expression is an `if`, a `case`, or a block.
  Write a block expression parenthesised rather than with `val` ... `lav`: the
  two mean the same thing, and the parentheses are the spelling a reader from
  any language recognises as an expression. Where the block is the body of a
  `=>` or the right-hand side of an `=`, keep the opening paren on the same line
  as that token where practical:

```ghul
let total = (let acc mut = 0
             for x in xs do acc = acc + x od
             acc)
```

- **Reach for what has no equivalent in the language next door.** `let x = e in`
  and `assert c else "..." in` as expressions, `if let` and `while let` in place
  of a test followed by a cast, unions with `case` pattern matching in place of
  a class hierarchy and a chain of type tests, generators in place of building a
  list to return, `rec` for a recursive function literal.

None of this is a licence to be clever. A solution that reaches for a construct
it does not need is as bad as one that reaches for none of them; the point is
that where ghūl has its own way of saying something, the entry should say it
that way.

## Write a type once

The compiler infers a local variable's type from its initializer and from how the variable is
used later in the same body, and a constructor's type arguments from its arguments, from the slot
the value goes into, and from later use. So most types in a solution need not be written, and a
type that is written where inference already has it is noise a reader has to check.

```ghul
let seen = SET()
seen.add(first)               // seen is SET[int]

let counts = MAP()
counts[word] = counts[word] + 1

let total = cast(count) * 2n     // the 2n operand pins the cast
```

Where a type does have to be written, write it once, at the site that needs it:

- On the constructor (`LIST[int]()`) rather than on the local, when nothing later pins the
  element type - a list that is only printed, say. A local declared at an interface type
  (`let rows: List[int] = LIST()`) is the exception: the annotation is the point, so it stays and
  the constructor's arguments go.
- On the cast (`cast bigint(n)`) where no slot pins the target, rather than moving it to a `let`
  annotation. Where a slot does pin it - a typed initializer, an assignment, a return, an operand,
  an argument to a function with one applicable overload - `cast(n)` is enough.
- A `bigint` value from an integer literal is the literal with an `n` suffix (`1n`, `1000000n`),
  never `cast bigint(1)` or `bigint.one`. From an integer expression it is `cast(value)` where the
  slot pins it, and otherwise the constructor `bigint(value)`; a solution should use one of those
  two throughout rather than both.

Removing a type is the aim, moving it is not: a `LIST()` that only compiles once the local gains an
annotation has not gained anything, and the original spelling stays. Keep one solution consistent
with itself - `LIST[int]()` on one line and `LIST()` a few lines down, for no reason a reader can
see, is worse than either alone.

## Solutions are not marked `pure`

The pipe combinators take pure functions, and most of what a solution passes them is not provably
one, so `map` and `reduce` draw `impure-function-argument`. The fix is not to mark the solution's
helpers `pure`. That warning is advice - the call it sits on is judged on its own callee either
way - and a `pure` written only to silence it puts a keyword on a public wiki page that says
nothing about the task, in a repository that does not apply it anywhere else. It is suppressed in
`Directory.Build.props`, for every task and for the aggregate project alike.

`impure-function-value` is a different warning and is not suppressed: it fires where a function
that might store is put into a slot declared pure, and something downstream is then entitled to
trust it. If one appears, fix the code.

## A suspected bug is not a reason to change the solution

A solution producing unexpected output through a pipe chain is not evidence
that the pipe machinery is broken. The first step is a minimal repro outside
the solution. Most suspected bugs turn out to be the solution's own: an
exclusive `..` range that counts one element short, an operator-precedence
surprise, a misread of the task text.

When a minimal repro reproduces the problem outside the solution, it is a
compiler bug, and a Rosetta Code entry is not the place to work around one.
Raise it in degory/ghul, mark the task blocked against the issue, and move
on to the next task. Rewriting the solution as an imperative loop instead
ships the workaround to the wiki, where it outlives the bug and teaches
readers an idiom that does not exist.

This is not a ban on imperative loops. A loop is the natural shape of some
tasks and the right choice there. It is the wrong choice when a pipe chain
is the natural shape and the only reason for the loop is a bug that has not
been confirmed.

## Solutions carry no statement terminators

A statement's terminator can be left off at the end of a line, and here it always is. The line
break is the terminator. `rosetta-code.ghulproj` compiles every solution with
`--warn redundant-semicolon`, so a root `dotnet build` reports a stray `;` wherever it is. Nothing
else does - CI builds each task through its own project, and those do not carry the flag - so run
that build before opening a pull request.

```ghul
use IO.Std.write_line

binary(value: int) -> string =>
    if value < 2 then "{value}" else "{binary(value / 2)}{value % 2}" fi

for value in [5, 50, 9000] do
    write_line(binary(value))
od
```

Two statements on one line still need the `;` between them, and so does a statement that ends on a
string literal followed by one that begins with one - without it the two literals chain into a
single literal across the line break. Both are rare enough in a solution that meeting one is a
reason to look at the line again. `GHUL.md`'s "statement terminators" section has the rules that
keep a wrapped expression unambiguous; the ones that come up here are that a continuation line
opens with `.` or `|>`, and that a wrapped operator expression carries the operator at the end
of the line rather than the start of the next.

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

The compiler's formatter can do the wrapping where an expression is simply long. `--format-width`
gives it the column to wrap at, since it targets 100 by default, and `--format-in-place` rewrites
the file rather than printing to standard output:

```sh
dotnet ghul-compiler --format --format-width 76 tasks/<slug>/<slug>.ghul
```

Both flags need `--format` alongside them; on its own, `--format-width` sets a width for a run that
then does not format anything.

**Its output carries statement terminators**, which this repository's sources do not
(degory/ghul#2298), so it cannot be used unattended here: strip them from what it produces before
keeping it. Read the result in any case - the formatter is faithful but it is not the author, and a
solution's line breaks are often deliberate.

Where a line is long because of what it says rather than how it is laid out, break it up: a local
variable for a sub-expression usually reads better than a continuation, and a long string of
output is better built than written out.

## Reaching shared state from a function

A solution with no `namespace` runs its top-level statements as the entry point,
and a `let` written there is visible to the named functions declared in the same
file as well as to the statements after it. A function can be written above or
below the `let` it reads, since it runs only when called; the statements run in
order, so one placed above the `let` cannot read it.

```ghul
let rows = ["one", "three", "seventeen"]

widest() -> int =>
    rows |> reduce(0, (w, r) => if r.length > w then r.length else w fi)

write_line("{widest()}")
```

A bare `let` cannot be reassigned anywhere; a `let ... mut` can be reassigned
from later statements and from functions alike. Prefer the bare form and mutate
what it holds - a list, a map - rather than reassigning it, so nothing in the
file is written from two places.

Neither is a reason to move a solution's working data to the top level just so
named functions can be written. Passing what a function needs as an argument is
usually shorter, and always clearer.

The case that tempts a top-level `let ... mut` hardest is a helper that has to
carry state from one call to the next - a cursor into a buffer, a running total
- because ghūl has no nested function definitions and there is nowhere obvious
to put it. There is: a function literal in a local variable. A `let ... mut` is
captured by reference, so the helper reads and writes the enclosing function's
own state directly.

```ghul
read_ppm(path: string) -> BITMAP is
    let raw = IO.File.read_all_bytes(path)

    let at mut = 0

    let token = () -> string is
        let from = at

        while at < raw.count /\ !space(raw[at]) do
            at = at + 1
        od

        return text(raw, from, at)
    si

    assert token() =~ "P6" else "not a binary PPM"

    ...
si
```

The cursor stays where it belongs, and nothing outside `read_ppm` can reach it.
A helper that needs no state of its own is a global function taking what it
reads as an argument, as `space` is here.

Where the state and the operations on it are the subject rather than a detail
of one function - a bitmap that is filled, written and read back - a class says
so more plainly than either, and is the right answer. The preference for
functions is a lean, not a rule; see "Lean towards functions" above.

## Solutions carry no comments

**The default is no comments at all.** Look at the Go entries on any task page:
they carry none, and they are none the worse for it. A solution here is a short
program a reader is already looking straight at, so a comment has to displace
code that is right there in front of them to be worth its space, and almost
none do.

That is the rule, not a starting position to argue against. Do not explain what
the task is, do not narrate the algorithm, do not name the technique, and do not
justify why the code is shaped the way it is. If the code needs a sentence to be
followed, the fix is usually to write the code more plainly.

The bar for the rare exception is high, because everything here goes on a public
wiki under the account of the person who posts it. They will be taken to have
written it, and if a contributor disputes a claim on the talk page, they are the
one who has to answer. So a comment must be something they could defend,
unprompted, by pointing at the code beneath it - never a claim about the field,
its history, or what another language does, and never a term whose only job is
to show the term is known.

Two failures are worth naming because they keep recurring. A comment that
apologises for the language - explaining why the code is contorted, or what it
would look like if the compiler could express the thing directly - means the
entry should not be posted at all: park the task against the issue instead. And
mathematical notation is not neutral: `a^b` reads as the xor operator, so write
what the code actually spells.

## Adding a task

```sh
scripts/new-task.sh <slug> "<Rosetta task title>"
```

Then write the solution, run it, and capture the output:

```sh
dotnet run --project tasks/<slug>
dotnet ghul-test --use-dotnet-build tasks/<slug>
scripts/capture.sh tasks/<slug>
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

A rejection can also be reversed, when what made the task impossible stops being true. That is
`reopen`, and it takes the reason for the reversal rather than being a bare undo:

```sh
dotnet run --project tools/rosetta -- reopen "100 prisoners" "seeded, and the ~31% answer is the point"
```

The verdict being overturned is written into the entry's note, so a later run reads why the old
reason no longer holds instead of re-reaching it. Reopening without saying what changed just
sets the task up to be rejected again.

## Publishing, and the record of it

```sh
scripts/publish.sh <slug>...      # or --solved, for everything not yet on the wiki
```

That one command generates the markup, makes the edits, commits the digests the run wrote into
`TASKS.json`, pushes, and opens the pull request. Do not run `rosetta publish` directly, and do not
publish and leave the record to be committed afterwards.

The digest is the whole reason. `publish` writes each page's new digest into the ledger as it goes,
and a later run compares the live section against it to tell an edit somebody else made from one of
ours: a section whose digest is not the recorded one is refused rather than overwritten. A record
that never reaches `main` therefore does not merely go missing. It leaves every page it covers
unpublishable, and the refusal that follows months later reads as though a stranger had edited a
hundred pages at once.

The pull request needs nothing from anybody. `.github/workflows/ledger.yml` approves a change that
touches only `TASKS.json` and `tasks/*/task.json`, and auto-merge lands it when the shards pass.
That path test is the whole distinction between what lands unread and what does not, so a
ledger-only pull request must carry nothing else - not a compiler pin, not a recaptured
expectation, not a solution. Raise those separately.


## Showing a task more than one way

A task worth showing two ways - the library call, and the same thing written out - is held as
parts: `tasks/<slug>/NN-name/`, each a whole program with its own project and its own test, each
becoming one `===heading===` section of the entry. `scripts/new-part.sh <slug> <NN-name>` scaffolds
one. `README.md` has the layout.

Reach for it when the two ways are genuinely different things a reader would want to see side by
side. A solution that prints several results is one part, not several.

## Test requirements

The integration tests must pass before opening a pull request. They are what CI runs, and they
build each task as they go.

| Step | How to run | Typical duration |
|------|-----------|------------------|
| Integration tests | `dotnet ghul-test --use-dotnet-build tasks` | seconds to minutes |

A root `dotnet build` type-checks every solution in one pass and is the only thing that reports a
stray statement terminator, so it is worth running, but it produces none of the programs - see
"The root project" below. Build and run a single task with `dotnet run --project tasks/<slug>`.

- Each task directory is its own test case: the `ghulflags` and `*.expected` files sit beside
  the source. `scripts/new-task.sh` and `scripts/new-part.sh` scaffold them.
- Tests assert the program's output. There are deliberately no IL snapshots - a test folder with
  no `il.expected` has its IL ignored, and `capture.sh` will not create one.
- A failing test is your change. This repository's tests are pinned to output that was read and
  captured deliberately, so a failure means either the solution changed or the compiler did. Find
  out which before touching an expectation file.

## The root project

`rosetta-code.ghulproj`, with `root/entry.ghul`, names every task's source so the ghūl VS Code
extension loads them in one analysis session.

**It builds, and it produces none of the programs.** Every task carries its own top-level
statements, so an aggregate of them all has no single entry point to run: the project takes
`OutputType` `Library` and an `--entry root_entry` stub, and suppresses the
`top-level-statements-not-run` warning each task would otherwise draw. What the build is good for
is type-checking every solution at once and reporting stray statement terminators. CI does not run
it - each task is built by its own test project.

Don't try to make the tasks build together as programs by wrapping solutions in an `entry()`
function. A task's source should read the way it will read on the wiki, and top-level statements
are the reason a ghūl entry there needs no wrapper at all.

## Keeping GHUL.md in sync

`GHUL.md` is not authored here. The master copy is `GHUL.md` in the
[`ghul`](https://github.com/degory/ghul) compiler repo. Refresh the copy here when it has fallen
behind and you are already touching this repository; never hand-edit it to correct a language
reference error, fix it in the compiler repo instead.

## See also

- [README.md](./README.md) - layout and workflow
- [GHUL.md](./GHUL.md) - language reference
