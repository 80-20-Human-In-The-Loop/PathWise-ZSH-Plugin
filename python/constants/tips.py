"""PathWise Tips and Hints - Educational content for users"""

TIPS = {
    "pathwise": [
        "Use 'wj1' through 'wj5' to jump to your most visited directories instantly",
        "Run 'wfreq --insights' to see detailed analytics about your navigation patterns",
        "PathWise tracks time automatically - stay in a directory 5+ seconds to record it",
        "Use 'wfreq --config' to customize tracking settings and display preferences",
        "Your jump shortcuts update dynamically as your habits change throughout the day",
        "Run 'wfreq --reset' to clear all data and start fresh with new tracking",
        "PathWise rotates data daily at midnight - yesterday becomes your fallback",
        "Enable git tracking to see what type of work you do in each directory",
        "Sort by 'time' to see where you spend most time, or 'visits' for frequency",
        "PathWise learns your patterns - the more you navigate, the smarter it gets",
        "Check 'wfreq --insights' weekly to understand your productivity patterns",
        "Jump shortcuts persist across terminal sessions until your habits change",
        "Use PathWise data to identify time sinks and optimize your workflow",
        "PathWise tracks both visits and time - giving you complete navigation insights",
        "Configure minimum time to avoid tracking quick directory traversals",
        "Use 'wfreq --tools' to see which tools you use most in each directory",
        "Tool tracking reveals your workflow - see if you edit, compile, or debug more in each project",
        "Export your work patterns with 'wfreq --export' to share with teammates",
        "Use 'wfreq --export -filter=python' to export only Python-related project data",
        "Export current project with 'wfreq --export project.toml -filter=.' for focused reports",
        "TOML exports show WHERE you use each tool - perfect for onboarding new developers",
        "Share your exported TOML with teammates to demonstrate project workflows",
        "Filter exports by directory patterns to create focused work analytics",
        "Exported TOML files contain all your insights: time patterns, tools, and navigation flows",
    ],
    
    "zsh": [
        "Use 'cd -' to quickly jump back to your previous directory",
        "Press Ctrl+R to search through your command history interactively",
        "Use '!!' to repeat the last command, or 'sudo !!' to run it with sudo",
        "Tab completion works for commands, files, and even git branches",
        "Use 'cd **/<tab>' to fuzzy search for directories recursively",
        "Create permanent aliases in ~/.zshrc for your common commands",
        "Use 'which <command>' to find where a command is located",
        "Press Alt+. to insert the last argument from previous command",
        "Use 'dirs -v' to see your directory stack, 'cd ~N' to jump to entry N",
        "Enable case-insensitive completion with 'zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'",
        "Use 'bindkey' to see all keyboard shortcuts in your current shell",
        "Press Ctrl+L to clear the screen (faster than typing 'clear')",
        "Use 'fc' to edit and re-run the last command in your editor",
        "Set CDPATH to add common base directories for quick navigation",
        "Use parameter expansion: ${var:-default} for default values",
    ],
    
    "linux": [
        "Use 'ls -lah' to see all files with human-readable sizes",
        "Press Ctrl+Z to suspend a process, 'bg' to background it, 'fg' to foreground",
        "Use 'df -h' to check disk space, 'du -sh *' for directory sizes",
        "The 'tree' command shows directory structure visually (install if needed)",
        "Use 'grep -r \"pattern\" .' to search recursively in current directory",
        "Press Ctrl+D to logout or exit (cleaner than typing 'exit')",
        "Use 'ps aux | grep <name>' to find processes, 'kill -9 <pid>' to force stop",
        "The 'watch' command repeats any command periodically: 'watch -n 2 ls'",
        "Use 'chmod +x file' to make a file executable quickly",
        "Redirect errors with '2>' or both output and errors with '&>'",
        "Use 'find . -name \"*.txt\" -mtime -7' to find files modified in last 7 days",
        "The 'tee' command shows output and saves it: 'ls | tee output.txt'",
        "Use 'tail -f logfile' to watch a log file in real-time",
        "Create multiple directories at once: 'mkdir -p parent/child/grandchild'",
        "Use 'ln -s target link' to create symbolic links for easy access",
    ],
    
    "productivity": [
        "Organize projects in a consistent directory structure for faster navigation",
        "Use descriptive directory names - future you will thank present you",
        "Keep your home directory clean - use subdirectories for organization",
        "Create a ~/tmp directory for temporary work that you clean regularly",
        "Use version control (git) in all project directories for safety",
        "Batch similar tasks together to reduce context switching",
        "Review your PathWise insights weekly to optimize your workflow",
        "Set up project templates to standardize new project creation",
        "Use meaningful commit messages - they're documentation for future you",
        "Take breaks - productivity isn't about time spent but work accomplished",
        "Document your setup and workflows in a personal knowledge base",
        "Automate repetitive tasks with shell scripts or aliases",
        "Use virtual environments for Python projects to avoid conflicts",
        "Keep a 'notes.md' file in project roots for quick thoughts",
        "Learn keyboard shortcuts for your most-used applications",
    ],
    
    "git": [
        "Use 'git status' frequently to understand your repository state",
        "Run 'git diff --staged' to review changes before committing",
        "Use 'git log --oneline --graph' for a visual commit history",
        "Create meaningful branch names: feature/what-it-does",
        "Use 'git stash' to temporarily save work when switching contexts",
        "Run 'git commit --amend' to fix the last commit message",
        "Use 'git reset HEAD~1' to undo the last commit (keeping changes)",
        "Set up git aliases: 'git config --global alias.co checkout'",
        "Use 'git blame <file>' to see who changed each line and when",
        "Run 'git clean -fd' to remove untracked files and directories",
        "Use '.gitignore' to exclude files from version control",
        "Create atomic commits - each commit should do one thing",
        "Use 'git bisect' to find which commit introduced a bug",
        "Run 'git reflog' to recover lost commits or branches",
        "Tag releases: 'git tag -a v1.0.0 -m \"Version 1.0.0\"'",
    ],
    
    "advanced": [
        "Use process substitution: 'diff <(ls dir1) <(ls dir2)'",
        "Chain commands: '&&' for success, '||' for failure, ';' for always",
        "Use brace expansion: 'cp file.{txt,bak}' copies file.txt to file.bak",
        "Export functions in zsh: 'typeset -f -x function_name'",
        "Use 'exec' to replace the current shell with a command",
        "Create here-documents: 'cat << EOF > file.txt'",
        "Use extended globbing: 'setopt EXTENDED_GLOB' for advanced patterns",
        "Redirect stdout and stderr separately: 'cmd 1>out.txt 2>err.txt'",
        "Use coprocesses for bidirectional communication with commands",
        "Set up zsh hooks: add_zsh_hook for preexec, precmd, chpwd",
        "Use parameter expansion for string manipulation: ${var%suffix}",
        "Create associative arrays: 'typeset -A hash' in zsh",
        "Use 'zmodload' to load additional zsh modules for extra features",
        "Profile shell startup: 'zsh -x' to debug slow initialization",
        "Use 'compdef' to create custom completions for your functions",
    ]
}

def get_random_tip() -> tuple[str, str]:
    """Get a random tip from a random category
    
    Returns:
        tuple: (category, tip) - The category name and tip text
    """
    import random
    category = random.choice(list(TIPS.keys()))
    tip = random.choice(TIPS[category])
    return category, tip

def get_tip_from_category(category: str) -> str:
    """Get a random tip from a specific category
    
    Args:
        category: The category to select from
        
    Returns:
        str: A random tip from that category, or empty string if category doesn't exist
    """
    import random
    if category in TIPS:
        return random.choice(TIPS[category])
    return ""