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
- `tasks/<slug>/task.json` - the task's title, its wiki URL, and a copy of its state from the
  ledger.
- `integration-tests/<slug>/` - the matching test. The task's source is symlinked in, and
  `run.expected` holds the output the program must produce.
- `rosetta-code.ghulproj` and `root/entry.ghul` - a stub that names every task's source so the
  editor loads them all in one analysis session. It is not buildable: each task is a program in
  its own right, so compiling them together reports duplicate entry points. That only affects a
  root build, which nothing needs - analysis mode does not run code generation, so the editor is
  unaffected. Build and run tasks individually.
- `TASKS.json` - the ledger: every task that has been done, queued, rejected or blocked, and why.
- `scripts/new-task.sh` - scaffolds a task and its test.
- `tools/rosetta/` - the ledger and the wiki client.
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

## showing a task more than one way

Some tasks are worth showing twice - the built-in one-liner, and the same thing written out. Those
are held as **parts**: numbered sub-projects of the task, each a whole program with its own test.

```sh
scripts/new-part.sh apply-a-callback-to-an-array 01-using-map
```

```
tasks/apply-a-callback-to-an-array/
    task.json
    01-using-map/           a whole program, with its own .ghulproj
    02-writing-apply/
integration-tests/apply-a-callback-to-an-array-01-using-map/
integration-tests/apply-a-callback-to-an-array-02-writing-apply/
```

Each part becomes one `===heading===` section of the entry, with its own source and its own output,
in the order the numbers give. The heading comes from the directory name, so `01-using-map` is
"Using map". A task with parts has no source of its own: move the existing one into a part and
delete the task's `.ghulproj` and `ghul.json`, or the two projects collide over the entry point.

Parts are for a task that genuinely reads better as two entries. A solution that simply prints
several things is one part.

## Getting the markup to paste

```sh
scripts/generate-wiki.sh --all           # writes wiki-out/<slug>.wiki for every working task
scripts/generate-wiki.sh y-combinator    # one task, to stdout
```

Each file is the complete section: the `{{header|ghul}}` heading, the source in a
`<syntaxhighlight>` block, and the program's output in a `{{out}}` block. The source is read from
the task and the output comes from running it, so an edited solution can be generated straight
away with nothing to update in between. Where that output differs from the test's `run.expected`,
the entry is still emitted and the difference is reported on stderr - the test needs recapturing,
which is worth knowing but is not a reason to withhold the markup.

`--all` prints the task's wiki URL beside each file. The single-task form prints the URL to stderr,
so stdout stays exactly what goes on the page and can be piped:

```sh
scripts/generate-wiki.sh y-combinator | xclip -selection clipboard
```

A task whose test carries a `disabled` marker is skipped rather than emitted, as is one that
fails to build or run - an entry that does not run should not be posted.

`rosetta publish` puts these on the wiki. To paste one by hand instead, it goes in alphabetical
position among the language headers: `ghul` sorts after `Genie` and before `Go`. Either way, run
`rosetta sync` afterwards so the ledger records it.

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
- Prefer the idiomatic ghūl over the shortest ghūl, and over a transliteration of the page's C#
  entry: thread with `|>` and the global pipe functions rather than the
  fluent methods, prefer functions to classes and expression bodies to blocks, and use the
  constructs the language next door has no word for. `AGENTS.md` has the detail.
- Keep the output deterministic. No clocks, no random numbers, no paths.
- Keep lines under 64 columns, and never past 76. A solution is read in a fixed-width block on
  Rosetta Code and in a prose column about 77 characters wide on ghul.dev, so anything longer
  scrolls out of sight. `scripts/check-width.sh` reports the offenders.
- Rosetta Code's syntax highlighter has no ghūl lexer, so the code goes in a
  `<syntaxhighlight lang="ghul">` block, which it renders unhighlighted rather than rejecting.
  Follow it with the real captured output in a `{{out}}` block.

## status

`TASKS.json` is the ledger: one entry per task that has been done or decided about, keyed by its
Rosetta Code title.

| state | meaning |
|-------|---------|
| `queued` | picked to work on, not written yet |
| `solved` | written and tested here, not on the wiki |
| `published` | on the wiki |
| `rejected` | will not be attempted; `reason` says why, and it is not revisited |
| `blocked` | cannot be written yet; `reason` names the issue, and it is revisited when that closes |

A rejection is a decision, not a note to self, so it carries one of a fixed set of reasons:
`needs-gui`, `needs-network`, `needs-interaction`, `nondeterministic`, `needs-native-lib`,
`output-unbounded`, `task-unclear`. The point of writing it down is that the same task is never assessed twice.

Only tasks that have been judged are in the file. The 1300-odd others are whatever
`Category:Programming Tasks` holds that the ledger does not mention.

