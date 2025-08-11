# Issue #04: Project-Aware Directory Consolidation for Better Navigation Variety

## Problem Statement: Subdirectory Spam Eliminates Navigation Variety

### Overview

The current PathWise implementation treats every directory as an independent entity, leading to a frustrating scenario where all top navigation shortcuts (wj1-wj5) can be dominated by subdirectories from a single project. This completely defeats the purpose of quick navigation shortcuts, which should provide fast access to different project contexts, not just different folders within the same project. Users working on a large project with deep directory structures find their entire quick-jump list consumed by variations of the same project path, losing access to other important projects and reducing the tool's effectiveness for context switching.

### Real User Example

```
[wj1] ~/python-3.10.12-Projects/EduLite/backend/EduLite
      ├─ 4 visits · · 22h 18m today
[wj2] ~/python-3.10.12-Projects/EduLite/backend/EduLite/users
      ├─ 1 visits · · 11h 45m today
[wj3] ~/python-3.10.12-Projects/EduLite
      ├─ 2 visits · · 51m 13s today [3 commits]
[wj4] ~/python-3.10.12-Projects/EduLite/backend
      ├─ 3 visits · · 8s today
[wj5] ~/python-3.10.12-Projects/EduLite/backend/EduLite/.claude
      ├─ 1 visits · today
```

All five shortcuts point to the same EduLite project! The user correctly notes: "The one with 3 commits? That's the only one that should show! The other 4 should get consolidated into the 1, like the program should see 'wait a minute, I have already seen this project, let's just add these times to the main directory rather than spamming with all its subdirectories'."

### Impact on Productivity

- **Lost Variety**: Users can't quickly jump between different projects
- **Wasted Shortcuts**: 4 out of 5 shortcuts pointing to the same project is inefficient
- **Fragmented Metrics**: Time and visit counts spread across subdirectories instead of showing true project usage
- **Context Switching Friction**: The tool fails at its primary job of enabling quick context switches
- **Muscle Memory Disruption**: Shortcuts change based on which subdirectory was visited last

## Proposed Solution: Intelligent Project Root Detection and Consolidation

### Project Root Detection Strategy

The system will detect project roots using a two-tier indicator system:

#### Strong Indicators (Definitely a Project Root)

**Version Control Systems:**
- `.git/` - Git repository
- `.svn/` - Subversion
- `.hg/` - Mercurial  
- `.bzr/` - Bazaar

**Language-Specific Package Manifests:**
- **Node.js**: `package.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lockb`
- **Python**: `pyproject.toml`, `setup.py`, `setup.cfg`, `Pipfile`, `poetry.lock`, `requirements.txt` (with setup.py or pyproject.toml)
- **Rust**: `Cargo.toml`
- **Go**: `go.mod`
- **Ruby**: `Gemfile`
- **Java/Kotlin**: `pom.xml`, `build.gradle`, `build.gradle.kts`, `settings.gradle`
- **.NET**: `*.sln`, `*.csproj` (at directory root)
- **PHP**: `composer.json`
- **Elixir**: `mix.exs`

#### Medium Indicators (Likely a Project Root - Used as Fallback)

**Build and Configuration Files:**
- `Makefile`, `CMakeLists.txt`
- `Dockerfile`, `docker-compose.yml`, `docker-compose.yaml`
- `.dockerignore`
- `Vagrantfile`
- `webpack.config.js`, `vite.config.js`, `rollup.config.js`
- `tsconfig.json` (TypeScript configuration)
- `angular.json`, `nx.json` (Angular/Nx workspaces)
- `.eslintrc.*`, `.prettierrc.*` (with package.json nearby)

### Consolidation Algorithm

```bash
# Pseudocode for project detection and consolidation
function find_project_root(directory) {
    current = directory
    
    while current != "/" and current != $HOME:
        # Check for strong indicators first
        for indicator in STRONG_INDICATORS:
            if exists("$current/$indicator"):
                return current
        
        # Move up one directory
        current = dirname(current)
    
    # If no strong indicator found, check for medium indicators
    current = directory
    while current != "/" and current != $HOME:
        for indicator in MEDIUM_INDICATORS:
            if exists("$current/$indicator"):
                return current
        current = dirname(current)
    
    # No project root found, return original directory
    return directory
}

function consolidate_directories(directories) {
    project_roots = {}
    
    for dir in directories:
        root = find_project_root(dir)
        
        if root not in project_roots:
            project_roots[root] = {
                visits: 0,
                time: 0,
                commits: 0,
                subdirs: []
            }
        
        project_roots[root].visits += dir.visits
        project_roots[root].time += dir.time
        project_roots[root].commits += dir.commits
        project_roots[root].subdirs.append(dir)
    
    return project_roots
}
```

### View-Specific Behavior

**Main View (`wfreq`)** - Consolidated:
- Shows only project roots
- Aggregates all metrics from subdirectories
- Provides maximum variety for quick navigation
- One entry per project

**Tools View (`wfreq --tools`)** - Detailed:
- Shows all directories as currently implemented
- Preserves exact location where tools were executed
- Maintains analytical accuracy
- Important for understanding workflow patterns

**Insights View (`wfreq --insights`)** - Configurable:
- Default: Consolidated like main view
- Option: `FREQ_INSIGHTS_DETAIL=true` for detailed view

## Shell Script Examples

