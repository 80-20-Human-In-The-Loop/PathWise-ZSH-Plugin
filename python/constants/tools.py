"""
Tool Tracking Constants
Define which tools/commands to track for usage analytics
"""

# Tools to track organized by category
TRACKED_TOOLS = {
    'editors': {
        'emoji': '📝',
        'tools': [
            'nano', 'vim', 'vi', 'nvim', 'neovim', 'emacs',
            'code', 'subl', 'atom', 'gedit', 'kate', 'micro',
            'helix', 'hx', 'kakoune', 'kak'
        ]
    },
    'version_control': {
        'emoji': '🔀',
        'tools': [
            'git', 'svn', 'hg', 'fossil', 'bzr'
        ]
    },
    'build_tools': {
        'emoji': '🔨',
        'tools': [
            'make', 'cmake', 'ninja', 'bazel', 'gradle',
            'maven', 'mvn', 'ant', 'scons'
        ]
    },
    'package_managers': {
        'emoji': '📦',
        'tools': [
            'npm', 'yarn', 'pnpm', 'pip', 'pip3', 'poetry',
            'cargo', 'go', 'gem', 'bundle', 'composer',
            'apt', 'yum', 'brew', 'snap', 'flatpak'
        ]
    },
    'runners': {
        'emoji': '🚀',
        'tools': [
            'python', 'python3', 'node', 'deno', 'bun',
            'ruby', 'perl', 'php', 'java', 'javac',
            'gcc', 'g++', 'clang', 'rustc', 'go'
        ]
    },
    'file_tools': {
        'emoji': '📄',
        'tools': [
            'cat', 'less', 'more', 'head', 'tail',
            'grep', 'rg', 'ag', 'ack', 'find', 'fd',
            'ls', 'tree', 'bat', 'eza', 'lsd'
        ]
    },
    'system_tools': {
        'emoji': '⚙️',
        'tools': [
            'docker', 'podman', 'kubectl', 'k9s', 'helm',
            'terraform', 'ansible', 'vagrant', 'systemctl',
            'ps', 'top', 'htop', 'btop', 'netstat', 'ss'
        ]
    },
    'testing': {
        'emoji': '🧪',
        'tools': [
            'pytest', 'jest', 'mocha', 'rspec', 'phpunit',
            'cargo test', 'go test', 'npm test', 'yarn test'
        ]
    }
}

def get_all_tracked_tools():
    """Get a flat list of all tracked tools"""
    tools = []
    for category in TRACKED_TOOLS.values():
        tools.extend(category['tools'])
    return tools

def get_tool_category(tool):
    """Get the category for a specific tool"""
    for category_name, category_data in TRACKED_TOOLS.items():
        if tool in category_data['tools']:
            return category_name
    return 'other'

def get_category_emoji(category):
    """Get the emoji for a category"""
    if category in TRACKED_TOOLS:
        return TRACKED_TOOLS[category]['emoji']
    return '🔧'