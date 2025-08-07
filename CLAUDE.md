# PathWise Development Guide for Claude

## Project Overview

PathWise is a Zsh plugin that tracks directory navigation patterns, time spent, and git activity. It's built with a Python-based build system that generates the final Zsh plugin file.

**Philosophy**: 80-20 Human-in-the-Loop - 80% automation, 20% human wisdom, 100% growth.

## Architecture

### Directory Structure
```
pathwise/
├── build_plugin.py          # Main build script - generates pathwise.plugin.zsh
├── pathwise.plugin.zsh      # Generated plugin file (DO NOT EDIT DIRECTLY)
├── python/
│   ├── constants/
│   │   ├── colors.py        # Color definitions and palettes
│   │   └── git_tracker.py   # Git commit categories and keywords
│   └── logic/
│       └── git_tracker.py   # Git tracking logic and categorization
├── install.sh               # Installation script
├── uninstall.sh            # Uninstallation script
└── docs/                   # Documentation
```

### Build Process

**IMPORTANT**: Never edit `pathwise.plugin.zsh` directly! All changes must be made in:
1. `build_plugin.py` - For shell script generation logic
2. `python/constants/` - For configuration and constants
3. `python/logic/` - For business logic

To build the plugin:
```bash
python build_plugin.py
```

This generates `pathwise.plugin.zsh` with ~800 lines of Zsh code.

## Code Quality Standards

### Python Code Requirements

#### Type Checking with mypy
All Python code MUST be fully type-annotated and pass mypy strict mode:

```bash
# Run mypy checks
mypy --strict build_plugin.py
mypy --strict python/

# Expected: No errors
```

Type annotation requirements:
- All function parameters and return types must be annotated
- Use `typing` module for complex types (List, Dict, Tuple, Optional, etc.)
- No `Any` types unless absolutely necessary and documented

#### Linting with ruff
All Python code MUST pass ruff linting with zero violations:

```bash
# Run ruff checks
ruff check .
ruff format --check .

# Fix issues automatically
ruff check --fix .
ruff format .
```

Ruff configuration (add to `pyproject.toml` if needed):
```toml
[tool.ruff]
line-length = 100
target-version = "py310"
select = ["E", "F", "B", "W", "I", "N", "UP", "ANN", "ASYNC", "S", "FBT", "A", "C4", "DTZ", "EM", "ISC", "G", "INP", "PIE", "T20", "PT", "RET", "SIM", "ARG", "PTH", "ERA", "PD", "PGH", "PL", "TRY", "RUF"]
ignore = ["ANN101", "ANN102"]  # Allow missing self/cls annotations
```

### Shell Script Standards

The generated Zsh code must:
- Use proper quoting for all variables
- Handle spaces in paths correctly (use double quotes)
- Be compatible with Zsh 5.8+
- Work with Oh My Zsh and standalone installations

## Critical Zsh Gotchas

### 1. Array Indexing (CRITICAL)
**Zsh arrays are 1-indexed, not 0-indexed!**

```bash
# WRONG - will fail silently
local arr=(a b c)
echo ${arr[0]}  # Returns nothing!

# CORRECT
local arr=(a b c)
echo ${arr[1]}  # Returns 'a'
```

### 2. Word Splitting (CRITICAL)
**Zsh doesn't split variables by default!**

```bash
# WRONG - treats entire string as one word
local words="foo bar baz"
for word in $words; do  # Only iterates once!
    echo $word  # Prints "foo bar baz"
done

# CORRECT - use ${=variable} for word splitting
local words="foo bar baz"
for word in ${=words}; do  # Iterates three times
    echo $word  # Prints "foo", "bar", "baz"
done
```

### 3. Escape Sequences in printf
**Use single backslash for escape codes in f-strings:**

```python
# WRONG - produces literal \033 in output
f'printf "\\033[36mText\\033[0m"'

# CORRECT - produces actual color codes
f'printf "\033[36mText\033[0m"'
```