### Example 1: Basic Consolidation
```bash
#!/bin/bash
# Current problematic behavior - all from same project
wfreq
# [wj1] ~/projects/myapp/src/components
# [wj2] ~/projects/myapp/src
# [wj3] ~/projects/myapp/tests
# [wj4] ~/projects/myapp
# [wj5] ~/projects/myapp/docs

# After consolidation - variety across projects
wfreq
# [wj1] ~/projects/myapp      (147 visits, 24h 12m) [project]
# [wj2] ~/projects/other-app  (89 visits, 18h 5m)  [project]
# [wj3] ~/dotfiles            (45 visits, 3h 20m)  [project]
# [wj4] ~/Documents/reports   (23 visits, 2h 10m)  [standalone]
# [wj5] ~/Downloads           (18 visits, 45m)     [standalone]

# The detailed metrics are preserved in tools view
wfreq --tools
# Still shows all individual directories for accurate tool tracking
```

### Example 2: Aggregated Metrics Display
```bash
#!/bin/bash
# Project with activity across multiple subdirectories
cd ~/projects/webapp           # 5 visits, 2 hours
cd ~/projects/webapp/frontend  # 20 visits, 8 hours  
cd ~/projects/webapp/backend   # 15 visits, 6 hours
cd ~/projects/webapp/tests     # 10 visits, 1 hour

# Consolidated display shows total activity
wfreq
# [wj1] ~/projects/webapp
#       ├─ 50 visits · 17h total · 8 commits today
#       └─ includes 4 subdirectories

# Optional: Show subdirectory breakdown on demand
wfreq --expand webapp
# ~/projects/webapp (root)
#   ├─ frontend/  (20 visits, 8h)
#   ├─ backend/   (15 visits, 6h)
#   ├─ tests/     (10 visits, 1h)
#   └─ ./         (5 visits, 2h)
```

### Example 3: Project Detection Examples
```bash
#!/bin/bash
# Node.js project - detected by package.json
~/myapp/package.json exists
~/myapp/src/components → consolidated to ~/myapp

# Python project - detected by pyproject.toml
~/python-proj/pyproject.toml exists
~/python-proj/src/models/users → consolidated to ~/python-proj

# Git repository - detected by .git
~/repo/.git/ exists
~/repo/deep/nested/path → consolidated to ~/repo

# Monorepo with multiple projects
~/monorepo/.git/ exists (root)
~/monorepo/packages/app1/package.json exists
~/monorepo/packages/app2/package.json exists

# Smart handling: consolidate to nearest project root
~/monorepo/packages/app1/src → consolidated to ~/monorepo/packages/app1
~/monorepo/packages/app2/src → consolidated to ~/monorepo/packages/app2
~/monorepo/scripts → consolidated to ~/monorepo
```

### Example 4: Configuration Options
```bash
#!/bin/bash
# Configure consolidation behavior
wfreq --config

# Choose consolidation strategy
FREQ_CONSOLIDATE=true          # Enable project consolidation (default)
FREQ_CONSOLIDATE_DEPTH=4       # Max depth to look for project root
FREQ_SHOW_SUBDIR_COUNT=true    # Show "includes X subdirectories"

# Configure indicators
FREQ_PROJECT_INDICATORS_EXTRA=".myproject,.workspace"  # Add custom indicators

# Blacklist certain directories from appearing standalone
FREQ_BLACKLIST_DIRS="node_modules,__pycache__,.git,.cache,dist,build"

# Example with blacklist
cd ~/project/node_modules/some-package
# This visit gets counted toward ~/project, never shows separately

# Disable consolidation for specific directories
FREQ_NO_CONSOLIDATE="~/Documents,~/Downloads,~/Desktop"
# These directories always show subdirectories separately
```

## Expected Behavior

- **Variety First**: Top 5 shortcuts represent different projects/contexts
- **Accurate Metrics**: All subdirectory activity consolidated into project totals
- **Smart Detection**: Automatically identifies project boundaries
- **Configurable**: Users can customize detection and consolidation rules
- **View Appropriate**: Different views (main/tools/insights) show appropriate detail level
- **Performance**: Project detection cached to avoid repeated filesystem checks
- **Monorepo Aware**: Handles nested projects intelligently

## Success Criteria

- Maximum 1 entry per project in main `wfreq` view
- 80% increase in project variety in top 5 shortcuts
- Sub-10ms overhead for project root detection (with caching)
- No loss of detailed information (preserved in tools view)
- Configurable indicators cover 95% of project types
- Users report significant improvement in navigation efficiency
- Muscle memory for wj1-wj5 maps to different contexts, not subdirectories

## Implementation Considerations

### Performance Optimization
- Cache project root detection results with TTL
- Use presence checks only (don't read file contents)
- Limit upward traversal to reasonable depth (e.g., 10 levels)
- Batch detection for multiple directories

### Edge Cases
- Symlinked directories - follow to real path for detection
- Nested projects (monorepos) - consolidate to nearest project root
- Home directory - never consolidate beyond home
- Root filesystem - stop traversal at mount points
- Network drives - optional timeout for detection

### Backward Compatibility
- Existing data files remain unchanged
- Default behavior changes to consolidated view
- `--no-consolidate` flag for old behavior
- First run shows notification about consolidation feature
- Migration command to clean up existing fragmented data

## Future Enhancements

- **Project Templates**: Auto-detect project type and show relevant info
- **Project Switching**: `wfreq --projects` to show only project roots
- **Project Groups**: Group related projects (e.g., all work projects)
- **Smart Suggestions**: "You haven't visited [project] in 5 days"
- **Project Aliases**: Custom names for project roots in display