; Context queries for nvim-treesitter-context
; Shows structural headers in the context sticky scroll

; Class definitions - show header until body starts
(class
  body: (record_body
    "{" @context.end)) @context

; Def definitions - show header until body starts
(def
  body: (record_body
    "{" @context.end)) @context

; Multiclass definitions - show header until body starts
(multiclass
  body: (multiclass_body
    "{" @context.end)) @context

; Let statements - show header until block starts
(let
  "in" @context.end) @context

; Foreach loops - show header until block starts
(foreach
  "in" @context.end) @context

; If statements - show condition until then/else
(if
  "then" @context.end) @context

; Defset - show header until body
(defset
  "{" @context.end) @context
