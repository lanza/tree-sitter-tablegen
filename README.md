# tree-sitter-tablegen

A [tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for [LLVM TableGen](https://llvm.org/docs/TableGen/).

[![CI](https://github.com/lanza/tree-sitter-tablegen/actions/workflows/ci.yml/badge.svg)](https://github.com/lanza/tree-sitter-tablegen/actions/workflows/ci.yml)

## Overview

This parser provides a complete tree-sitter grammar for LLVM's TableGen domain-specific language, used extensively in LLVM for describing target architectures, instruction sets, register files, and scheduling models.

### Features

- **Complete Language Support**: All TableGen constructs including classes, defs, multiclasses, template arguments, operators, and control flow
- **Advanced Editor Support**:
  - Syntax highlighting (`highlights.scm`)
  - Smart indentation (`indents.scm`)
  - Code folding (`folds.scm`)
  - Symbol navigation/tagging (`tags.scm`)
  - Variable scope tracking (`locals.scm`)
  - C++ injection in code blocks (`injections.scm`)
- **Multiple Language Bindings**: C, Go, Node.js, Python, Rust, Swift
- **Nested Multiline Comments**: External scanner for proper handling
- **Comprehensive Test Suite**: Extensive corpus tests including LLVM patterns

## Installation

### Node.js

```bash
npm install tree-sitter-tablegen
```

### Rust

```toml
[dependencies]
tree-sitter-tablegen = "*"
```

### Python

```bash
pip install tree-sitter-tablegen
```

### Go

```bash
go get github.com/lanza/tree-sitter-tablegen/bindings/go
```

### Swift

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/lanza/tree-sitter-tablegen", from: "1.0.0")
]
```

## Editor Integration

### Neovim

Using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter):

1. Add the parser configuration:

```lua
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tablegen = {
  install_info = {
    url = "https://github.com/lanza/tree-sitter-tablegen",
    files = { "src/parser.c", "src/scanner.c" },
    branch = "master",
  },
  filetype = "tablegen",
}
```

2. Install the parser:

```vim
:TSInstall tablegen
```

3. Set up filetype detection in your `init.lua`:

```lua
vim.filetype.add({
  extension = {
    td = "tablegen",
  },
})
```

### VS Code

Install the [tree-sitter-tablegen VS Code extension](https://marketplace.visualstudio.com/items?itemName=lanza.tree-sitter-tablegen) (if available), or configure manually:

1. Install the `tree-sitter-cli`
2. Clone this repository
3. Configure your VS Code settings to recognize `.td` files

### Helix

Add to your `languages.toml`:

```toml
[[language]]
name = "tablegen"
scope = "source.tablegen"
file-types = ["td"]
roots = []
comment-token = "//"
indent = { tab-width = 2, unit = "  " }

[[grammar]]
name = "tablegen"
source = { git = "https://github.com/lanza/tree-sitter-tablegen", rev = "master" }
```

Then run:

```bash
hx --grammar fetch
hx --grammar build
```

### Emacs

Using [tree-sitter-langs](https://github.com/emacs-tree-sitter/tree-sitter-langs):

```elisp
(add-to-list 'tree-sitter-major-mode-language-alist '(tablegen-mode . tablegen))
```

## Usage Examples

### Node.js

```javascript
const Parser = require('tree-sitter');
const TableGen = require('tree-sitter-tablegen');

const parser = new Parser();
parser.setLanguage(TableGen);

const sourceCode = `
class Register<string n> {
  string Name = n;
}

def R0 : Register<"r0">;
`;

const tree = parser.parse(sourceCode);
console.log(tree.rootNode.toString());
```

### Python

```python
import tree_sitter_tablegen as tstablegen
from tree_sitter import Language, Parser

TABLEGEN_LANGUAGE = Language(tstablegen.language())
parser = Parser(TABLEGEN_LANGUAGE)

source_code = b"""
class Instruction<bits<4> opc, string name> {
  bits<4> Opcode = opc;
  string Name = name;
}

def ADD : Instruction<0b0001, "add">;
"""

tree = parser.parse(source_code)
print(tree.root_node.sexp())
```

### Rust

```rust
use tree_sitter::{Parser, Language};

extern "C" { fn tree_sitter_tablegen() -> Language; }

fn main() {
    let mut parser = Parser::new();
    let language = unsafe { tree_sitter_tablegen() };
    parser.set_language(&language).unwrap();

    let source_code = r#"
    multiclass MultiDef<int val> {
      def _A : SomeClass<val>;
      def _B : SomeClass<!add(val, 1)>;
    }
    "#;

    let tree = parser.parse(source_code, None).unwrap();
    println!("{}", tree.root_node().to_sexp());
}
```

### Go

```go
package main

import (
    "fmt"
    "context"
    sitter "github.com/smacker/go-tree-sitter"
    tablegen "github.com/lanza/tree-sitter-tablegen/bindings/go"
)

func main() {
    parser := sitter.NewParser()
    parser.SetLanguage(tablegen.GetLanguage())

    sourceCode := []byte(`
    def MyDef {
      int Value = 42;
      string Name = "test";
    }
    `)

    tree, _ := parser.ParseCtx(context.Background(), nil, sourceCode)
    fmt.Println(tree.RootNode().String())
}
```

## Query Files

This parser includes comprehensive query files for enhanced editor functionality:

- **`queries/highlights.scm`**: Syntax highlighting with semantic tokens
- **`queries/indents.scm`**: Smart indentation rules
- **`queries/folds.scm`**: Code folding regions
- **`queries/tags.scm`**: Symbol extraction for navigation (ctags-compatible)
- **`queries/locals.scm`**: Variable scope and reference tracking
- **`queries/injections.scm`**: C++ syntax in code blocks

## Grammar Coverage

The grammar supports all TableGen language features:

### Definitions
- `class` - Class definitions with template parameters
- `def` - Record definitions (named and anonymous)
- `multiclass` - Template definitions for multiple records
- `defm` - Multiclass instantiation
- `defvar` - Variable definitions
- `defset` - Set definitions
- `deftype` - Type aliases

### Control Flow
- `let` - Variable bindings and overrides
- `foreach` - Loop iteration
- `if`/`then`/`else` - Conditional definitions
- `assert` - Compile-time assertions
- `dump` - Debug output

### Types
- Primitive: `bit`, `int`, `string`, `dag`, `code`
- Compound: `bits<n>`, `list<type>`
- User-defined: class names

### Operators (46 operators)
- Arithmetic: `!add`, `!sub`, `!mul`, `!div`, `!shl`, `!sra`, `!srl`
- Logical: `!and`, `!or`, `!xor`, `!not`
- Comparison: `!eq`, `!ne`, `!lt`, `!le`, `!gt`, `!ge`
- List: `!listconcat`, `!head`, `!tail`, `!size`, `!filter`, `!foreach`
- String: `!strconcat`, `!substr`, `!toupper`, `!tolower`
- DAG: `!dag`, `!getdagop`, `!setdagop`, `!getdagarg`, `!setdagarg`
- Control: `!if`, `!cond`, `!exists`, `!isa`
- And more...

### Advanced Features
- Template arguments with default values
- Parent class lists with arguments
- Value suffixes (field access, slicing, ranges)
- DAG (directed acyclic graph) values with named arguments
- Nested multiline comments
- Preprocessor directives
- String concatenation
- Code blocks with C++ snippets

## Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/lanza/tree-sitter-tablegen.git
cd tree-sitter-tablegen

# Generate the parser
npm install
npx tree-sitter generate

# Build and test
npx tree-sitter build
npx tree-sitter test
```

### Testing

The test suite includes comprehensive corpus tests:

```bash
npx tree-sitter test
```

### Parsing Example Files

```bash
npx tree-sitter parse examples/*.td
```

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Reporting Issues

If you encounter parsing errors or missing language features:

1. Check existing [issues](https://github.com/lanza/tree-sitter-tablegen/issues)
2. Provide a minimal TableGen example that reproduces the issue
3. Include the expected parse tree or behavior

## Resources

- [LLVM TableGen Documentation](https://llvm.org/docs/TableGen/)
- [LLVM TableGen Language Reference](https://llvm.org/docs/TableGen/ProgRef.html)
- [Tree-sitter Documentation](https://tree-sitter.github.io/tree-sitter/)
- [Tree-sitter Query Syntax](https://tree-sitter.github.io/tree-sitter/syntax-highlighting#queries)

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Acknowledgments

- The LLVM Project for TableGen
- The tree-sitter project and community
- Contributors to this parser

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history and release notes.
