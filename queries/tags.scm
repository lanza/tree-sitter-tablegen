; Tags queries for TableGen
; These patterns define symbols for navigation, search, and tagging
; Compatible with ctags-style symbol extraction

; Class definitions
(class
  name: (identifier) @name) @definition.class

; Def (record) definitions
(def
  (value
    (identifier) @name) .) @definition.record

; Anonymous defs (no tag - they don't have a searchable name)

; Multiclass definitions
(multiclass
  (identifier) @name) @definition.namespace

; Defvar definitions (global variables)
(defvar
  (identifier) @name) @definition.var

; Defset definitions
(defset
  (identifier) @name) @definition.var

; Deftype definitions
(deftype
  (identifier) @name) @definition.type

; Template parameters
(template_arg
  (identifier) @name) @definition.parameter

; Record fields (class/def members)
(instruction
  (identifier) @name) @definition.field

; Let bindings at statement level
(let_item
  (identifier) @name) @definition.var

; Let instructions inside record bodies
(let_inst
  (identifier) @name) @definition.field

; Foreach iterators
(foreach
  (identifier) @name) @definition.var

; Defvar inside record bodies
(def_var
  (identifier) @name) @definition.var

; References to classes in parent lists
(parent_class_list
  (identifier) @name) @reference.class

; References in type positions
(type
  (identifier) @name) @reference.type
