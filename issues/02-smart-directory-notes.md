# Issue #02: Smart Directory Notes with Dynamic Templates

## Feature Request: Intelligent Directory Annotations (`wnote`)

### Overview

The smart directory notes feature transforms PathWise from a passive navigation tracker into an active contextual assistant that provides relevant information exactly when and where developers need it. Unlike traditional static notes, this feature introduces dynamic templates that automatically populate with real-time directory metrics such as TODO counts, file statistics, and code complexity indicators. By displaying this contextual information automatically upon directory entry, developers gain immediate awareness of the work landscape they're entering, potential technical debt, and pending tasks without needing to run separate commands or maintain manual documentation. The templating system allows for complete customization while providing sensible defaults, ensuring that both novice users and power users can benefit from contextual awareness tailored to their specific workflow needs.

### Implementation Details  

The technical architecture leverages PathWise's existing directory change hooks to trigger note display, while introducing a new templating engine that performs just-in-time evaluation of directory metrics. When a user enters a directory with an active wnote configuration, PathWise will execute lightweight analysis commands in the background to populate template variables like `{{todos}}`, `{{files}}`, and `{{lines}}`. The system maintains a cache of recently computed metrics with intelligent invalidation based on file modification times, ensuring that note display adds minimal latency to directory navigation. Notes are stored in a dedicated SQLite database within the PathWise data directory, with each note entry containing the directory path, template string, enabled state, and metadata such as creation time and last modification. The template processor supports nested variables, conditional expressions, and custom command execution, allowing advanced users to create sophisticated contextual displays while maintaining security through command sandboxing.

### User Experience

The user interface design prioritizes unobtrusiveness and informativeness, displaying notes as subtle annotations that appear after the directory change completes, similar to how PathWise currently shows frequency statistics. The default template provides essential metrics in a single line format: "X TODOs in Y files through Z lines of code", which gives developers an immediate sense of the directory's scope and pending work. Users can enable notes for any directory simply by typing `wnote` while in that directory, which activates the default template immediately. Custom templates can be set with natural syntax like `wnote "Remember: {{todos}} tasks pending in {{files}} files"`, where template variables are automatically detected and processed. The feature includes smart detection of common patterns, suggesting relevant templates based on directory type, such as test directories receiving test-focused templates and documentation directories showing markdown file counts and last update times.

### Integration and Compatibility

The smart notes feature integrates seamlessly with existing development tools and PathWise features while maintaining shell compatibility and performance standards. The template variable system is extensible through plugins, allowing integration with external tools like GitHub Issues, JIRA tickets, or custom project management systems. Notes can be synchronized across machines using PathWise's existing configuration sync mechanisms, enabling consistent team-wide directory annotations. The feature respects PathWise's performance settings, with configurable timeouts for metric calculation and options to disable expensive computations. Additionally, the system provides batch operations for managing notes across multiple directories, pattern-based note application for similar directory structures, and export capabilities for documentation generation, making it a comprehensive solution for project awareness and team communication.

## Shell Script Examples

### Part 1: Basic Note Operations
```bash
#!/bin/bash
# Enable notes with default template for current directory
cd ~/projects/api
wnote
# Note enabled: "3 TODOs in 47 files through 5,234 lines of code"

# Set a custom note for the current directory
wnote "Remember to run migrations before testing"
# Note saved for ~/projects/api

# Set a note with template variables
wnote "Project has {{todos}} TODOs across {{files}} files"
# Next entry shows: "Project has 3 TODOs across 47 files"

# View current note configuration
wnote --show
# Output:
# Directory: ~/projects/api
# Template: "Project has {{todos}} TODOs across {{files}} files"
# Status: Enabled
# Created: 2024-01-15
```

### Part 2: Template Variables and Customization
```bash
#!/bin/bash
# Available template variables demonstration
wnote "{{todos}} TODOs | {{fixmes}} FIXMEs | {{files}} files | {{lines}} LOC"
# Shows: "3 TODOs | 1 FIXMEs | 47 files | 5,234 LOC"

# Advanced template with conditional display
wnote "{{if:todos}}⚠️ {{todos}} TODOs pending{{endif}} | {{git_branch}} branch"
# Shows: "⚠️ 3 TODOs pending | feature/auth branch"

# Custom command execution in templates
wnote "Tests: {{cmd:pytest --co -q | wc -l}} | Coverage: {{cmd:coverage report | grep TOTAL | awk '{print $4}'}}"
# Shows: "Tests: 156 | Coverage: 87%"

# Language-specific templates
wnote --python "{{todos}} TODOs | {{py_files}} Python files | {{cmd:pylint --score=n . | tail -1}} score"
wnote --node "{{todos}} TODOs | {{package_version}} | {{npm_scripts}} npm scripts available"
```

### Part 3: Note Management and Control
```bash
#!/bin/bash
# Temporarily disable note for current directory (remembers template)
wnote --disable
# Note disabled for ~/projects/api (template preserved)

# Re-enable previously disabled note
wnote --enable  
# Note re-enabled with previous template

# Permanently delete note configuration
wnote --delete
# Note configuration removed for ~/projects/api

# Copy note configuration to another directory
wnote --copy ~/projects/frontend
# Note configuration copied from ~/projects/api to ~/projects/frontend

# Apply note to multiple directories matching pattern
wnote --pattern "~/projects/*/src" "Source code: {{files}} files, {{lines}} lines"
# Applied to 5 matching directories
```

### Part 4: Bulk Operations and Team Features
```bash
#!/bin/bash
# List all directories with notes
wnote --list
# Output:
# ~/projects/api         [enabled]  "3 TODOs in 47 files..."
# ~/projects/frontend    [disabled] "Remember to update deps"
# ~/projects/docs        [enabled]  "{{md_files}} docs, last updated {{last_modified}}"

# Export notes for team sharing
wnote --export > team-notes.json
# Exported 12 directory notes to team-notes.json

# Import team notes (merge with existing)
wnote --import team-notes.json --merge
# Imported 8 new notes, updated 4 existing notes

# Generate markdown documentation from notes
wnote --generate-docs > PROJECT_NOTES.md
# Generated documentation with all active notes

# Set note with expiration
wnote --expire "2024-02-01" "DEADLINE: Feature must be complete"
# Note will auto-delete after February 1, 2024

# Create note triggered by conditions
wnote --when "{{todos}} > 10" "⚠️ HIGH TODO COUNT: {{todos}} tasks pending!"
# Note only displays when condition is met
```

## Expected Behavior

- Notes display immediately after entering a directory (< 100ms)
- Template variables are evaluated in real-time
- Disabled notes preserve their templates for re-enabling
- Notes persist across shell sessions
- Template evaluation errors show gracefully without breaking navigation
- Complex templates are computed asynchronously to avoid blocking
- Note display respects terminal width and formatting
- Cache invalidation happens automatically on file changes

## Success Criteria

- Default template provides value with zero configuration
- Custom templates support 20+ built-in variables
- Note display adds less than 50ms to directory change
- 80% of users find notes helpful for context awareness  
- Team note sharing reduces onboarding time by 30%
- Template caching reduces computation by 90%