"""
Project Root Detection Indicators
Defines markers that identify project root directories
"""

from typing import Dict, List, Set

# Strong indicators - These definitively mark a project root
# Format: {indicator_file/dir: project_type}
STRONG_INDICATORS: Dict[str, str] = {
    # Python - Check first for language-specific identification
    "pyproject.toml": "python",
    "setup.py": "python",
    "setup.cfg": "python",
    "Pipfile": "python",
    "poetry.lock": "python",
    "requirements.txt": "python",  # Only with setup.py or pyproject.toml
    "tox.ini": "python",
    "venv": "python",  # Virtual environment
    ".venv": "python",  # Virtual environment
    # Node.js/JavaScript
    "package.json": "nodejs",
    "yarn.lock": "nodejs",
    "pnpm-lock.yaml": "nodejs",
    "bun.lockb": "nodejs",
    "lerna.json": "nodejs-monorepo",
    # Version Control Systems - Check last as they're generic
    ".git": "git",
    ".svn": "svn",
    ".hg": "mercurial",
    ".bzr": "bazaar",
    ".fossil": "fossil",
    # Rust
    "Cargo.toml": "rust",
    # Go
    "go.mod": "go",
    "go.sum": "go",
    # Ruby
    "Gemfile": "ruby",
    "Gemfile.lock": "ruby",
    ".ruby-version": "ruby",
    # Java/Kotlin/Gradle
    "pom.xml": "maven",
    "build.gradle": "gradle",
    "build.gradle.kts": "gradle-kotlin",
    "settings.gradle": "gradle",
    "settings.gradle.kts": "gradle-kotlin",
    # .NET/C#
    "*.sln": "dotnet",  # Solution files
    "*.csproj": "dotnet",  # C# project
    "*.fsproj": "dotnet",  # F# project
    "*.vbproj": "dotnet",  # VB.NET project
    # PHP
    "composer.json": "php",
    "composer.lock": "php",
    # Elixir
    "mix.exs": "elixir",
    # Clojure
    "project.clj": "clojure",
    "deps.edn": "clojure",
    # Scala
    "build.sbt": "scala",
    # Haskell
    "stack.yaml": "haskell",
    "*.cabal": "haskell",
    # Swift
    "Package.swift": "swift",
    # Dart/Flutter
    "pubspec.yaml": "dart",
    "pubspec.lock": "dart",
}

# Medium indicators - These suggest but don't guarantee a project root
# Used as fallback if no strong indicators found
MEDIUM_INDICATORS: Dict[str, str] = {
    # Build Systems
    "Makefile": "make",
    "makefile": "make",
    "GNUmakefile": "make",
    "CMakeLists.txt": "cmake",
    "meson.build": "meson",
    "BUILD": "bazel",
    "WORKSPACE": "bazel",
    # Container/VM
    "Dockerfile": "docker",
    "docker-compose.yml": "docker",
    "docker-compose.yaml": "docker",
    "Containerfile": "podman",
    ".dockerignore": "docker",
    "Vagrantfile": "vagrant",
    # JavaScript Build Tools
    "webpack.config.js": "webpack",
    "vite.config.js": "vite",
    "vite.config.ts": "vite",
    "rollup.config.js": "rollup",
    "gulpfile.js": "gulp",
    "Gruntfile.js": "grunt",
    # TypeScript
    "tsconfig.json": "typescript",
    # Framework-specific
    "angular.json": "angular",
    ".angular": "angular",
    "nx.json": "nx",
    "next.config.js": "nextjs",
    "nuxt.config.js": "nuxtjs",
    "vue.config.js": "vuejs",
    "svelte.config.js": "svelte",
    # Config files (only meaningful with other files)
    ".eslintrc.js": "javascript",
    ".eslintrc.json": "javascript",
    ".prettierrc": "javascript",
    ".prettierrc.json": "javascript",
    ".editorconfig": "generic",
    # CI/CD
    ".travis.yml": "ci",
    ".gitlab-ci.yml": "ci",
    "Jenkinsfile": "ci",
    ".circleci": "ci",
    ".github": "github",
    "azure-pipelines.yml": "ci",
    # Documentation
    "README.md": "generic",
    "README.rst": "generic",
    "README.txt": "generic",
    "docs": "generic",
    "documentation": "generic",
}

# Directories to never consolidate beyond
STOP_DIRS: Set[str] = {
    "/",
    "/home",
    "/Users",
    "/root",
    "/tmp",
    "/var",
    "/etc",
    "/usr",
    "/opt",
}

# Directories to blacklist from standalone display
# These should always be consolidated into their parent project
BLACKLIST_DIRS: Set[str] = {
    "node_modules",
    "__pycache__",
    ".git",
    ".svn",
    ".hg",
    ".cache",
    ".venv",
    "venv",
    "env",
    ".env",
    "dist",
    "build",
    "target",
    "out",
    "bin",
    ".idea",
    ".vscode",
    ".vs",
    "*.egg-info",
    ".pytest_cache",
    ".tox",
    ".coverage",
    "htmlcov",
    ".mypy_cache",
    ".ruff_cache",
}

# File patterns that indicate we should check parent directory
# Used when current directory doesn't have indicators but parent might
CHECK_PARENT_PATTERNS: List[str] = [
    "src",
    "lib",
    "test",
    "tests",
    "spec",
    "specs",
    "docs",
    "documentation",
    "examples",
    "samples",
    "scripts",
    "tools",
    "utils",
    "helpers",
    "components",
    "pages",
    "views",
    "models",
    "controllers",
    "services",
    "api",
    "routes",
    "public",
    "static",
    "assets",
    "resources",
    "config",
    "configs",
]


def get_all_indicators() -> Dict[str, str]:
    """Get combined dictionary of all indicators"""
    return {**STRONG_INDICATORS, **MEDIUM_INDICATORS}


def is_blacklisted(directory_name: str) -> bool:
    """Check if a directory name should be blacklisted"""
    return directory_name in BLACKLIST_DIRS


def should_stop_traversal(directory_path: str) -> bool:
    """Check if we should stop traversing up the directory tree"""
    return directory_path in STOP_DIRS or directory_path.endswith(
        tuple(STOP_DIRS)
    )


def suggests_parent_check(directory_name: str) -> bool:
    """Check if directory name suggests checking parent for project root"""
    return directory_name.lower() in [p.lower() for p in CHECK_PARENT_PATTERNS]
