; Indentation queries for TableGen
; These patterns control smart indentation in editors

; Indent block bodies
[
  (record_body)
  (multiclass_body)
] @indent.begin

; Indent statement blocks
(let
  "in" @indent.begin
  (#set! indent.immediate))

(foreach
  "in" @indent.begin
  (#set! indent.immediate))

(if
  "then" @indent.begin
  (#set! indent.immediate))

(if
  "else" @indent.begin
  (#set! indent.immediate))

(defset
  "=" @indent.begin
  (#set! indent.immediate))

; Indent between braces, brackets, and angle brackets
[
  "{"
  "["
  "<"
] @indent.begin

[
  "}"
  "]"
  ">"
] @indent.end

; Dedent closing delimiters
[
  "}"
  "]"
  ">"
] @indent.dedent

; Indent parent class lists
(parent_class_list
  ":" @indent.begin
  (#set! indent.immediate))

; Indent template arguments
(template_args
  "<" @indent.begin)

(argument_list
  "<" @indent.begin)

; Indent after statement keywords
[
  "class"
  "def"
  "defm"
  "defset"
  "multiclass"
] @indent.begin

; Special handling for semicolon-terminated statements
(record_body ";") @indent.end
(multiclass_body ";") @indent.end
