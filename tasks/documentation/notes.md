A comment that starts with three slashes, `///`, and is written directly above
a declaration documents that declaration. Pragmas can sit between the comment
and the declaration; a blank line or any other code can't. Classes, structs,
traits, unions, enums, functions, methods, properties and global variables can
all be documented this way.

The text is Markdown, and is kept as written apart from the `///` and one space
at the start of each line. Arguments are described in a bullet list, one
`- name: description` line for each.

The compiler stores the text in the assembly it builds. The VS Code extension
shows it in hover and completion wherever the declaration is used, including
from another project that references the assembly. No separate tool is needed.
