# Contributing to tree-sitter-tablegen

Thank you for your interest in contributing to tree-sitter-tablegen! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)
- [Resources](#resources)

## Code of Conduct

This project follows the Contributor Covenant Code of Conduct. By participating, you are expected to uphold this code. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- Node.js (v16 or later)
- npm or yarn
- Git
- A C compiler (for building the parser)
- Optional: tree-sitter CLI (`npm install -g tree-sitter-cli`)

### Finding Issues

Good starting points:

- Look for issues tagged with `good first issue` or `help wanted`
- Check the issue tracker for bugs or feature requests
- Review the [LLVM TableGen documentation](https://llvm.org/docs/TableGen/) for unsupported features

## Development Setup

1. **Fork and Clone**

```bash
git clone https://github.com/YOUR-USERNAME/tree-sitter-tablegen.git
cd tree-sitter-tablegen
```

2. **Install Dependencies**

```bash
npm install
```

3. **Generate the Parser**

```bash
npx tree-sitter generate
```

4. **Build the Parser**

```bash
npx tree-sitter build
```

5. **Run Tests**

```bash
npx tree-sitter test
```

## Making Changes

### Grammar Changes

When modifying the grammar (`grammar.js`):

1. **Understand the Current Grammar**: Read through `grammar.js` and understand how the parser works
2. **Make Incremental Changes**: Small, focused changes are easier to review and debug
3. **Regenerate the Parser**: Run `npx tree-sitter generate` after each change
4. **Test Your Changes**: Run `npx tree-sitter test` to ensure existing tests pass
5. **Add New Tests**: Add test cases in `test/corpus/*.td` for your changes

### Query File Changes

When modifying query files (`queries/*.scm`):

1. **Follow Tree-sitter Conventions**: Use standard capture names (see [tree-sitter docs](https://tree-sitter.github.io/tree-sitter/syntax-highlighting))
2. **Test in Real Editors**: Test your queries in Neovim, VS Code, or other editors
3. **Document Patterns**: Add comments explaining complex query patterns
4. **Validate Syntax**: Use `npx tree-sitter query` to validate query syntax

### Example Query Validation

```bash
npx tree-sitter query queries/highlights.scm examples/registers.td
```

## Testing

### Running Tests

```bash
# Run all tests
npx tree-sitter test

# Run specific test file
npx tree-sitter test -f "test/corpus/basic.td"

# Update test expectations (use carefully!)
npx tree-sitter test -u
```

### Adding Tests

Add test cases to `test/corpus/*.td` files using this format:

```
===================
Test Name
===================

// Your TableGen code here
class Foo {
  int Value = 42;
}

---

(file
  (class
    name: (identifier)
    body: (record_body
      (instruction
        (type)
        (identifier)
        (value (number))))))
```

### Test Guidelines

- **One Feature Per Test**: Each test should focus on a single language feature
- **Include Edge Cases**: Test boundary conditions and unusual inputs
- **Descriptive Names**: Use clear, descriptive test names
- **Expected Parse Trees**: Always include the expected parse tree
- **Regression Tests**: Add tests for fixed bugs to prevent regressions

### Testing Checklist

- [ ] All existing tests pass
- [ ] New tests added for changes
- [ ] Parser parses without errors
- [ ] No regressions in existing functionality
- [ ] Query files validated (if changed)
- [ ] Examples parse correctly

## Submitting Changes

### Pull Request Process

1. **Create a Branch**

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

2. **Make Your Changes**

- Write clear, focused commits
- Follow the style guidelines below
- Add tests for your changes
- Update documentation if needed

3. **Test Thoroughly**

```bash
npx tree-sitter generate
npx tree-sitter build
npx tree-sitter test
```

4. **Update CHANGELOG.md**

Add your changes under the `[Unreleased]` section:

```markdown
### Added
- Your new feature description

### Fixed
- Your bug fix description
```

5. **Commit Your Changes**

```bash
git add .
git commit -m "feat: add support for new TableGen feature"
```

Use conventional commit format:
- `feat:` for new features
- `fix:` for bug fixes
- `docs:` for documentation changes
- `test:` for test additions/changes
- `refactor:` for code refactoring
- `chore:` for maintenance tasks

6. **Push and Create PR**

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub with:
- Clear title describing the change
- Detailed description of what and why
- Link to related issues
- Test results

### PR Requirements

- [ ] All tests pass
- [ ] Code follows style guidelines
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated
- [ ] Commit messages are clear and descriptive
- [ ] No merge conflicts with main branch

## Style Guidelines

### Grammar Code Style

**JavaScript (grammar.js)**:
- Use 2 spaces for indentation
- Use single quotes for strings
- Use descriptive rule names (snake_case)
- Add comments for complex patterns
- Keep rules focused and composable

Example:
```javascript
// Good
template_arg: $ => seq(
  $.type,
  $.identifier,
  optional(seq('=', $.value))
),

// Avoid deeply nested rules without comments
```

### Query File Style

**Scheme (*.scm files)**:
- Use consistent indentation (2 spaces)
- Group related patterns together
- Add comments for sections
- Use descriptive capture names
- Follow tree-sitter capture conventions

Example:
```scheme
; Keywords - Control flow
[
  "let"
  "in"
  "foreach"
  "if"
  "then"
  "else"
] @keyword.control
```

### Test Style

- Use descriptive test names
- Include comments in test code
- Format expected parse trees clearly
- One assertion per test case

### Documentation Style

- Use clear, concise language
- Include code examples
- Link to relevant resources
- Keep line length under 100 characters for Markdown

## Resources

### Tree-sitter Documentation

- [Tree-sitter Guide](https://tree-sitter.github.io/tree-sitter/)
- [Grammar Development](https://tree-sitter.github.io/tree-sitter/creating-parsers)
- [Query Syntax](https://tree-sitter.github.io/tree-sitter/syntax-highlighting)
- [Testing Guide](https://tree-sitter.github.io/tree-sitter/creating-parsers#command-test)

### LLVM TableGen

- [LLVM TableGen Documentation](https://llvm.org/docs/TableGen/)
- [TableGen Language Reference](https://llvm.org/docs/TableGen/ProgRef.html)
- [LLVM TableGen Backend Guide](https://llvm.org/docs/TableGen/BackGuide.html)
- [TableGen Overview](https://llvm.org/docs/TableGen/index.html)

### Example Code

- [LLVM Target Descriptions](https://github.com/llvm/llvm-project/tree/main/llvm/lib/Target)
- Real-world TableGen files in LLVM backends
- This repository's `examples/` directory

## Development Tips

### Debugging the Parser

1. **Parse Example Files**

```bash
npx tree-sitter parse examples/registers.td
```

2. **Show Parse Tree**

```bash
npx tree-sitter parse examples/registers.td --debug
```

3. **Check for Errors**

```bash
npx tree-sitter parse examples/*.td 2>&1 | grep ERROR
```

### Testing Query Files

```bash
# Test highlights
npx tree-sitter highlight examples/registers.td

# Test specific query
npx tree-sitter query queries/tags.scm examples/instructions.td
```

### Performance Testing

```bash
# Parse large files
time npx tree-sitter parse large-file.td

# Check parser size
ls -lh src/parser.c
```

## Questions?

If you have questions:

1. Check existing [issues](https://github.com/lanza/tree-sitter-tablegen/issues)
2. Review the [README.md](README.md)
3. Read the [tree-sitter documentation](https://tree-sitter.github.io/tree-sitter/)
4. Open a new issue with the `question` label

## Recognition

Contributors will be recognized in:
- The README.md acknowledgments section
- Git commit history
- GitHub contributors page

Thank you for contributing to tree-sitter-tablegen!
