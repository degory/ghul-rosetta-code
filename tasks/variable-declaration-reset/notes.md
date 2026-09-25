A local variable declared inside the loop body is a fresh variable on every
iteration, so the previous of the first loop never holds the preceding element
and that loop prints nothing.

Declared without an initializer it takes the default value of its type, and
reading it before it has been assigned is a warning rather than an error.

Carrying a value from one iteration to the next means declaring it outside the
loop, as the second loop does. ghūl has no declaration hoisting and no static
locals, so that is the only place it can live.
