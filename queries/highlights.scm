; Comments
[
  (comment)
  (multiline_comment)
] @comment

; Brackets and delimiters
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  "<"
  ">"
] @punctuation.bracket.angle

[
  ","
  ";"
  "."
] @punctuation.delimiter

; Operators
[
  "#"
  "-"
  "..."
  ":"
] @operator

"=" @operator.assignment

; Built-in functions and operators
"!cond" @function.builtin

(operator_keyword) @function.builtin

; Boolean constants
[
  "true"
  "false"
] @constant.builtin.boolean

; Special constant (uninitialized value)
"?" @constant.builtin

; Variables and parameters
(var) @variable

(template_arg
  (identifier) @variable.parameter)

(_ argument: (value (identifier) @variable.parameter))

; DAG named arguments
(dag_arg
  (var) @variable.parameter)

; Types
(type) @type

"code" @type.builtin

[
  "bit"
  "int"
  "string"
  "dag"
  "bits"
  "list"
] @type.builtin

; Numbers and strings
(number) @constant.numeric.integer

(string_string) @string

(code_string) @string.special

; Preprocessor directives
(preprocessor) @keyword.directive

; Keywords - Definition keywords
[
  "class"
  "def"
  "defvar"
  "defset"
  "deftype"
  "assert"
  "dump"
] @keyword

; Deprecated keyword
"field" @keyword.deprecated

; Keywords - Control flow
[
  "let"
  "in"
  "foreach"
  "if"
  "then"
  "else"
] @keyword.control

; Keywords - Import
"include" @keyword.control.import

; Keywords - Multiclass (namespace-like)
[
  "multiclass"
  "defm"
] @keyword.namespace

; Identifiers in different contexts
(class
  name: (identifier) @type.definition)

(def
  (value
    (identifier) @variable.definition) .)

(multiclass
  (identifier) @namespace.definition)

(defvar
  (identifier) @variable.definition)

(defset
  (identifier) @variable.definition)

(deftype
  (identifier) @type.definition)

(let_item
  (identifier) @variable.definition)

(let_inst
  (identifier) @variable.definition)

(def_var
  (identifier) @variable.definition)

(foreach
  (identifier) @variable.definition)

(instruction
  (identifier) @property)

; Parent class references
(parent_class_list
  (identifier) @type)

; Field access
(value_suffix
  "." @punctuation.delimiter
  (identifier) @property)

; Include files
(include
  (string_string) @string.special.path)

; Error nodes
(ERROR) @error
