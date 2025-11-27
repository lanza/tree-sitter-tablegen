; Locals queries for TableGen
; These patterns define scopes, definitions, and references for semantic analysis

; Scopes
; ------

; Class definitions create scopes
(class
  body: (record_body) @local.scope)

; Def definitions create scopes
(def
  body: (record_body) @local.scope)

; Multiclass definitions create scopes
(multiclass
  body: (multiclass_body) @local.scope)

; Let statements create scopes
(let) @local.scope

; Foreach statements create scopes
(foreach) @local.scope

; If statements create scopes
(if) @local.scope

; Defset creates scopes
(defset) @local.scope

; Definitions
; -----------

; Template parameters are definitions
(template_arg
  (identifier) @local.definition.parameter)

; Let bindings are definitions (top-level let statement)
(let_item
  (identifier) @local.definition.var)

; Let instruction bindings (inside class/def body)
(let_inst
  (identifier) @local.definition.var)

; Defvar creates variable definitions
(defvar
  (identifier) @local.definition.var)

; Def_var (inside record body) creates definitions
(def_var
  (identifier) @local.definition.var)

; Foreach iterator is a definition
(foreach
  (identifier) @local.definition.var)

; Class names are definitions
(class
  name: (identifier) @local.definition.class)

; Def names are definitions (when present)
(def
  (value
    (identifier) @local.definition.record) .)

; Multiclass names are definitions
(multiclass
  (identifier) @local.definition.namespace)

; Defset identifier is a definition
(defset
  (identifier) @local.definition.var)

; Deftype identifier is a definition
(deftype
  (identifier) @local.definition.type)

; Record fields are definitions
(instruction
  (identifier) @local.definition.field)

; DAG argument names are definitions
(dag_arg
  (var) @local.definition.parameter)

; References
; ----------

; Variables are references
(var) @local.reference

; Identifiers in values that aren't in definition positions are references
; (this is context-dependent and may need refinement)
(value
  (identifier) @local.reference)

; Parent class references
(parent_class_list
  (identifier) @local.reference)

; Type references (class names used as types)
(type
  (identifier) @local.reference)
