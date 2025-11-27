# Changelog

All notable changes to tree-sitter-tablegen will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive query files for enhanced editor support:
  - `queries/indents.scm` for smart indentation
  - `queries/locals.scm` for variable scope tracking
  - `queries/folds.scm` for code folding
  - `queries/tags.scm` for symbol navigation and tagging
  - `queries/injections.scm` for C++ syntax highlighting in code blocks
- Enhanced `queries/highlights.scm` with semantic highlighting
  - Separate categories for different keyword types
  - Better operator highlighting
  - Property and field highlighting
  - Definition vs reference distinction
- Extensive example files demonstrating TableGen features:
  - `examples/registers.td` - Register definitions
  - `examples/instructions.td` - Instruction definitions
  - `examples/operators.td` - Operator usage
  - `examples/control_flow.td` - Control flow constructs
  - `examples/multiclass.td` - Multiclass patterns
  - `examples/dag_and_patterns.td` - DAG manipulation
- Comprehensive README.md with:
  - Installation instructions for all language bindings
  - Editor integration guides (Neovim, VS Code, Helix, Emacs)
  - Usage examples for Node.js, Python, Rust, and Go
  - Complete grammar coverage documentation
- CONTRIBUTING.md with development guidelines
- GitHub Actions CI/CD workflows
- Expanded test corpus with real-world examples

### Changed
- README.md expanded from 4 lines to comprehensive documentation

### Deprecated
- None

### Removed
- None

### Fixed
- None

### Security
- None

## [1.0.0] - Initial Release

### Added
- Complete TableGen grammar implementation
- Support for all TableGen language features:
  - Classes and definitions (class, def)
  - Template arguments and parent classes
  - Multiclass support (multiclass, defm)
  - Control flow (let, foreach, if/then/else)
  - Variable definitions (defvar, defset, deftype)
  - All 46 built-in operators
  - DAG values and pattern matching
  - Preprocessor directives
  - Nested multiline comments (via external scanner)
- Language bindings for:
  - C
  - Go
  - Node.js (with TypeScript definitions)
  - Python (with type stubs)
  - Rust
  - Swift
- Basic syntax highlighting (queries/highlights.scm)
- Comprehensive test suite with corpus tests
- Package configurations for all supported languages
- MIT License

[Unreleased]: https://github.com/lanza/tree-sitter-tablegen/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/lanza/tree-sitter-tablegen/releases/tag/v1.0.0
