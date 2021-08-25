; inherits: elixir
; extend

; case
(call
  target: (identifier) @_identifier
  (#eq? @_identifier "case")
  (arguments . (_) @case.subject .)
  (do_block
    "do"
    .
    (stab_clause)+ @case.inner
    .
    "end")) @case.outer

; cond
(call
  target: (identifier) @_identifier
  (#eq? @_identifier "cond")
  (do_block
    "do"
    .
    (stab_clause)+ @cond.inner
    .
    "end")) @cond.outer

; function guard
(call
  target: ((identifier) @_identifier
    (#any-of? @_identifier "def" "defmacro" "defmacrop" "defn" "defnp" "defp"))
  (arguments
    (binary_operator
      operator: "when"
      right: (_) @guard.inner)))

; stab clause and guard
(stab_clause) @stab_clause.outer

(stab_clause
  left: (_) @guard.outer
  right: (_) @stab_clause.inner)

(stab_clause
  left: (binary_operator
          operator: "when"
          right: (_) @guard.inner))

 ; pipe
(binary_operator
  operator: "|>"
  right: (_) @pipe.inner) @pipe.outer
