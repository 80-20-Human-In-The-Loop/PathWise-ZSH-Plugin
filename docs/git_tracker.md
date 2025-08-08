# 📊 PathWise Git Commit Tracker

> **Understanding your work patterns through commit messages**

## What is Git Tracking?

PathWise tracks and categorizes your Git commits automatically. This helps you understand what type of work you do in each project.

### Why This Matters

When you make commits, PathWise learns:
- What type of work you do (fixing bugs, adding features, writing tests)
- How you spend your time in different projects
- Your development patterns over time

This information helps you:
- Share work patterns with teammates
- Understand your productivity
- See where you spend most effort

---

## How Git Tracking Works

PathWise reads your commit messages and finds keywords. It then categorizes each commit based on these keywords.

### The Simple Process

1. **You make a commit**: `git commit -m "fix: resolve login error"`
2. **PathWise reads the message**: It looks for keywords like "fix" and "resolve"
3. **It assigns a category**: This commit becomes a "fix" (bug fix)
4. **You see insights**: Run `wfreq --insights` to see your work patterns

### Smart Categorization

PathWise uses a priority system. Some categories are more specific than others.

**Example**: A commit message with both "fix" and "update" keywords
- "fix" has priority 90 (bug fixes)
- "update" has priority 5 (maintenance)
- PathWise chooses "fix" because it has higher priority

This ensures your commits get the most accurate category.

---

## Commit Categories

PathWise recognizes 11 types of commits. Each has a priority level and specific keywords.

### 1. ⏪ Revert (Priority: 100)

**What it means**: Undoing previous changes

**When to use**: When you need to undo a commit that caused problems

**Keywords**:
- revert, rollback, undo
- back out, backout, rewind
- restore, reset, reverse, unmerge

**Example commits**:
```
revert: undo the authentication changes
rollback: restore previous database schema
```

### 2. 🔒 Security (Priority: 95)

**What it means**: Security-related changes and vulnerability fixes

**When to use**: When you fix security issues or improve security

**Keywords**:
- security, vulnerability, cve, auth, authentication
- authorization, permission, permissions, access, encryption
- encrypt, decrypt, ssl, tls, https, certificate, cert
- token, password, secret, secrets, leak, exposure
- sanitize, escape, injection, xss, csrf, sqli, exploit
- patch security, security fix, secure, harden, hardening

**Example commits**:
```
security: fix XSS vulnerability in user input
auth: improve password hashing algorithm
harden: add rate limiting to API endpoints
```

### 3. 🐛 Fix (Priority: 90)

**What it means**: Fixing bugs and errors

**When to use**: When you solve a problem or fix something broken

**Keywords**:
- fix, fixed, fixes, bugfix, hotfix, patch, bug
- resolve, resolved, resolves, solved, solve, issue
- error, crash, broken, fault, mistake, correct
- repair, handle, prevent, avoid, typo, oops
- troubleshoot, debug, debugging, debugged, workaround
- mitigate, mitigation, address, addressed, addresses
- remedy, remediate, correction, glitch, defect

**Example commits**:
```
fix: resolve login error on mobile devices
bugfix: handle null values in user profile
fixed typo in welcome message
mitigate: add workaround for memory leak
```

### 4. ✨ Feature (Priority: 80)

**What it means**: Adding new functionality

**When to use**: When you add something new to the project

**Keywords**:
- feat, feature, add, added, adds, new, implement
- implemented, introduce, introduced, create, created
- enhance, enhanced, extend, support, enable, allow
- integrate, develop, include, provide, setup
- capability, functionality, improvement, innovation
- addition, establish, build, construct, design

**Example commits**:
```
feat: add dark mode to settings
feature: implement study timer
add: create user dashboard
innovation: introduce AI-powered suggestions
```

### 5. ♿ Accessibility (Priority: 75)

**What it means**: Improving accessibility for users with disabilities

**When to use**: When you make the application more accessible

**Keywords**:
- a11y, accessibility, accessible, aria, wcag
- screen reader, screenreader, keyboard, keyboard navigation
- contrast, alt text, alt, alternative text, semantic
- focus, tab order, tabindex, assistive, disability
- inclusive, usability, voice, blind, deaf, impair
- handicap, ada, compliance, section 508

**Example commits**:
```
a11y: add ARIA labels to form elements
accessibility: improve keyboard navigation
contrast: fix color contrast ratios for WCAG compliance
```

