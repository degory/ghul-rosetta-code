An operator's precedence and associativity come from how it is spelled, generally
from its first character, and are settled in the parser before any operator
definition is seen: every operator beginning with `+` binds at addition precedence
and every one beginning with `<` at relational, however it is defined. The
`@precedence` pragma changes that within its scope, for every operator of that
spelling rather than for one definition.
