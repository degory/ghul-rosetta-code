# ghūl solutions for Rosetta Code

Working repository for [ghūl](https://ghul.dev) solutions to [Rosetta Code](https://rosettacode.org)
tasks. Every solution is written, built and run here, and its output captured as a test, before it
is posted to the wiki. Nothing goes up untested, and a compiler or runtime change that breaks a
posted solution shows up as a failing test rather than as a wrong answer sitting on a wiki page
nobody re-reads.

## layout

- `tasks/<slug>/` - one runnable .NET project per Rosetta task. The slug is the task title
  lowercased with runs of non-alphanumeric characters collapsed to a hyphen, so `Hello world/Text`
  is `hello-world-text`.
- `tasks/<slug>/task.json` - the task's title, its wiki URL, and whether the solution is a draft
  or has been posted.
- `integration-tests/<slug>/` - the matching test. The task's source is symlinked in, and
  `run.expected` holds the output the program must produce.
- `rosetta-code.ghulproj` and `root/entry.ghul` - a stub that names every task's source so the
  editor loads them all in one analysis session. It is not buildable: each task is a program in
  its own right, so compiling them together reports duplicate entry points. That only affects a
  root build, which nothing needs - analysis mode does not run code generation, so the editor is
  unaffected. Build and run tasks individually.
- `scripts/new-task.sh` - scaffolds a task and its test.
- `GHUL.md` - language reference, a copy of the master in the
  [`ghul`](https://github.com/degory/ghul) repo. Refresh it when it falls behind; never edit it
  here.

## adding a task

```sh
scripts/new-task.sh binary-digits "Binary digits"
```

Write the solution in `tasks/binary-digits/binary-digits.ghul`, then run it and capture what it
prints:

```sh
dotnet run --project tasks/binary-digits
dotnet ghul-test --use-dotnet-build integration-tests/binary-digits
integration-tests/capture.sh integration-tests/binary-digits
```

`capture.sh` promotes the produced output to `run.expected`. Read the output first and satisfy
yourself it is what the task asks for - capturing is how a wrong answer becomes a permanent
expectation.

Run everything with:

```sh
dotnet ghul-test --use-dotnet-build integration-tests
```

The tests assert the program's output only. There are deliberately no IL snapshots: a test folder
with no `il.expected` has its IL ignored.

## writing solutions for the wiki

The wiki page is the audience, so the solution has to read well standing on its own, next to
implementations in fifty other languages.

- Do what the task says, including the parts that look arbitrary. Solving a tidier nearby problem
  is the main thing that irritates reviewers there.
- Keep the program self-contained and free of scaffolding a reader has to skip past.
- Prefer the idiomatic ghūl over the shortest ghūl, and over a transliteration of the C# entry
  above it on the same page.
- Keep the output deterministic. No clocks, no random numbers, no paths.
- Rosetta Code's syntax highlighter has no ghūl lexer, so post the code in a
  `<syntaxhighlight lang="text">` block. Follow it with the real captured output in a `{{out}}`
  block.

## status

`task.json` records whether each solution is a `draft` or has been `published` to the wiki. Keep
it current: it is the only record of what is already up there.

## licensing

The contents of this repository are MIT licensed, per `LICENSE`. Text and code posted to Rosetta
Code are additionally licensed under that site's own terms, so post only what you are willing to
license that way.