### 6. ⚡ Performance (Priority: 70)

**What it means**: Making things faster or more efficient

**When to use**: When you improve speed or reduce resource usage

**Keywords**:
- perf, performance, optimize, optimized, optimization
- faster, speed, speedup, improve, boost, accelerate
- efficient, reduce, decreased, cache, lazy, quick
- enhance performance, reduce memory, reduce time
- throttle, debounce, memoize, memoization, parallelize
- parallel, async, asynchronous, concurrent, streaming
- buffer, batch, lightweight, minimize, shrink

**Example commits**:
```
perf: optimize database queries
performance: reduce image loading time
faster startup by lazy loading modules
async: parallelize data processing tasks
```

### 7. 🌍 Internationalization (Priority: 65)

**What it means**: Adding support for multiple languages and regions

**When to use**: When you add translation or localization features

**Keywords**:
- i18n, l10n, internationalization, localization
- translation, translate, translated, locale, locales
- language, languages, multilingual, multilanguage
- globalization, regionalization, culture, cultures
- rtl, ltr, bidi, unicode, charset, encoding
- locale-specific, country, region, timezone

**Example commits**:
```
i18n: add Spanish translations
locale: support date formatting for different regions
rtl: add right-to-left language support
```

### 8. 🔧 Refactor (Priority: 60)

**What it means**: Improving code structure without changing functionality

**When to use**: When you clean up or reorganize code

**Keywords**:
- refactor, refactored, refactoring, restructure, rewrite
- rework, simplify, extract, move, moved, rename
- renamed, reorganize, clean, cleanup, improve, decouple
- abstract, consolidate, deduplicate, modularize, split
- modernize, streamline, normalize, standardize, unify
- dry, optimize structure, reduce complexity, clarify
- tidy, polish, revise, rearrange, redesign

**Example commits**:
```
refactor: extract authentication logic
cleanup: remove unused variables
simplify the navigation component
modernize: update to use latest design patterns
```

### 9. ⚠️ Deprecation (Priority: 55)

**What it means**: Marking code as deprecated or removing deprecated code

**When to use**: When you deprecate features or remove old code

**Keywords**:
- deprecate, deprecated, deprecating, deprecation
- obsolete, obsoleted, legacy, remove deprecated
- sunset, sunsetting, end-of-life, eol, retire
- retired, retiring, phase out, phasing out, discontinue
- discontinued, supersede, superseded, replace deprecated
- old api, legacy code, backward compatible, breaking change

**Example commits**:
```
deprecate: mark old API endpoints for removal
legacy: remove deprecated authentication method
eol: sunset v1 API support
```

### 10. 🧪 Test (Priority: 50)

**What it means**: Adding or updating tests

**When to use**: When you write tests or improve test coverage

**Keywords**:
- test, tests, testing, spec, specs, coverage
- unit, integration, e2e, jest, pytest, mock
- stub, fixture, assertion, expect, should, verify
- validate, check, ensure, prove, tdd, bdd
- snapshot, regression, smoke test, smoke, sanity check
- sanity, acceptance, functional, scenario, suite
- testcase, test case, qa, quality assurance

**Example commits**:
```
test: add unit tests for user service
tests: improve coverage for API endpoints
add integration tests for payment flow
sanity: add smoke tests for critical paths
```

### 11. 📦 Build (Priority: 40)

**What it means**: Changes to build process or dependencies

**When to use**: When you modify how the project builds or compiles

**Keywords**:
- build, compile, bundle, webpack, rollup, vite
- make, cmake, gradle, maven, npm, yarn, pnpm
- package, dist, transpile, babel, typescript, tsc
- esbuild, swc, minify, uglify, compress

**Example commits**:
```
build: update webpack configuration
compile: fix TypeScript errors
bundle size reduced by tree shaking
```

### 12. 🔄 CI/CD (Priority: 30)

**What it means**: Continuous integration and deployment changes

**When to use**: When you modify automated workflows or deployment

**Keywords**:
- ci, cd, pipeline, github actions, actions, travis
- jenkins, circle, circleci, deploy, deployment
- release, publish, docker, kubernetes, k8s, helm
- terraform, ansible, workflow, automation

**Example commits**:
```
ci: add GitHub Actions workflow
deploy: configure production environment
automation: setup nightly builds
```

### 9. 📚 Documentation (Priority: 20)

