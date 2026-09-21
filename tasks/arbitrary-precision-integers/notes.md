An operator on a bounded type parameter comes from the interface that declares
it, and has to be brought into scope by name: `power` imports the `*` of
`IMultiplyOperators` before it can multiply two `T` values. The operators on the
concrete types are untouched by that import.