### 4. Multi-byte Characters
**Use awk instead of cut for UTF-8 characters:**

```bash
# WRONG - fails with UTF-8 arrow
echo "path → other" | cut -d'→' -f1

# CORRECT
echo "path → other" | awk -F' → ' '{print $1}'
```

## Git Commit Categorization

The plugin categorizes commits using a priority-based scoring system:

### Categories (by priority)
1. **revert** (100) - Reverting changes
2. **fix** (90) - Bug fixes
3. **feat** (80) - New features
4. **perf** (70) - Performance improvements
5. **refactor** (60) - Code refactoring
6. **test** (50) - Tests
7. **build** (40) - Build system
8. **ci** (30) - CI/CD
9. **docs** (20) - Documentation
10. **style** (10) - Code style
11. **chore** (5) - Maintenance

Keywords are defined in `python/constants/git_tracker.py`. The categorization logic uses ALL keywords (not truncated) and handles overlapping keywords by priority scoring.

## Common Issues and Solutions

### Issue: Commits showing as "Other" instead of proper category
**Causes:**
1. Keywords truncated to first 8 (fixed)
2. Array indexing starting at 0 instead of 1 (fixed)
3. Word splitting not enabled with `${=variable}` (fixed)

**Solution:** Ensure build includes all keywords and uses proper Zsh syntax.

### Issue: Colors showing as literal escape codes
**Cause:** Double-escaped backslashes in Python f-strings
**Solution:** Use single backslash: `\033` not `\\033`

### Issue: Navigation patterns showing duplicates
**Cause:** Editor usage (nano/vim) triggers directory change events
**Future Enhancement:** Detect editor processes and filter duplicates

## Testing Guidelines

### Manual Testing Checklist
- [ ] `freq` displays directories with colors
- [ ] `freq --insights` shows categorized commits correctly
- [ ] Jump aliases (`j1`, `j2`, etc.) work
- [ ] Time tracking accumulates correctly
- [ ] Git commits are tracked and categorized
- [ ] Daily rotation works at midnight
- [ ] Configuration persists across sessions

### Test Commands
```bash
# Test categorization
zsh -c 'source pathwise.plugin.zsh && _freq_dirs_categorize_commit "fix: resolve bug"'
# Should output: fix

# Test insights
freq --insights
# Should show categorized commits, not all as "Other"

# Test configuration
freq --config
# Should save and load settings
```

## Future Development Notes

### Planned Features
1. **Editor Detection**: Track time in nano/vim/neovim
2. **Learning Mode**: Adaptive suggestions based on patterns
3. **Team Sharing**: Export/import navigation patterns
4. **Security Audit**: Monitor sensitive directory access

### Performance Considerations
- Session files can grow large - consider rotation/archiving
- Categorization runs on every insight view - could cache results
- Multiple file I/O operations - could batch updates

### Maintenance Tasks
- Add comprehensive test suite
- Set up GitHub Actions for CI/CD
- Add mypy and ruff to pre-commit hooks
- Create benchmarking suite for performance tracking

## Development Workflow

1. Make changes in Python source files or `build_plugin.py`
2. Run quality checks:
   ```bash
   mypy --strict .
   ruff check .
   ruff format .
   ```
3. Build the plugin:
   ```bash
   python build_plugin.py
   ```
4. Test in a new shell:
   ```bash
   zsh -c 'source pathwise.plugin.zsh && freq'
   ```
5. Commit with descriptive message using proper keywords

## Important Files to Read

When working on PathWise, always read these files first:
1. `build_plugin.py` - Understand the build process
2. `python/constants/git_tracker.py` - See all categories and keywords
3. `python/logic/git_tracker.py` - Understand categorization logic
4. This file (`CLAUDE.md`) - Development guidelines

## Contact and Support

- GitHub Issues: Report bugs and request features
- Discussions: Share ideas and get help
- Philosophy: Follow 80-20 Human-in-the-Loop principles

---
*Remember: Always maintain high code quality standards. The build system allows us to write clean Python that generates optimized Zsh code.*