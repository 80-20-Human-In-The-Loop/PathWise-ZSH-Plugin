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
    ],
    
    "bash_strings": [
        "Trim leading/trailing spaces: '${var##+([[:space:]])}' and '${var%%+([[:space:]])}' - github.com/dylanaraps/pure-bash-bible#trim-leading-and-trailing-white-space",
        "Get string length: '${#var}' returns character count without wc - github.com/dylanaraps/pure-bash-bible#get-the-length-of-a-string",
        "Split string on delimiter: 'IFS=: read -ra arr <<< \"$PATH\"' creates array - github.com/dylanaraps/pure-bash-bible#split-a-string-on-a-delimiter",
        "Lowercase string: '${var,,}' converts to lowercase in Bash 4+ - github.com/dylanaraps/pure-bash-bible#change-a-string-to-lowercase",
        "Uppercase string: '${var^^}' converts to uppercase in Bash 4+ - github.com/dylanaraps/pure-bash-bible#change-a-string-to-uppercase",
        "Reverse case: '${var~~}' toggles case of all characters - github.com/dylanaraps/pure-bash-bible#reverse-a-strings-case",
        "Remove spaces: '${var// /}' deletes all spaces from string - github.com/dylanaraps/pure-bash-bible#trim-all-white-space-from-string-and-truncate-spaces",
        "Check if string contains substring: '[[ $var == *\"text\"* ]]' pattern match - github.com/dylanaraps/pure-bash-bible#check-if-string-contains-a-substring",
        "Check string starts with: '[[ $var == text* ]]' prefix pattern - github.com/dylanaraps/pure-bash-bible#check-if-string-starts-with-substring",
        "Check string ends with: '[[ $var == *text ]]' suffix pattern - github.com/dylanaraps/pure-bash-bible#check-if-string-ends-with-substring",
        "Get first N chars: '${var:0:10}' extracts first 10 characters - github.com/dylanaraps/pure-bash-bible#get-the-first-n-characters-of-a-string",
        "Get last N chars: '${var: -10}' extracts last 10 characters (note space) - github.com/dylanaraps/pure-bash-bible#get-the-last-n-characters-of-a-string",
        "Get substring by offset: '${var:10:5}' gets 5 chars starting at position 10 - github.com/dylanaraps/pure-bash-bible#get-substring-by-offset-and-length",
        "Strip prefix: '${var#prefix}' removes shortest prefix match - github.com/dylanaraps/pure-bash-bible#strip-prefix-from-string",
        "Strip suffix: '${var%suffix}' removes shortest suffix match - github.com/dylanaraps/pure-bash-bible#strip-suffix-from-string",
        "Percent-encode string: Use printf '%s' \"$var\" | od -An -tx1 | tr ' ' % - github.com/dylanaraps/pure-bash-bible#percent-encode-a-string",
        "Regex match: '[[ $var =~ ^[0-9]+$ ]]' checks if string is all digits - github.com/dylanaraps/pure-bash-bible#check-if-string-matches-a-regex",
    ],
    
    "bash_arrays": [
        "Reverse array: 'for ((i=${#arr[@]}-1; i>=0; i--)); do rev+=(\"${arr[i]}\"); done' - github.com/dylanaraps/pure-bash-bible#reverse-an-array",
        "Remove duplicates: Keep unique values with associative array as set - github.com/dylanaraps/pure-bash-bible#remove-duplicate-array-elements",
        "Random array element: '${arr[RANDOM % ${#arr[@]}]}' picks random item - github.com/dylanaraps/pure-bash-bible#random-array-element",
        "Cycle through array: Use modulo '${arr[i++ % ${#arr[@]}]}' for infinite loop - github.com/dylanaraps/pure-bash-bible#cycle-through-an-array",
        "Toggle between values: 'var=$((1-var))' switches between 0 and 1 - github.com/dylanaraps/pure-bash-bible#toggle-between-two-values",
    ],
    
    "bash_loops": [
        "Loop over range: 'for i in {1..10}; do ...; done' iterates 1 to 10 - github.com/dylanaraps/pure-bash-bible#loop-over-a-range-of-numbers",
        "Variable range: 'for ((i=start; i<=end; i++)); do ...; done' with variables - github.com/dylanaraps/pure-bash-bible#loop-over-a-variable-range-of-numbers",
        "Loop over array: 'for elem in \"${arr[@]}\"; do ...; done' iterates elements - github.com/dylanaraps/pure-bash-bible#loop-over-an-array",
        "Loop with index: 'for i in \"${!arr[@]}\"; do echo ${arr[i]}; done' - github.com/dylanaraps/pure-bash-bible#loop-over-an-array-with-an-index",
        "Loop file contents: 'while IFS= read -r line; do ...; done < file' - github.com/dylanaraps/pure-bash-bible#loop-over-files-contents",
        "Loop over files: 'for f in *.txt; do [[ -e $f ]] || continue; ...; done' - github.com/dylanaraps/pure-bash-bible#loop-over-files-and-directories",
    ],
    
    "bash_file_handling": [
        "Read file to string: 'var=$(<file)' faster than cat for variable assignment - github.com/dylanaraps/pure-bash-bible#read-a-file-to-a-string",
        "Read file to array: 'readarray -t arr < file' or mapfile for line array - github.com/dylanaraps/pure-bash-bible#read-a-file-to-an-array-by-line",
        "Get first line: 'IFS= read -r line < file' reads just first line - github.com/dylanaraps/pure-bash-bible#get-the-first-n-lines-of-a-file",
        "Get last N lines: Store in array and print last elements for tail behavior - github.com/dylanaraps/pure-bash-bible#get-the-last-n-lines-of-a-file",
        "Line count: 'while IFS= read -r _; do ((count++)); done < file' - github.com/dylanaraps/pure-bash-bible#count-files-or-directories-in-directory",
        "Random line: Read to array then '${arr[RANDOM % ${#arr[@]}]}' - github.com/dylanaraps/pure-bash-bible#get-a-random-line-from-a-file",
        "Create temp file: 'tmp=$(mktemp) || exit 1' with proper error handling - github.com/dylanaraps/pure-bash-bible#create-a-temporary-file",
        "Extract path parts: '${file##*/}' for basename, '${file%/*}' for dirname - github.com/dylanaraps/pure-bash-bible#get-the-directory-name-of-a-file-path",
    ],
    
    "bash_conditionals": [
        "File tests: '[[ -f $file ]]' for regular file, '-d' for directory, '-e' exists - github.com/dylanaraps/pure-bash-bible#file-conditionals",
        "String empty check: '[[ -z $var ]]' tests if empty, '-n' for non-empty - github.com/dylanaraps/pure-bash-bible#string-conditionals",
        "Ternary operator: 'result=${var:+set}' expands to 'set' if var is non-empty - github.com/dylanaraps/pure-bash-bible#ternary-tests",
        "Check if in array: Loop and test each element or use associative array - github.com/dylanaraps/pure-bash-bible#check-if-a-string-is-in-an-array",
    ],
    
    "bash_variables": [
        "Name reference: 'declare -n ref=var' creates reference to another variable - github.com/dylanaraps/pure-bash-bible#assign-and-access-a-variable-using-a-variable",
        "Default value: '${var:-default}' uses default if var is unset or empty - github.com/dylanaraps/pure-bash-bible#default-value-for-variable",
    ],
    
    "bash_arithmetic": [
        "Math operations: '((result = 5 + 3 * 2))' evaluates arithmetic expressions - github.com/dylanaraps/pure-bash-bible#simpler-syntax-to-set-variables",
        "Sequence generation: 'for i in {1..100}; do ...; done' without seq command - github.com/dylanaraps/pure-bash-bible#use-seq-alternative",
    ],
    
    "bash_traps": [
        "Cleanup on exit: 'trap cleanup EXIT' runs cleanup function on script exit - github.com/dylanaraps/pure-bash-bible#do-something-on-script-exit",
        "Ignore Ctrl+C: 'trap '' INT' ignores interrupt signal (SIGINT) - github.com/dylanaraps/pure-bash-bible#ignore-terminal-interrupts-ctrl-c-sigint",
        "React to signals: 'trap \"echo Caught\" INT TERM' handles multiple signals - github.com/dylanaraps/pure-bash-bible#react-to-signals",
        "Run in background: 'command &' runs async, 'wait' to synchronize - github.com/dylanaraps/pure-bash-bible#run-a-command-in-the-background",
        "Timeout command: Use timeout with trap for time-limited execution - github.com/dylanaraps/pure-bash-bible#run-a-command-for-a-specific-time",
    ],
    
    "bash_terminal": [
        "Get terminal size: 'read -r LINES COLUMNS < <(stty size)' without tput - github.com/dylanaraps/pure-bash-bible#get-the-terminal-size-in-lines-and-columns",
        "Move cursor: 'printf '\\e[5;10H'' moves to line 5, column 10 - github.com/dylanaraps/pure-bash-bible#move-the-cursor",
        "Clear screen: 'printf '\\e[2J\\e[H'' clears and homes cursor - github.com/dylanaraps/pure-bash-bible#clear-the-screen",
    ],
    
    "bash_internals": [
        "Get function name: '${FUNCNAME[0]}' returns current function name - github.com/dylanaraps/pure-bash-bible#get-the-current-function-name",
        "Get hostname: '${HOSTNAME:-$(hostname)}' without external command - github.com/dylanaraps/pure-bash-bible#get-the-hostname",
        "Brace expansion: '{1..10}' expands to '1 2 3 4 5 6 7 8 9 10' - github.com/dylanaraps/pure-bash-bible#brace-expansion",
        "Check command type: 'type -t cmd' returns alias/function/builtin/file - github.com/dylanaraps/pure-bash-bible#check-what-type-of-command",
    ],
    
    "bash_other": [
        "UUID generation: Read from /proc/sys/kernel/random/uuid if available - github.com/dylanaraps/pure-bash-bible#generate-a-uuid",
        "Progress bar: Use printf with carriage return '\\r' to update same line - github.com/dylanaraps/pure-bash-bible#simple-progress-bar",
        "Get epoch: 'printf '%(%s)T' -1' in Bash 4.2+ instead of date +%s - github.com/dylanaraps/pure-bash-bible#get-the-current-date-and-time",
        "Format date: 'printf '%(%Y-%m-%d)T' -1' formats without date command - github.com/dylanaraps/pure-bash-bible#format-the-current-date-and-time",
        "Hex to RGB: Use printf '%d' 0x${hex:0:2} to convert hex color values - github.com/dylanaraps/pure-bash-bible#convert-hex-color-to-rgb",
        "RGB to hex: 'printf '#%02x%02x%02x' $r $g $b' converts RGB to hex - github.com/dylanaraps/pure-bash-bible#convert-rgb-color-to-hex",
        "Pseudo-random: '$((RANDOM % 100))' gives 0-99, seed with RANDOM=seed - github.com/dylanaraps/pure-bash-bible#generate-a-pseudo-random-number",
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