**What it means**: Adding or updating documentation

**When to use**: When you write docs, comments, or guides

**Keywords**:
- docs, documentation, readme, comment, comments
- javadoc, jsdoc, docstring, api doc, guide, tutorial
- example, clarify, explain, describe, document
- wiki, changelog, notes, annotation, usage

**Example commits**:
```
docs: update README with examples
documentation: add API guide
explain the authentication flow
```

### 10. 💅 Style (Priority: 10)

**What it means**: Code formatting and style changes

**When to use**: When you fix formatting without changing logic

**Keywords**:
- style, format, formatting, lint, linting, prettier
- eslint, pylint, rubocop, whitespace, indent, indentation
- semicolon, quotes, spacing, code style, convention
- pep8, black, gofmt, rustfmt, standardize

**Example commits**:
```
style: fix indentation issues
format: apply prettier to all files
lint: resolve eslint warnings
```

### 11. 🔨 Chore (Priority: 5)

**What it means**: Routine maintenance tasks

**When to use**: For regular updates and small changes

**Keywords**:
- chore, update, updated, upgrade, bump, deps
- dependencies, dependency, version, maintain, routine
- housekeeping, misc, minor, tweak, adjust, modify
- prepare, setup, config, configure, init, bootstrap

**Example commits**:
```
chore: update dependencies
bump version to 2.1.0
minor: adjust config settings
```

### 📝 Other (Default)

**What it means**: Commits that don't match any category

**When to use**: This is assigned automatically when no keywords match

**Example commits**:
```
initial commit
WIP
merge branch
```

---

## Using Git Insights

### View Your Work Patterns

Run this command to see your Git activity:

```bash
wfreq --insights
```

This shows:
- Commits by category
- Most active directories
- Work patterns over time

### Export Your Data

Share your work patterns with others:

```bash
wfreq --export my-work.toml
```

The export includes:
- All commit categories
- Directory statistics
- Time tracking data

### Tips for Better Commits

1. **Start with a keyword**: `fix:`, `feat:`, `docs:`
2. **Be specific**: Describe what changed
3. **Keep it short**: One line is usually enough
4. **Use present tense**: "add feature" not "added feature"

**Good examples**:
```
fix: resolve memory leak in image processor
feat: add offline mode for students
docs: update installation guide for Windows
perf: cache API responses for faster loading
```

---

## How the Algorithm Works

For developers who want to understand the technical details:

### Priority-Based Scoring

1. **PathWise reads your commit message**
   - Converts to lowercase for matching
   - Keeps original for display

2. **It searches for keywords**
   - Checks each category's keyword list
   - Counts how many times keywords appear

3. **It calculates scores**
   - Score = (keyword count) × (category priority)
   - Higher priority means more specific category

4. **It picks the winner**
   - Category with highest score wins
   - If no keywords found, uses "other"

### Example Calculation

Commit message: "fix: add new error handling"

- Found "fix" → Fix category (priority 90)
  - Score: 1 × 90 = 90
- Found "add" and "new" → Feature category (priority 80)
  - Score: 2 × 80 = 160

**Winner**: Feature (score 160 > 90)

Even though "fix" appears first, "Feature" wins because it has more keyword matches.

### Python Implementation

The logic lives in two files:

1. **`python/constants/git_tracker.py`**
   - Defines all categories
   - Lists keywords for each
   - Sets priority levels

2. **`python/logic/git_tracker.py`**
   - Contains categorization function
   - Implements scoring algorithm
   - Provides shell integration

---

## Frequently Asked Questions

### Why is my commit showing as "other"?

Your commit message doesn't contain any recognized keywords. Try using keywords from the categories above.

### Can I add custom categories?

Not yet, but this feature is planned. The current 11 categories cover most development work.

### How accurate is categorization?

Very accurate when you use clear keywords. The priority system handles overlapping keywords well.

### Does this work offline?

Yes! PathWise tracks commits locally. No internet required.

### How far back does it track?

PathWise tracks commits from when you install it. It doesn't read historical commits by default.

---

## Summary

PathWise Git tracking helps you understand your work patterns. It:

- Categorizes commits automatically
- Uses smart priority-based scoring
- Works offline
- Provides insights about your development

Use clear keywords in your commits to get the best categorization. Run `wfreq --insights` to see your patterns anytime.

---

*This documentation is part of PathWise - Be Wise About Your Paths 🗺️*