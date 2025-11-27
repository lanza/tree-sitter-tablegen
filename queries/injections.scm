; Injections queries for TableGen
; These patterns enable syntax highlighting of embedded languages

; Code strings often contain C++ code in LLVM TableGen files
; The code_string node contains code between [{ and }]
; We inject C++ highlighting into these regions
((code_string) @injection.content
  (#set! injection.language "cpp")
  (#set! injection.include-children))

; Comments might contain documentation markup
; Some projects use doxygen-style comments
((comment) @injection.content
  (#match? @injection.content "^//[/<]")
  (#set! injection.language "doxygen"))

((multiline_comment) @injection.content
  (#match? @injection.content "^/\\*[\\*!]")
  (#set! injection.language "doxygen"))
