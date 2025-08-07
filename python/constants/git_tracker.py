"""
Git Commit Tracking Constants
All commit categories, priorities, emojis, and keywords
"""

# Commit categories with priority and keywords
# Higher priority = more important category
COMMIT_CATEGORIES = {
    'revert': {
        'priority': 100,
        'emoji': '⏪',
        'keywords': [
            'revert', 'rollback', 'undo', 'back out', 'backout', 'rewind',
            'restore', 'reset', 'reverse', 'unmerge'
        ]
    },
    'fix': {
        'priority': 90,
        'emoji': '🐛',
        'keywords': [
            'fix', 'fixed', 'fixes', 'bugfix', 'hotfix', 'patch', 'bug', 
            'resolve', 'resolved', 'resolves', 'solved', 'solve', 'issue',
            'error', 'crash', 'broken', 'fault', 'mistake', 'correct',
            'repair', 'handle', 'prevent', 'avoid', 'typo', 'oops'
        ]
    },
    'feat': {
        'priority': 80,
        'emoji': '✨',
        'keywords': [
            'feat', 'feature', 'add', 'added', 'adds', 'new', 'implement',
            'implemented', 'introduce', 'introduced', 'create', 'created',
            'enhance', 'enhanced', 'extend', 'support', 'enable', 'allow',
            'integrate', 'develop', 'include', 'provide', 'setup'
        ]
    },
    'perf': {
        'priority': 70,
        'emoji': '⚡',
        'keywords': [
            'perf', 'performance', 'optimize', 'optimized', 'optimization',
            'faster', 'speed', 'speedup', 'improve', 'boost', 'accelerate',
            'efficient', 'reduce', 'decreased', 'cache', 'lazy', 'quick',
            'enhance performance', 'reduce memory', 'reduce time'
        ]
    },
    'refactor': {
        'priority': 60,
        'emoji': '🔧',
        'keywords': [
            'refactor', 'refactored', 'refactoring', 'restructure', 'rewrite',
            'rework', 'simplify', 'extract', 'move', 'moved', 'rename',
            'renamed', 'reorganize', 'clean', 'cleanup', 'improve', 'decouple',
            'abstract', 'consolidate', 'deduplicate', 'modularize', 'split'
        ]
    },
    'test': {
        'priority': 50,
        'emoji': '🧪',
        'keywords': [
            'test', 'tests', 'testing', 'spec', 'specs', 'coverage',
            'unit', 'integration', 'e2e', 'jest', 'pytest', 'mock',
            'stub', 'fixture', 'assertion', 'expect', 'should', 'verify',
            'validate', 'check', 'ensure', 'prove', 'tdd', 'bdd'
        ]
    },
    'build': {
        'priority': 40,
        'emoji': '📦',
        'keywords': [
            'build', 'compile', 'bundle', 'webpack', 'rollup', 'vite',
            'make', 'cmake', 'gradle', 'maven', 'npm', 'yarn', 'pnpm',
            'package', 'dist', 'transpile', 'babel', 'typescript', 'tsc',
            'esbuild', 'swc', 'minify', 'uglify', 'compress'
        ]
    },
    'ci': {
        'priority': 30,
        'emoji': '🔄',
        'keywords': [
            'ci', 'cd', 'pipeline', 'github actions', 'actions', 'travis',
            'jenkins', 'circle', 'circleci', 'deploy', 'deployment',
            'release', 'publish', 'docker', 'kubernetes', 'k8s', 'helm',
            'terraform', 'ansible', 'workflow', 'automation'
        ]
    },
    'docs': {
        'priority': 20,
        'emoji': '📚',
        'keywords': [
            'docs', 'documentation', 'readme', 'comment', 'comments',
            'javadoc', 'jsdoc', 'docstring', 'api doc', 'guide', 'tutorial',
            'example', 'clarify', 'explain', 'describe', 'document',
            'wiki', 'changelog', 'notes', 'annotation', 'usage'
        ]
    },
    'style': {
        'priority': 10,
        'emoji': '💅',
        'keywords': [
            'style', 'format', 'formatting', 'lint', 'linting', 'prettier',
            'eslint', 'pylint', 'rubocop', 'whitespace', 'indent', 'indentation',
            'semicolon', 'quotes', 'spacing', 'code style', 'convention',
            'pep8', 'black', 'gofmt', 'rustfmt', 'standardize'
        ]
    },
    'chore': {
        'priority': 5,
        'emoji': '🔨',
        'keywords': [
            'chore', 'update', 'updated', 'upgrade', 'bump', 'deps',
            'dependencies', 'dependency', 'version', 'maintain', 'routine',
            'housekeeping', 'misc', 'minor', 'tweak', 'adjust', 'modify',
            'prepare', 'setup', 'config', 'configure', 'init', 'bootstrap'
        ]
    }
}

# Default category for uncategorized commits
DEFAULT_CATEGORY = 'other'
DEFAULT_EMOJI = '📝'