Each `task.json` carries a copy of its own task's state, because that is what
`scripts/generate-wiki.sh` reads. `rosetta sync` writes it from the ledger; don't edit it by hand.

## the rosetta tool

`tools/rosetta` is the ledger and the wiki client.

```sh
dotnet run --project tools/rosetta -- self-test         # feed the guards the damage they exist to stop
dotnet run --project tools/rosetta -- sync              # reconcile the ledger with the wiki and with tasks/
dotnet run --project tools/rosetta -- candidates 20     # tasks nothing has been decided about
dotnet run --project tools/rosetta -- show solved       # ledger entries, all or in one state
dotnet run --project tools/rosetta -- set "Zig-zag matrix" rejected needs-gui
dotnet run --project tools/rosetta -- publish --dry-run # where each entry would go, and the page it would leave
dotnet run --project tools/rosetta -- publish --target "Rosetta Code:Sandbox"   # a real run, written somewhere harmless
dotnet run --project tools/rosetta -- publish amb       # post one task, by slug
dotnet run --project tools/rosetta -- publish --replace amb   # replace the ghul section already there
dotnet run --project tools/rosetta -- publish           # post every solved task
```

`sync` treats the wiki as the authority on what is published and `tasks/` as the authority on
what has a solution, and leaves alone anything only the ledger knows - a rejection, a block.

`publish` reads the markup `scripts/generate-wiki.sh --all` leaves in `wiki-out/`, so generate
before publishing. It puts the section in case-insensitive alphabetical position among the
page's other language headers, or replaces the ghul section already there. Naming one or more
slugs publishes only those; with none, every solved task goes. A dry run writes the whole
proposed page to `wiki-out/<slug>.page` for reading before anything is sent.

Re-publishing an improved solution needs `--replace`, and the refusal that makes it necessary is
worth understanding before reaching for it. A replacement is refused unless the section on the
wiki is the one this repository last published, because a section that has changed since may
carry somebody else's correction, and replacing it silently throws their work away - which is
what happened to an edit on Multiton the first time this ran. The check cannot tell that case
from an ordinary local improvement, so it fires on both. What is on the wiki is written to
`wiki-out/<slug>.live`: read it against `wiki-out/<slug>.wiki` and satisfy yourself the only
differences are the ones made here, then re-run with `--replace`. A difference that came from
the wiki belongs in the repository, not in the bin.

`--target <page>` sends every write to one page instead of to the task pages. The rest of the
run is unchanged - it signs in, fetches the real task page and splices against its real language
headers - so pointing it at a sandbox exercises the whole path and leaves only the destination
untested. The ledger is not advanced by a targeted run, since nothing was published.

Before anything is sent, the spliced page is checked against the page it came from in two ways.

The first asks the page rather than the splice: every language section that was there has to
still be there, and ghul has to be one of them. This is the check that matters, and the reason it
ignores where the splice thought the section was going is that a guard built on the splice's own
reasoning shares the splice's mistakes - a placement claiming the whole page satisfies a
prefix-and-suffix comparison trivially, both halves being empty.

The second is that comparison anyway: everything
before where the section goes has to survive unchanged, and so does everything after whatever it
replaces. A splice that fails that is refused rather than saved, so a wrong answer shows up as a
task that did not publish instead of as a damaged page. A dry run applies the same checks, so
the whole batch can be cleared without an edit.

The third check is the wiki's own. Before the edit is offered for real, `action=compare` diffs
the stored revision against the text it would receive, and the run stops if that diff removes
more than the ghul section being replaced - nothing at all, for an insertion. This is the only
check the splice does not mark its own homework on, and it is the one to keep if the others ever
look redundant.

A section containing an external link is refused before it is sent. Rosetta Code answers an edit
that adds a new external link with an hCaptcha, and a captcha is the one refusal this cannot get
past - there is nobody to answer it. No solution needs a URL in it, so the fix is to take the
link out rather than to handle the refusal.

The target has to be a page that already exists, because the credential is granted editing and
not creation. `Rosetta Code:Sandbox` does; a `User:<name>/sandbox` subpage keeps the noise off a
shared page but has to be created by hand once.

### credentials

Publishing signs in with a credential from
[Special:BotPasswords](https://rosettacode.org/wiki/Special:BotPasswords) on an account that can
already edit, granted **Edit existing pages** and nothing else. Write it to
`~/secrets/rosetta-code-bot`, the user on the first line and the password on the second, and
`chmod 600` it. Set `ROSETTA_CREDENTIALS` to use a different path.

The password that page issues is shown once. Edits appear in page history under the underlying
account, not as a separate bot: this is a way to drive an account's own edits, not an identity of
its own.

## licensing

The contents of this repository are MIT licensed, per `LICENSE`. Text and code posted to Rosetta
Code are additionally licensed under that site's own terms, so post only what you are willing to
license that way.
