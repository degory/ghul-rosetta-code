ghūl catches most of the classic mistakes at compile time: there is no implicit
conversion between numeric types, an optional value cannot be used until it has
been tested, a variable declared with `let` cannot be reassigned unless it says
`mut`, and `==` is rejected on structs. What is left are constructs that compile
and run, and do something other than what they look like they do. Four of them
follow, each with what to do instead.

`==` on two strings asks whether they are the same object. Two literals with the
same spelling usually are, so the comparison looks right until one side is read
from a file or built at run time. `=~` compares the characters.

Two string literals separated only by white space are one literal, so a comma
left out of a list of strings joins two elements instead of failing to compile.
A `;` between them keeps them apart, and reading the count is the cheap check.

`byte` is the signed type and `ubyte` the unsigned one, the reverse of .NET's
names for the same two types. Code that reads binary data wants `ubyte`.

A pipe is a cursor over its source. Reading part of it and then reading it
again carries on from where the last read stopped; it starts over only once it
has run out. Collect a pipe into a list when it is going to be read more than
once.
