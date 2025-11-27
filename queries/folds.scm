; Folding queries for TableGen
; These patterns define regions that can be folded in editors

; Fold class, def, and multiclass bodies
(record_body) @fold

(multiclass_body) @fold

; Fold let statement blocks
(let) @fold

; Fold foreach statement blocks
(foreach) @fold

; Fold if statement blocks
(if) @fold

; Fold defset blocks
(defset) @fold

; Fold template argument lists
(template_args) @fold

; Fold argument lists
(argument_list) @fold

; Fold parent class lists
(parent_class_list) @fold

; Fold multiline comments
(multiline_comment) @fold

; Fold consecutive single-line comments (implementation-dependent)
(comment) @fold
