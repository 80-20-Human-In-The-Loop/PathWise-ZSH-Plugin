# PathWise Tips and Tricks

> **Comprehensive guide to terminal productivity, development tools, and command-line mastery**

## About This Guide

This documentation contains over 300 practical tips and techniques for terminal productivity, development workflows, and command-line mastery. These tips are integrated into PathWise as educational content, appearing randomly when you use the `wfreq` command to help you learn and improve your command-line skills.

Each tip includes:
- **Clear explanation** of what the command or technique does
- **Practical examples** showing real-world usage
- **Context** explaining when and why to use it
- **Source links** to official documentation for deeper learning

Whether you're a beginner learning the basics or an experienced developer looking to optimize your workflow, this guide provides valuable insights for working more effectively in the terminal.

---

## Table of Contents

1. [PathWise Plugin Tips](#pathwise-plugin-tips)
2. [Zsh Shell Productivity](#zsh-shell-productivity)
3. [Linux System Commands](#linux-system-commands)
4. [Git Version Control](#git-version-control)
5. [Productivity and Workflow](#productivity-and-workflow)
6. [Terminal Features](#terminal-features)
7. [Tmux Terminal Multiplexing](#tmux-terminal-multiplexing)
8. [SSH and Remote Access](#ssh-and-remote-access)
9. [Modern CLI Tools](#modern-cli-tools)
10. [Docker Containers](#docker-containers)
11. [Performance Monitoring](#performance-monitoring)
12. [Text Editors](#text-editors)
13. [Security and Permissions](#security-and-permissions)
14. [Networking](#networking)
15. [Package Management](#package-management)
16. [Bash Programming](#bash-programming)
    - [String Manipulation](#string-manipulation)
    - [Array Operations](#array-operations)
    - [Loop Constructs](#loop-constructs)
    - [File Handling](#file-handling)
    - [Conditionals and Testing](#conditionals-and-testing)
    - [Variables and References](#variables-and-references)
    - [Arithmetic Operations](#arithmetic-operations)
    - [Signal Handling and Traps](#signal-handling-and-traps)
    - [Terminal Control](#terminal-control)
    - [Shell Internals](#shell-internals)
    - [Advanced Techniques](#advanced-techniques)

---

## PathWise Plugin Tips

**What it covers**: Tips specific to using PathWise for directory navigation, time tracking, and productivity analysis.

**When to use**: When working with PathWise to optimize your navigation patterns and understand your work habits.

### Navigation and Jump Shortcuts

#### Use jump shortcuts for instant directory access

```bash
wj1  # Jump to most visited directory
wj2  # Jump to second most visited directory
wj3  # Jump to third most visited directory
wj4  # Jump to fourth most visited directory  
wj5  # Jump to fifth most visited directory
```

**What it does**: Provides instant access to your most frequently visited directories without typing full paths.

**Why it's useful**: Eliminates the need to remember or type long directory paths. The shortcuts update dynamically based on your actual usage patterns, so they always point to your most relevant directories.

**Learn more**: See `wfreq --help` for all navigation commands.

#### Jump shortcuts update dynamically with your habits

**What it does**: The jump shortcuts (`wj1` through `wj5`) automatically adapt to your changing directory usage patterns throughout the day.

**Why it's useful**: Your most-visited directories change as you work on different projects. PathWise learns these patterns and updates shortcuts in real-time, ensuring they're always relevant to your current workflow.

#### Jump shortcuts persist across terminal sessions

**What it does**: Your jump shortcuts remain available even after closing and reopening terminal sessions.

**Why it's useful**: Maintains consistency in your navigation workflow across different terminal windows and sessions, supporting a seamless development experience.

### Insights and Analytics

#### View detailed analytics with insights command

```bash
wfreq --insights
```

**What it does**: Displays comprehensive analytics about your directory navigation patterns, including time spent, visit frequency, and git activity patterns.

**Why it's useful**: Understanding where you spend time helps optimize your workflow and identify potential inefficiencies in your development process.

#### Check insights weekly to optimize your workflow

**What it does**: Regular review of PathWise insights reveals patterns in your development workflow over time.

**Why it's useful**: Weekly analysis helps identify productivity trends, time sinks, and opportunities for workflow optimization. Patterns become more apparent over longer time periods.

#### Track what tools you use in each directory

```bash
wfreq --tools
```

**What it does**: Shows which development tools and commands you use most frequently in each directory.

**Why it's useful**: Reveals your actual workflow patterns and helps identify which directories are used for editing, compiling, debugging, or other specific activities. Useful for onboarding new team members or documenting project workflows.

### Configuration and Customization  

#### Customize tracking settings and preferences

```bash
wfreq --config
```

**What it does**: Opens PathWise configuration options to customize tracking behavior, display preferences, and feature settings.

**Why it's useful**: Allows you to tailor PathWise to your specific workflow needs, adjust sensitivity settings, and enable/disable features based on your preferences.

#### Configure minimum time to avoid tracking quick traversals

**What it does**: Sets a minimum time threshold before PathWise records a directory visit, filtering out brief directory changes.

**Why it's useful**: Prevents cluttering your navigation data with accidental or very brief directory visits, keeping your analytics focused on meaningful work locations.

#### Enable git tracking for work pattern analysis

**What it does**: Activates tracking of git commits to categorize the type of work being done in each directory.

**Why it's useful**: Provides deeper insights into your development patterns by showing whether you're primarily fixing bugs, adding features, writing tests, or doing other types of work in each project.

#### Sort by time or visits for different perspectives

**What it does**: Allows you to view directory analytics sorted either by time spent in directories or by number of visits.

**Why it's useful**: Different sorting methods reveal different aspects of your workflow. Time-based sorting shows where you focus deeply, while visit-based sorting shows where you work frequently but briefly.

### Time Tracking

#### Automatic time tracking with 5-second minimum

**What it does**: PathWise automatically starts tracking time when you stay in a directory for 5 or more seconds.

**Why it's useful**: Captures meaningful work time while filtering out brief directory traversals. The 5-second threshold ensures only intentional work is tracked.

#### Daily data rotation at midnight

**What it does**: PathWise rotates tracking data daily at midnight, with yesterday's data serving as fallback when today's data is limited.

**Why it's useful**: Provides both current and historical context for navigation patterns while keeping data manageable and relevant to recent work patterns.

#### PathWise learns your patterns over time

**What it does**: The tracking system continuously learns from your navigation behavior to provide increasingly accurate recommendations and insights.

**Why it's useful**: The longer you use PathWise, the better it becomes at predicting your needs and providing relevant navigation shortcuts and analytics.

### Export and Sharing

#### Export work patterns for sharing

```bash
wfreq --export my-patterns.toml
```

**What it does**: Exports your navigation and work pattern data to a TOML file that can be shared with team members.

**Why it's useful**: Enables knowledge sharing about project workflows and development patterns with team members. Helpful for onboarding new developers or documenting project structures.

#### Filter exports by technology or project

```bash
wfreq --export --filter=python   # Export only Python-related data
wfreq --export --filter=.        # Export current project data
```

**What it does**: Creates filtered exports containing only data relevant to specific technologies or projects.

**Why it's useful**: Allows you to share focused insights about specific aspects of your workflow rather than your entire navigation history. Useful for technology-specific onboarding or project documentation.

#### TOML exports show tool usage patterns

**What it does**: Exported files include detailed information about which tools are used in each directory, providing comprehensive workflow documentation.

**Why it's useful**: New team members can see not just which directories are important, but what types of work happen in each location. This creates a complete picture of project workflows and development patterns.

### Data Management

#### Reset all data to start fresh

```bash
wfreq --reset
```

**What it does**: Clears all PathWise tracking data and starts with a clean slate.

**Why it's useful**: Useful when starting a new role, major workflow changes, or when you want to focus tracking on current projects without historical data influencing recommendations.

#### Use PathWise data to identify time sinks

**What it does**: Analytics reveal directories and activities where you spend disproportionate amounts of time.

**Why it's useful**: Helps identify potential inefficiencies in your workflow, such as directories where you spend a lot of time due to poor tooling or complex processes that could be optimized.

---

## Zsh Shell Productivity

**What it covers**: Zsh-specific features, shortcuts, and productivity enhancements that make shell interaction more efficient.

**When to use**: Daily terminal work, command history management, and shell customization.

### History and Navigation

#### Jump back to previous directory instantly

```bash
cd -
```

**What it does**: Switches to the directory you were in before the current one, like an "undo" for directory changes.

**Why it's useful**: Essential for jumping between two directories you're actively working in. Much faster than typing full paths repeatedly.

**Learn more**: [Zsh Manual - Directory Stack](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Filename-Expansion)

#### Search command history interactively

```bash
# Press Ctrl+R then type search terms
```

**What it does**: Opens an interactive search interface to find and execute previous commands by typing partial matches.

**Why it's useful**: Quickly find and re-run complex commands from your history without retyping. Especially valuable for commands with many flags or long arguments.

**Learn more**: [Zsh Line Editor](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html)

#### Repeat commands with history expansion

```bash
!!        # Repeat last command
sudo !!   # Run last command with sudo
!grep     # Repeat last command starting with 'grep'
```

**What it does**: Expands to previous commands using history shortcuts, allowing quick re-execution or modification.

**Why it's useful**: Saves typing when you need to repeat or slightly modify recent commands. The `sudo !!` pattern is particularly useful when you forget to run a command with elevated privileges.

#### Edit and re-run commands in your editor

```bash
fc
```

**What it does**: Opens the last command in your default editor for editing, then executes the modified version when you save and close.

**Why it's useful**: Perfect for complex multi-line commands or when you need to make several changes to a long command. More convenient than arrow key editing for substantial modifications.

### Tab Completion and Expansion

#### Advanced tab completion for commands and files

**What it does**: Provides intelligent completion for commands, files, directories, and even context-specific options like git branches.

**Why it's useful**: Reduces typing and prevents errors. Zsh's completion system is more intelligent than bash, understanding context and providing relevant suggestions.

**Learn more**: [Zsh Completion System](http://zsh.sourceforge.net/Doc/Release/Completion-System.html)

#### Fuzzy directory search with globbing

```bash
cd **/partial<tab>  # Finds directories matching 'partial' recursively
cd **/*test*<tab>   # Finds directories containing 'test' anywhere in path
```

**What it does**: Uses recursive globbing to find and complete directory names anywhere in the directory tree.

**Why it's useful**: Navigate deep directory structures without knowing exact paths. Particularly useful in large codebases with nested directory structures.

#### Case-insensitive completion

```bash
# Add to ~/.zshrc:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
```

**What it does**: Enables tab completion that ignores case differences between what you type and actual filenames.

**Why it's useful**: Reduces friction when you don't remember exact capitalization of files or directories. Particularly helpful on case-sensitive filesystems.

### Directory Stack and Movement

#### Use directory stack for navigation

```bash
dirs -v    # Show directory stack with numbers
cd ~1      # Jump to directory 1 in stack
cd ~2      # Jump to directory 2 in stack
```

**What it does**: Maintains a stack of recently visited directories that you can jump back to using numbers.

**Why it's useful**: Navigate between multiple directories efficiently. Better than `cd -` when you need to switch between more than two locations.

**Learn more**: [Directory Stack](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Directory-Stack)

#### Set CDPATH for quick navigation

```bash
# Add to ~/.zshrc:
CDPATH=".:$HOME:$HOME/projects:$HOME/work"
```

**What it does**: Allows `cd` to find directories in specified base paths without typing full paths.

**Why it's useful**: Jump to project directories from anywhere by typing just the project name. Reduces the need to remember full directory paths.

### Command Line Editing

#### Insert last argument from previous command

```bash
# Press Alt+. (Alt and period)
```

**What it does**: Inserts the last argument from the previous command at the current cursor position.

**Why it's useful**: Frequently you want to operate on the same file or directory as the previous command. This saves retyping paths and filenames.

#### Clear screen efficiently

```bash
# Press Ctrl+L
```

**What it does**: Clears the terminal screen while preserving command history and current command line.

**Why it's useful**: Faster than typing `clear` and doesn't interrupt your current command typing. Keeps your workspace clean and focused.

### Shell Configuration

#### Find command locations

```bash
which command_name    # Show path to command
type command_name     # Show command type and location
```

**What it does**: Displays the full path to executable commands or shows if they're built-in commands, aliases, or functions.

**Why it's useful**: Debug PATH issues, understand what version of a command you're running, and verify command availability.

#### View all keyboard shortcuts

```bash
bindkey
```

**What it does**: Lists all keyboard shortcuts and key bindings currently active in your shell.

**Why it's useful**: Discover available shortcuts and troubleshoot key binding issues. Helps you learn more efficient ways to interact with the shell.

### Advanced Features

#### Use parameter expansion for default values

```bash
echo ${VAR:-default}    # Use 'default' if VAR is unset
echo ${VAR:=default}    # Set VAR to 'default' if unset
```

**What it does**: Provides default values for variables that might not be set, with options to either just use the default or also set the variable.

**Why it's useful**: Makes scripts more robust by handling undefined variables gracefully. Particularly useful in configuration scripts and environment setup.

**Learn more**: [Parameter Expansion](http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion)

#### Create permanent aliases

```bash
# Add to ~/.zshrc:
alias ll='ls -la'
alias grep='grep --color=auto'
alias ..='cd ..'
```

**What it does**: Creates shortcuts for commonly used commands that persist across shell sessions.

**Why it's useful**: Customize your shell environment to match your workflow. Save typing for frequently used command combinations and add helpful defaults to commands.

**Learn more**: [Zsh Manual - Aliases](http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Aliases)

---

## Linux System Commands

**What it covers**: Essential Linux commands for file management, process control, and system administration.

**When to use**: System administration, file operations, and general Linux usage.

### File Operations

#### List files with detailed information

```bash
ls -lah
```

**What it does**: Lists all files (including hidden ones) in long format with human-readable file sizes.

**Why it's useful**: Provides complete file information including permissions, ownership, size, and modification dates in an easy-to-read format. The `-a` shows hidden files, `-l` gives detailed information, and `-h` makes sizes human-readable (KB, MB, GB).

**Learn more**: `man ls`

#### Create directory structures in one command

```bash
mkdir -p parent/child/grandchild
```

**What it does**: Creates nested directories, automatically creating parent directories if they don't exist.

**Why it's useful**: Sets up complex directory structures without having to create each level individually. Essential for project setup and organization.

#### Create symbolic links for easy access

```bash
ln -s /path/to/target /path/to/link
```

**What it does**: Creates a symbolic link (shortcut) that points to another file or directory.

**Why it's useful**: Provides convenient access to files or directories from multiple locations without duplicating data. Commonly used for configuration files and frequently accessed directories.

**Learn more**: `man ln`

#### Make files executable quickly

```bash
chmod +x filename
```

**What it does**: Adds execute permission to a file for the owner, group, and others.

**Why it's useful**: Essential for making scripts and programs runnable. Quick way to set execute permissions without dealing with numeric permission codes.

**Learn more**: `man chmod`

### Process Management

#### Suspend, background, and foreground processes

```bash
# Press Ctrl+Z to suspend current process
bg    # Move suspended process to background
fg    # Bring background process to foreground
```

**What it does**: Provides job control for managing running processes - suspend them, run them in background, or bring them back to foreground.

**Why it's useful**: Manage long-running processes without losing your terminal. Essential for multitasking and handling processes that don't need constant attention.

**Learn more**: `man bg`, `man fg`

#### Find and manage processes

```bash
ps aux | grep process_name    # Find processes
kill -9 PID                   # Force kill process by ID
killall process_name          # Kill all processes by name
```

**What it does**: Locates running processes and provides various ways to terminate them.

**Why it's useful**: Essential for troubleshooting hung processes, managing system resources, and stopping runaway programs. The `kill -9` signal cannot be ignored by processes.

**Learn more**: `man ps`, `man kill`

#### Exit terminal cleanly

```bash
# Press Ctrl+D
```

**What it does**: Sends EOF (end-of-file) signal to close terminal or shell sessions cleanly.

**Why it's useful**: Cleaner way to exit than typing `exit`. Works in most shell contexts and is faster for frequent terminal use.

### System Information

#### Check disk space usage

```bash
df -h              # Show filesystem disk space
du -sh *          # Show size of files/directories in current location
du -sh /path/*    # Show sizes of specific directory contents
```

**What it does**: Displays disk space usage either for entire filesystems or specific directories/files in human-readable format.

**Why it's useful**: Monitor disk space to prevent running out of storage. Identify which directories are consuming the most space for cleanup purposes.

**Learn more**: `man df`, `man du`

#### Watch commands run periodically

```bash
watch -n 2 ls          # Run 'ls' every 2 seconds
watch -n 5 df -h       # Monitor disk space every 5 seconds
```

**What it does**: Repeatedly executes a command at specified intervals, updating the display each time.

**Why it's useful**: Monitor changing information like disk usage, process lists, or log files without manually re-running commands. Great for observing system changes over time.

**Learn more**: `man watch`

#### Visualize directory structure

```bash
tree              # Show directory structure as tree
tree -L 2         # Limit depth to 2 levels
tree -a           # Include hidden files
```

**What it does**: Displays directory structure in a visual tree format, showing the hierarchical relationship between directories and files.

**Why it's useful**: Quickly understand project structure and file organization. Particularly valuable for documenting project layouts or understanding unfamiliar codebases.

**Note**: May need to install with `sudo apt install tree` or equivalent.

### Text Processing and Search

#### Search files recursively

```bash
grep -r "pattern" .              # Search for pattern in current directory
grep -r "error" /var/log/        # Search logs for error messages
grep -rn "TODO" .                # Include line numbers in results
```

**What it does**: Searches for text patterns recursively through directory trees.

**Why it's useful**: Find specific content across multiple files quickly. Essential for debugging, code analysis, and log file investigation. The `-n` flag shows line numbers for context.

**Learn more**: `man grep`

#### Watch log files in real-time

```bash
tail -f /var/log/syslog          # Follow system log
tail -f application.log          # Follow application log
tail -n 50 -f logfile           # Show last 50 lines then follow
```

**What it does**: Displays the end of files and continuously shows new lines as they're added.

**Why it's useful**: Essential for monitoring active log files, debugging applications in real-time, and watching system activity as it happens.

**Learn more**: `man tail`

#### Display and save command output

```bash
ls -la | tee output.txt          # Show output and save to file
command | tee -a logfile         # Append output to existing file
```

**What it does**: Shows command output on screen while simultaneously saving it to a file.

**Why it's useful**: Keep records of command output for later analysis while still seeing results immediately. Useful for logging system information or preserving important command results.

**Learn more**: `man tee`

### File Search and Discovery

#### Find files by name and date

```bash
find . -name "*.txt"                    # Find all .txt files
find . -name "*.log" -mtime -7         # Find .log files modified in last 7 days
find /home -name "config*" -type f     # Find files starting with 'config'
```

**What it does**: Searches for files and directories based on various criteria including name patterns, modification time, and file type.

**Why it's useful**: Locate files when you know part of the name or when they were modified. Essential for file management, cleanup, and system administration.

**Learn more**: `man find`

### Output Redirection

#### Redirect errors and output

```bash
command 2> errors.txt            # Redirect only errors to file
command &> all_output.txt        # Redirect both output and errors
command > output.txt 2>&1        # Alternative syntax for both
```

**What it does**: Controls where command output and error messages are sent - to files, other commands, or different locations.

**Why it's useful**: Separate normal output from error messages for better debugging. Save command results for later analysis or prevent cluttering terminal with verbose output.

**Learn more**: [Bash Manual - Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)

---

## Git Version Control

**What it covers**: Git commands and workflows for effective version control and collaboration.

**When to use**: Software development, project management, and team collaboration.

### Daily Git Workflow

#### Check repository status frequently

```bash
git status
```

**What it does**: Shows the current state of your repository including staged changes, unstaged changes, untracked files, and current branch.

**Why it's useful**: Essential for understanding what changes you have before committing. Helps prevent accidental commits and keeps you aware of your repository state.

**Learn more**: [Git Status Documentation](https://git-scm.com/docs/git-status)

#### Review changes before committing

```bash
git diff                 # Show unstaged changes
git diff --staged        # Show staged changes ready for commit
git diff HEAD~1          # Compare with previous commit
```

**What it does**: Displays differences between various states of your repository - working directory, staging area, and previous commits.

**Why it's useful**: Review exactly what you're about to commit to avoid mistakes. Essential for code quality and understanding your changes.

#### Create atomic commits

**What it does**: Each commit should represent one logical change or feature.

**Why it's useful**: Makes history easier to understand, simplifies debugging with `git bisect`, and makes it easier to revert specific changes without affecting other work.

**Best practice**: Commit related changes together, separate unrelated changes into different commits.

### History and Inspection

#### Visual commit history

```bash
git log --oneline --graph           # Compact visual history
git log --oneline --graph --all     # Include all branches
```

**What it does**: Shows commit history in a compact, visual format that displays the branching structure.

**Why it's useful**: Quickly understand project history and branch relationships. Much more readable than default log format for getting an overview.

#### Find who changed specific lines

```bash
git blame filename              # Show who last changed each line
git blame -L 10,20 filename    # Blame specific line range
```

**What it does**: Shows who last modified each line in a file and when, along with the commit hash.

**Why it's useful**: Understand the context of code changes, find who to ask about specific code, and track down when bugs were introduced.

#### Find the commit that introduced a bug

```bash
git bisect start
git bisect bad                    # Current commit is bad
git bisect good commit_hash       # Known good commit
# Git will guide you through testing commits
```

**What it does**: Uses binary search to efficiently find the commit that introduced a problem by testing commits between known good and bad states.

**Why it's useful**: Quickly identify when bugs were introduced in large commit histories. Much faster than manually checking commits.

**Learn more**: [Git Bisect Documentation](https://git-scm.com/docs/git-bisect)

### Staging and Commit Management

#### Temporarily save work in progress

```bash
git stash                        # Save current changes
git stash pop                    # Restore most recent stash
git stash list                   # See all stashes
git stash apply stash@{0}        # Apply specific stash
```

**What it does**: Temporarily saves uncommitted changes so you can switch branches or pull updates, then restore the changes later.

**Why it's useful**: Handle interruptions without losing work or making incomplete commits. Essential for context switching between different features.

#### Fix the last commit

```bash
git commit --amend              # Edit last commit message
git add file && git commit --amend    # Add files to last commit
```

**What it does**: Modifies the most recent commit, either changing the message or adding forgotten files.

**Why it's useful**: Fix typos in commit messages or add files you forgot to stage. Keeps history clean by avoiding "fix typo" commits.

#### Undo commits safely

```bash
git reset HEAD~1               # Undo last commit, keep changes
git reset --soft HEAD~1        # Undo commit, keep changes staged
git reset --hard HEAD~1        # Undo commit, discard changes
```

**What it does**: Removes recent commits with different levels of preservation for your changes.

**Why it's useful**: Recover from commit mistakes while choosing whether to keep your work. `--soft` is safest, `--hard` discards everything.

### Branch and Remote Management

#### Create meaningful branch names

```bash
git checkout -b feature/user-authentication
git checkout -b bugfix/login-error
git checkout -b hotfix/security-patch
```

**What it does**: Creates descriptive branch names that indicate the type and purpose of work.

**Why it's useful**: Makes it easy to understand what each branch contains. Helpful for team collaboration and project management.

#### Clean up untracked files

```bash
git clean -n                   # Preview what will be deleted
git clean -fd                  # Remove untracked files and directories
```

**What it does**: Removes files that aren't tracked by git and aren't in .gitignore.

**Why it's useful**: Clean up build artifacts, temporary files, or abandoned work. The `-n` flag lets you preview before actually deleting.

#### Recover lost commits

```bash
git reflog                     # Show all recent HEAD changes
git checkout commit_hash       # Go to specific commit
git cherry-pick commit_hash    # Apply specific commit
```

**What it does**: Shows a history of all changes to HEAD, allowing you to find and recover seemingly lost commits.

**Why it's useful**: Recover from mistakes like hard resets or deleted branches. Git keeps commits for about 30 days even if they seem lost.

### Configuration and Efficiency

#### Set up helpful aliases

```bash
git config --global alias.co checkout
git config --global alias.br branch  
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
```

**What it does**: Creates shortcuts for frequently used git commands.

**Why it's useful**: Speeds up daily git workflow and reduces typing. Can create complex aliases for multi-step operations.

#### Use .gitignore effectively

```bash
# Create .gitignore file with common patterns
echo "*.log" >> .gitignore
echo "node_modules/" >> .gitignore
echo ".env" >> .gitignore
```

**What it does**: Tells git to ignore specified files and directories, preventing them from being tracked.

**Why it's useful**: Keeps repository clean by excluding build artifacts, dependencies, and sensitive files. Prevents accidental commits of generated files.

#### Tag important releases

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"    # Create annotated tag
git push origin --tags                           # Push tags to remote
```

**What it does**: Creates permanent markers for specific commits, typically used for releases and important milestones.

**Why it's useful**: Easily reference and checkout specific versions. Essential for release management and deployment workflows.

---

## Productivity and Workflow

**What it covers**: General productivity strategies, project organization, and workflow optimization techniques.

**When to use**: Setting up development environments and optimizing work processes.

### Project Organization

#### Organize projects with consistent directory structure

**What it does**: Establishes standardized directory layouts across all projects for predictable navigation.

**Why it's useful**: Reduces cognitive load when switching between projects. Team members can quickly orient themselves in any project following the same structure. Improves automation and tooling consistency.

**Best practice**: Use templates like `src/`, `docs/`, `tests/`, `config/` consistently across projects.

#### Use descriptive directory names

**What it does**: Choose directory names that clearly indicate their purpose and content.

**Why it's useful**: Future you will understand project structure immediately. New team members can navigate projects intuitively. Reduces time spent figuring out where things belong.

**Example**: Use `user-authentication` instead of `auth`, `database-migrations` instead of `db-stuff`.

#### Keep your home directory clean

**What it does**: Use subdirectories and organized folder structure instead of cluttering your home directory with files.

**Why it's useful**: Faster navigation, easier backups, reduced visual noise. Makes it easier to find important files and maintain system organization.

**Best practice**: Create folders like `~/projects/`, `~/documents/work/`, `~/tmp/` for different types of content.

#### Create a temporary work directory

```bash
mkdir -p ~/tmp
# Clean it regularly
find ~/tmp -type f -mtime +7 -delete
```

**What it does**: Provides a dedicated space for temporary files, experiments, and throwaway work that gets cleaned regularly.

**Why it's useful**: Prevents temporary files from cluttering important directories. Makes cleanup easy and systematic. Provides a safe space for experiments.

### Development Environment

#### Use version control everywhere

```bash
git init    # Initialize git in every project directory
```

**What it does**: Track changes in all project directories, not just code repositories.

**Why it's useful**: Protects against accidental changes, provides change history for configuration files, enables collaboration on any type of project. Essential safety net for all work.

#### Set up project templates

```bash
mkdir -p ~/.templates/python-project
# Create standard structure once, copy for new projects
cp -r ~/.templates/python-project ~/projects/new-project
```

**What it does**: Standardizes new project creation with consistent structure, configuration files, and tooling setup.

**Why it's useful**: Reduces setup time for new projects, ensures consistency across projects, includes all necessary configuration from the start.

#### Use virtual environments for isolation

```bash
python -m venv venv             # Python virtual environment
source venv/bin/activate        # Activate environment
```

**What it does**: Creates isolated environments for project dependencies to avoid conflicts between projects.

**Why it's useful**: Prevents dependency conflicts, makes projects reproducible, allows different projects to use different versions of the same tools.

**Learn more**: [Python Virtual Environments](https://docs.python.org/3/tutorial/venv.html)

#### Automate repetitive tasks

```bash
# Create shell scripts or aliases for common tasks
alias deploy='./scripts/deploy.sh'
alias test-all='npm test && python -m pytest'
```

**What it does**: Reduces manual work by scripting common sequences of commands.

**Why it's useful**: Saves time, reduces errors from manual steps, makes complex operations accessible to team members. Enables consistent execution of important processes.

### Time Management and Focus

#### Batch similar tasks together

**What it does**: Group similar activities (like code reviews, email, testing) into dedicated time blocks.

**Why it's useful**: Reduces context switching overhead, maintains focus, improves efficiency. Each type of work has different cognitive requirements that benefit from sustained attention.

#### Take strategic breaks

**What it does**: Step away from work periodically to maintain productivity and mental clarity.

**Why it's useful**: Prevents burnout, maintains code quality, often leads to breakthrough insights. Productivity is about work accomplished, not time spent at desk.

#### Review your work patterns weekly

**What it does**: Regular analysis of how time is spent and where productivity bottlenecks occur.

**Why it's useful**: Identifies patterns not visible day-to-day, reveals opportunities for optimization, helps adjust workflows based on actual data rather than assumptions.

#### Learn keyboard shortcuts

**What it does**: Master keyboard shortcuts for frequently used applications and tools.

**Why it's useful**: Significantly reduces time spent on routine operations. Keeps focus on the task rather than tool manipulation. Compounds over time for massive efficiency gains.

**Best practice**: Learn 2-3 new shortcuts per week rather than trying to memorize everything at once.

### Documentation and Workflow

#### Keep notes in project directories

```bash
# Create project documentation
echo "# Project Notes" > notes.md
echo "## Setup Instructions" >> notes.md
echo "## Common Issues" >> notes.md
```

**What it does**: Maintains project-specific documentation and notes directly within the project structure.

**Why it's useful**: Context remains with the project, easily accessible to team members, version controlled alongside code. Reduces time spent remembering or explaining project details.

#### Document your setup and workflows

**What it does**: Create documentation for development environment setup, common procedures, and troubleshooting steps.

**Why it's useful**: Enables team members to replicate your setup, reduces time spent on repeated explanations, preserves knowledge when team members change roles.

#### Use meaningful commit messages

```bash
git commit -m "fix: resolve memory leak in image processing"
git commit -m "feat: add offline mode for mobile users"
```

**What it does**: Creates clear documentation of what changes were made and why.

**Why it's useful**: Commit messages serve as documentation for future developers (including yourself). Make debugging and code archaeology much more effective.

**Learn more**: [Conventional Commits](https://www.conventionalcommits.org/)

#### Build a personal knowledge base

**What it does**: Maintain a collection of solutions, processes, and learning that you can reference and build upon.

**Why it's useful**: Prevents re-solving the same problems repeatedly, builds expertise over time, creates valuable resource for career development and team contribution.

---

## Terminal Features

**What it covers**: Modern terminal emulator features and capabilities that enhance the command-line experience.

**When to use**: Setting up and customizing terminal environments for better usability.

### Window and Tab Management

#### Use tabs for organized workflow

```bash
# Most terminals support:
Ctrl+Shift+T    # Open new tab
Ctrl+Shift+W    # Close current tab
Ctrl+PageUp     # Switch to previous tab
Ctrl+PageDown   # Switch to next tab
```

**What it does**: Organizes multiple terminal sessions within a single window using tabs.

**Why it's useful**: Keeps related terminal sessions grouped together, reduces window clutter, provides easy switching between different tasks or projects.

#### Close tabs efficiently

**What it does**: Provides keyboard shortcut for quickly closing terminal tabs without using the mouse.

**Why it's useful**: Maintains keyboard-focused workflow, speeds up terminal management, reduces interruption to your typing flow.

### Text Selection and Clipboard

#### Click URLs to open them

```bash
# Hold Ctrl while clicking URLs in most modern terminals
```

**What it does**: Makes URLs in terminal output clickable when holding the Ctrl key.

**Why it's useful**: Quick access to documentation links, repository URLs, or web resources mentioned in command output without copy-pasting.

#### Select rectangular text blocks

```bash
# Hold Alt while selecting text
```

**What it does**: Allows selection of rectangular regions of text instead of just line-by-line selection.

**Why it's useful**: Copy specific columns from formatted output, select parts of ASCII tables, extract specific fields from aligned text output.

#### Use middle mouse button for pasting

**What it does**: On Linux systems, middle mouse button pastes the current text selection.

**Why it's useful**: Quick pasting without keyboard shortcuts, works with text selected anywhere on screen, traditional Unix workflow for text manipulation.

#### Select words and lines quickly

**What it does**: Double-click selects entire words, triple-click selects entire lines.

**Why it's useful**: Faster text selection for common operations, reduces precision required for selecting text, works consistently across most terminal emulators.

### Visual Enhancements

#### Adjust font size dynamically

```bash
Ctrl+Plus     # Increase font size
Ctrl+Minus    # Decrease font size
Ctrl+0        # Reset to default size
```

**What it does**: Changes terminal font size temporarily for better readability or screen sharing.

**Why it's useful**: Adapt to different screen sizes, improve readability for detailed work, make text visible during presentations or screen sharing.

#### Search through terminal output

```bash
Ctrl+Shift+F  # Open search in many terminals
```

**What it does**: Searches through the scrollback buffer to find specific text in previous output.

**Why it's useful**: Find specific information in long command output, locate error messages in verbose logs, quickly navigate to relevant parts of terminal history.

#### Clear screen while preserving history

```bash
Ctrl+L  # Clear visible screen, keep scrollback
```

**What it does**: Clears the visible terminal screen while preserving command history and scrollback buffer.

**Why it's useful**: Clean workspace without losing access to previous output, faster than typing `clear`, maintains context while reducing visual clutter.

#### Set custom window titles

```bash
echo -ne "\033]0;Your Custom Title\007"
```

**What it does**: Changes the terminal window title to help identify different terminal sessions.

**Why it's useful**: Organize multiple terminal windows, identify different projects or tasks, maintain context when switching between windows.

### Advanced Features

#### Enable true color support

```bash
# Test true color support
printf '\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n'
```

**What it does**: Tests and enables 24-bit color support for richer color display in compatible terminals.

**Why it's useful**: Better syntax highlighting, more attractive terminal themes, improved visual distinction in colorized output.

#### Record terminal sessions

```bash
script session.log    # Start recording
# ... work in terminal ...
exit                 # Stop recording
```

**What it does**: Records all terminal input and output to a file for later review or sharing.

**Why it's useful**: Document complex procedures, share debugging sessions with colleagues, create tutorials or demonstrations.

**Learn more**: `man script`

#### Position cursor with Alt+click

**What it does**: In many terminals, Alt+click moves the cursor to the clicked position in the current command line.

**Why it's useful**: Quick cursor positioning without arrow keys, faster editing of long commands, useful when working with mouse alongside keyboard.

#### Enable GPU acceleration

**What it does**: Uses graphics card acceleration for smoother scrolling and rendering, especially beneficial on high-DPI displays.

**Why it's useful**: Improved performance with large amounts of text, smoother scrolling through long output, better experience on high-resolution monitors.

**Note**: Available in terminal preferences/settings in modern terminal emulators.

#### Handle emoji and Unicode natively

**What it does**: Modern terminals display emoji and Unicode characters correctly without special configuration.

**Why it's useful**: Proper display of international text, use emoji in terminal output for better visual communication, support for diverse character sets in file names and content.

#### Save terminal output permanently

**What it does**: Some terminals provide built-in logging to save all output to files automatically.

**Why it's useful**: Permanent record of all terminal activity, helpful for debugging long-running processes, maintain history across terminal sessions.

**Note**: Available in terminal emulator settings, different from shell history which only saves commands.

---

## Tmux Terminal Multiplexing

**What it covers**: Terminal multiplexing with tmux for session management, window splitting, and remote work.

**When to use**: Remote development, long-running processes, and complex terminal workflows.

### Window and Pane Operations

#### Split terminal horizontally and vertically

```bash
Ctrl+b %    # Split horizontally (left/right panes)
Ctrl+b "    # Split vertically (top/bottom panes)
```

**What it does**: Divides the current tmux window into multiple panes for parallel work.

**Why it's useful**: Work on multiple tasks simultaneously in one window, compare files side-by-side, monitor logs while developing.

**Learn more**: [Tmux Manual](https://man.openbsd.org/tmux.1)

#### Navigate between panes efficiently

```bash
Ctrl+b + arrow keys    # Move between panes
Ctrl+b o              # Cycle through panes
Ctrl+b q              # Show pane numbers, press number to jump
```

**What it does**: Provides quick navigation between different panes in a tmux window.

**Why it's useful**: Essential for multi-pane workflows, faster than using mouse, maintains keyboard-focused development flow.

#### Resize panes dynamically

```bash
# Hold Ctrl+b then use arrow keys to resize
Ctrl+b : resize-pane -L 10    # Resize left 10 columns
Ctrl+b : resize-pane -R 5     # Resize right 5 columns
```

**What it does**: Adjusts pane sizes to optimize screen real estate for different tasks.

**Why it's useful**: Allocate more space to active work areas, accommodate different content types (logs vs code), adapt to changing workflow needs.

#### Zoom panes to full screen

```bash
Ctrl+b z    # Toggle zoom for current pane
```

**What it does**: Temporarily expands the current pane to fill the entire window, toggle to return to multi-pane view.

**Why it's useful**: Focus on detailed work without distraction, then quickly return to multi-pane context. Perfect for editing or reading long output.

### Window Management

#### Create and switch between windows

```bash
Ctrl+b c        # Create new window
Ctrl+b 0-9      # Switch to window by number
Ctrl+b n        # Next window
Ctrl+b p        # Previous window
```

**What it does**: Manages multiple windows within a tmux session, each containing its own set of panes.

**Why it's useful**: Organize different projects or task types in separate windows, maintain multiple contexts simultaneously.

#### Rename windows for organization

```bash
Ctrl+b ,        # Rename current window
Ctrl+b $        # Rename current session
```

**What it does**: Assigns meaningful names to windows and sessions for better organization.

**Why it's useful**: Quickly identify different work contexts, easier navigation in complex setups, better organization for team environments.

#### Break and join panes

```bash
Ctrl+b !                    # Break current pane into new window
Ctrl+b : join-pane -s 2:1   # Join pane 1 from window 2 to current window
```

**What it does**: Moves panes between windows or creates new windows from existing panes.

**Why it's useful**: Reorganize workspace as needs change, promote important panes to dedicated windows, merge related work contexts.

### Session Management

#### Detach and reattach sessions

```bash
Ctrl+b d           # Detach from session
tmux attach        # Reattach to last session
tmux attach -t session_name  # Attach to specific session
```

**What it does**: Disconnects from tmux session while keeping it running, allows reconnection later.

**Why it's useful**: Essential for remote work - sessions survive SSH disconnections, continue long-running processes, maintain work state across connection interruptions.

#### List and manage sessions

```bash
tmux ls                    # List all sessions
tmux new -s project_name   # Create named session
tmux kill-session -t name  # Kill specific session
```

**What it does**: Shows all active tmux sessions and provides commands to create and manage them.

**Why it's useful**: Organize multiple projects in separate sessions, clean up unused sessions, maintain organized development environment.

### Copy Mode and Navigation

#### Enter copy mode for scrolling

```bash
Ctrl+b [        # Enter copy mode
q              # Exit copy mode
Ctrl+b PageUp  # Enter copy mode and scroll up
```

**What it does**: Allows scrolling through terminal history and copying text using keyboard.

**Why it's useful**: Review previous output without mouse, copy terminal content, navigate long command outputs or logs.

#### Search in copy mode

```bash
# In copy mode:
Ctrl+s    # Search forward
Ctrl+r    # Search backward
n         # Next match
N         # Previous match
```

**What it does**: Finds specific text in the terminal scrollback buffer.

**Why it's useful**: Quickly locate error messages, find specific commands in history, navigate through large amounts of output.

### Advanced Features

#### Synchronize input across panes

```bash
Ctrl+b : setw synchronize-panes    # Toggle synchronized input
```

**What it does**: Sends the same input to all panes in the current window simultaneously.

**Why it's useful**: Execute same commands on multiple servers, configure multiple environments simultaneously, parallel system administration tasks.

#### Save and restore sessions

```bash
# Using tmux-resurrect plugin
Ctrl+b Ctrl+s    # Save session
Ctrl+b Ctrl+r    # Restore session
```

**What it does**: Preserves tmux session layout and running programs across system restarts.

**Why it's useful**: Maintain complex workspace setups, recover from system crashes, share session configurations with team members.

**Note**: Requires tmux-resurrect or tmux-continuum plugin installation.

#### Share sessions with other users

```bash
tmux new -s shared    # Create shared session
# Other users can attach to same session
tmux attach -t shared
```

**What it does**: Allows multiple users to connect to the same tmux session for collaboration.

**Why it's useful**: Pair programming, debugging sessions with colleagues, training and mentoring, collaborative system administration.

---

## SSH and Remote Access

**What it covers**: Connect to other computers safely. Control remote servers. Transfer files securely.

**When to use**: Work on servers. Access computers from far away. Keep your data safe while connecting.

### Connection Management

#### Create a config file for easy connections

```bash
# Create SSH config file
touch ~/.ssh/config
chmod 600 ~/.ssh/config
```

**What it does**: You create a file that remembers connection details. You don't type server addresses every time.

**Why it's useful**: You save time. You avoid typing mistakes. You can give servers simple names.

**Example config**:
```
Host myserver
    HostName 192.168.1.100
    User developer
    Port 22
```

**Learn more**: `man ssh_config`

#### Keep connections alive automatically

```bash
# Add to ~/.ssh/config:
ServerAliveInterval 60
```

**What it does**: Your computer sends small messages to the server every 60 seconds. This keeps your connection open.

**Why it's useful**: Your connection doesn't break when you stop typing. You stay connected during long tasks.

#### Forward your SSH keys to remote servers

```bash
ssh -A username@server
```

**What it does**: Your SSH keys work on the remote server. You can connect to other servers from there.

**Why it's useful**: You use your keys everywhere. You don't copy private keys to servers. This is safer.

#### Compress data for slow connections

```bash
ssh -C username@server
```

**What it does**: SSH makes your data smaller before sending it. This uses less network.

**Why it's useful**: Faster connections on slow internet. Less data used on mobile networks.

### Port Forwarding and Tunneling

#### Forward a port from remote server

```bash
ssh -L 8080:localhost:80 server
```

**What it does**: You access port 80 on the server by visiting localhost:8080 on your computer.

**Why it's useful**: Access web apps on remote servers. Use services that only run on the server.

**Example**: View a web app running on your server from your local browser.

#### Create reverse tunnels

```bash
ssh -R 9000:localhost:3000 server
```

**What it does**: People can access your local port 3000 by visiting port 9000 on the server.

**Why it's useful**: Share local development with others. Test webhooks that need public access.

#### Create a SOCKS proxy

```bash
ssh -D 8080 server
```

**What it does**: Your computer uses the server as a proxy. Your internet traffic goes through the server.

**Why it's useful**: Browse the internet as if you are at the server location. Access blocked websites.

#### Run tunnels in background

```bash
ssh -fNL 8080:localhost:80 server
```

**What it does**: SSH runs in background. You can use your terminal for other work.

**Why it's useful**: Keep tunnels open while doing other tasks. No need for extra terminal windows.

### Key Management

#### Copy your public key to server

```bash
ssh-copy-id user@server
```

**What it does**: Your public key gets added to the server. You can log in without typing passwords.

**Why it's useful**: No more passwords needed. Safer than password login. Faster to connect.

**Learn more**: [SSH Key Authentication](https://www.ssh.com/academy/ssh/public-key-authentication)

#### Use jump hosts for complex networks

```bash
ssh -J bastion user@target
# Or in config:
# ProxyJump bastion
```

**What it does**: You connect through one server to reach another server. Like using a bridge.

**Why it's useful**: Reach servers that are not directly accessible. Common in company networks.

### Advanced Features

#### Run commands without staying connected

```bash
ssh server "ls -la"
ssh server "cd /var/logs && tail error.log"
```

**What it does**: SSH runs the command and shows you the result. Then it disconnects.

**Why it's useful**: Quick tasks without opening a full session. Good for scripts and automation.

#### Disconnect from stuck sessions

```bash
# Type: ~.
# (tilde followed by period)
```

**What it does**: Forces SSH to disconnect when your session stops responding.

**Why it's useful**: Get out of frozen connections. Works when Ctrl+C doesn't help.

#### Enable X11 forwarding for GUI apps

```bash
ssh -X user@server
# Then run GUI applications
firefox &
```

**What it does**: You can run programs with windows on the remote server. The windows show on your screen.

**Why it's useful**: Use graphical programs on remote servers. Edit files with visual editors.

#### Debug connection problems

```bash
ssh -vvv user@server
```

**What it does**: SSH shows you detailed information about what it is doing. You see where problems happen.

**Why it's useful**: Find out why connections fail. Understand what SSH is trying to do.

#### Share connections to save time

```bash
# Add to ~/.ssh/config:
ControlMaster auto
ControlPath ~/.ssh/control-%r@%h:%p
```

**What it does**: Multiple SSH connections to the same server share one network connection.

**Why it's useful**: Second and third connections start faster. Uses less network resources.

#### Generate strong SSH keys

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
# For older systems:
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
```

**What it does**: Creates a new SSH key pair that is very secure.

**Why it's useful**: Better security than passwords. Works with modern security standards.

**Learn more**: [SSH Key Types](https://goteleport.com/blog/comparing-ssh-keys/)

---

## Modern CLI Tools

**What it covers**: New command-line programs that work better than old ones. They are faster and easier to use.

**When to use**: Replace old commands with better ones. Make your work faster and more enjoyable.

### Search and Find Tools

#### Use fzf for fuzzy searching

```bash
# Install fzf first, then:
Ctrl+R    # Search command history with fzf
```

**What it does**: You type part of what you want. It finds matches even with spelling mistakes.

**Why it's useful**: Find files and commands quickly. You don't need to remember exact names.

**Example**: Type "conf" and find "configuration.txt" and "nginx.conf".

**Learn more**: [fzf GitHub](https://github.com/junegunn/fzf)

#### Use ripgrep instead of grep

```bash
rg "error"           # Search for "error" in all files
rg "TODO" --type js  # Search only in JavaScript files
```

**What it does**: Searches text in files much faster than the old `grep` command. It skips files you don't want automatically.

**Why it's useful**: Much faster searches. Understands git files. Shows results in nice colors.

**Install**: Most systems: `apt install ripgrep` or `brew install ripgrep`

#### Use fd instead of find

```bash
fd config           # Find files with "config" in name
fd -e txt          # Find all .txt files
fd -t f -t l       # Find files and links only
```

**What it does**: Finds files and folders faster than the old `find` command. Easier to use too.

**Why it's useful**: Simple commands for common searches. Faster results. Ignores hidden files automatically.

**Install**: `apt install fd-find` or `brew install fd`

### Text Processing and Display

#### Use bat instead of cat

```bash
bat file.py         # Show file with syntax colors
bat file.log        # Show with line numbers
```

**What it does**: Shows file contents with pretty colors and line numbers. Like `cat` but better.

**Why it's useful**: Easier to read code files. Shows line numbers. Works with git to highlight changes.

**Install**: `apt install bat` or `brew install bat`

#### Use exa instead of ls

```bash
exa -la            # List files with details
exa --tree         # Show folders as tree
exa --git          # Show git status
```

**What it does**: Lists files and folders with better colors and information than `ls`.

**Why it's useful**: Prettier output. Shows git information. Better file type icons.

**Install**: `apt install exa` or `brew install exa`

#### Use jq for JSON data

```bash
curl api.example.com | jq '.'          # Pretty print JSON
curl api.example.com | jq '.name'      # Get just the name field
```

**What it does**: Reads and formats JSON data (structured text format used by websites).

**Why it's useful**: Makes JSON easy to read. Extract specific information from web APIs.

**Install**: `apt install jq` or `brew install jq`

**Learn more**: [jq Tutorial](https://jqlang.github.io/jq/tutorial/)

### System Monitoring

#### Use htop or btop instead of top

```bash
htop               # Better process viewer
btop               # Even more modern process viewer
```

**What it does**: Shows running programs with better display than old `top` command. You can control programs with mouse and keyboard.

**Why it's useful**: Easier to read. You can kill programs by clicking. Shows memory and CPU usage clearly.

**Install**: `apt install htop btop` or `brew install htop btop`

#### Use ncdu for disk usage

```bash
ncdu /home         # Check disk usage in /home
ncdu .             # Check current folder
```

**What it does**: Shows which files and folders use the most disk space. Interactive display you can navigate.

**Why it's useful**: Find large files quickly. Clean up disk space efficiently. Easy to navigate folders.

**Install**: `apt install ncdu` or `brew install ncdu`

#### Use tldr for simple help

```bash
tldr grep          # Simple examples for grep
tldr ssh           # Simple examples for ssh
```

**What it does**: Shows simple examples of how to use commands. Easier than reading long manual pages.

**Why it's useful**: Quick help with practical examples. No complex technical language.

**Install**: `apt install tldr` or `npm install -g tldr`

### Development Tools

#### Use httpie for API testing

```bash
http GET example.com           # Simple GET request
http POST api.com/users name=John   # Send data to API
```

**What it does**: Makes web requests to APIs. Easier than `curl`. Shows results in pretty format.

**Why it's useful**: Test web services easily. Readable commands. Pretty JSON output.

**Install**: `apt install httpie` or `brew install httpie`

#### Use delta for better git diffs

```bash
# Set up in git config:
git config --global core.pager delta
```

**What it does**: Shows git changes with better colors and formatting than default git.

**Why it's useful**: Easier to see what changed in your code. Better colors help you understand diffs.

**Install**: `apt install git-delta` or `brew install git-delta`

#### Use zoxide as smart cd

```bash
# After installation and setup:
z project          # Jump to any folder containing "project"
z work docs        # Jump to folder matching both "work" and "docs"
```

**What it does**: Jumps to folders you visit often. Learns your habits like PathWise does.

**Why it's useful**: No need to type full folder paths. Gets smarter as you use it.

**Install**: `apt install zoxide` or `brew install zoxide`

#### Use direnv for project environments

```bash
# Create .envrc file in project:
echo "export API_KEY=secret" > .envrc
direnv allow
```

**What it does**: Automatically sets environment variables when you enter a folder. Unsets them when you leave.

**Why it's useful**: Each project has its own settings. No need to remember to set variables.

**Install**: `apt install direnv` or `brew install direnv`

#### Use entr to run commands on file changes

```bash
ls *.py | entr -c python main.py     # Run Python when .py files change
ls *.js | entr -c npm test           # Run tests when JavaScript files change
```

**What it does**: Watches files and runs commands when they change. Good for development.

**Why it's useful**: Automatic testing. See results immediately when you save files.

**Install**: `apt install entr` or `brew install entr`

---

## Docker Containers

**What it covers**: Docker lets you package programs with everything they need to run. Like shipping boxes for software.

**When to use**: Run programs the same way on any computer. Keep different projects separate.

### Container Management

#### Clean up unused Docker data

```bash
docker system prune -a    # Remove all unused containers, images, networks
docker system prune       # Remove only unused data (keep tagged images)
```

**What it does**: Deletes old containers and images you don't use anymore. Frees up disk space.

**Why it's useful**: Docker uses lots of disk space over time. This cleans it up safely.

**Warning**: This removes unused images. Make sure you don't need them.

#### Watch container logs in real time

```bash
docker logs -f container_name     # Follow logs (like tail -f)
docker logs --tail 50 container_name  # Show last 50 lines
```

**What it does**: Shows messages from running containers. You see what the program is doing.

**Why it's useful**: Debug problems in containers. Watch applications start up. See error messages.

#### Get inside a running container

```bash
docker exec -it container_name bash    # Open bash shell inside container
docker exec -it container_name sh      # Use sh if bash not available
```

**What it does**: Opens a terminal inside the running container. You can run commands there.

**Why it's useful**: Debug problems from inside. Check files. Install temporary tools.

#### Copy files to and from containers

```bash
docker cp file.txt container_name:/app/    # Copy file to container
docker cp container_name:/app/log.txt .    # Copy file from container
```

**What it does**: Moves files between your computer and containers.

**Why it's useful**: Get log files out of containers. Put config files into containers.

#### Stop all running containers

```bash
docker stop $(docker ps -q)    # Stop all running containers
docker kill $(docker ps -q)    # Force stop all containers
```

**What it does**: Stops all containers at once instead of one by one.

**Why it's useful**: Quick cleanup when you have many containers running. Emergency stop for all containers.

### Image Operations

#### Build images without using cache

```bash
docker build --no-cache .         # Build fresh without using cached layers
docker build --no-cache -t myapp . # Build and tag the image
```

**What it does**: Builds a new container image from scratch. Doesn't use old cached parts.

**Why it's useful**: Make sure you get latest updates. Fix problems caused by old cached data.

#### Remove old unused images

```bash
docker image prune           # Remove unused images
docker image prune -a        # Remove all unused images (including tagged ones)
```

**What it does**: Deletes container images you don't use anymore.

**Why it's useful**: Container images use lots of disk space. This frees space safely.

#### Show container resource usage

```bash
docker stats                    # Live view of container resources
docker stats container_name     # Stats for specific container
```

**What it does**: Shows how much CPU, memory, and network each container uses.

**Why it's useful**: Find containers that use too many resources. Monitor performance.

### Development Workflows

#### List containers with custom format

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**What it does**: Shows container information in a custom table format that's easier to read.

**Why it's useful**: See only the information you need. Make output cleaner and more readable.

#### Use multi-stage builds for smaller images

```dockerfile
# In Dockerfile:
FROM node:16 AS builder
# Build steps here...

FROM node:16-alpine AS runtime  
# Runtime steps here...
```

**What it does**: Uses multiple steps to build container images. Final image is smaller.

**Why it's useful**: Smaller images download faster. Use less disk space. More secure with fewer tools.

#### Add health checks to containers

```dockerfile
# In Dockerfile:
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/health || exit 1
```

**What it does**: Docker checks if your application is working correctly inside the container.

**Why it's useful**: Automatically restart broken containers. Know when applications have problems.

#### Use .dockerignore file

```bash
# Create .dockerignore file:
echo "node_modules/" > .dockerignore
echo "*.log" >> .dockerignore
```

**What it does**: Tells Docker to ignore certain files when building images. Like .gitignore for Docker.

**Why it's useful**: Faster builds. Smaller images. Don't include sensitive files in images.

### Debugging and Troubleshooting

#### Create temporary containers for debugging

```bash
docker run --rm -it alpine sh              # Temporary Alpine Linux container
docker run --rm -it ubuntu bash            # Temporary Ubuntu container
```

**What it does**: Creates a temporary container that gets deleted when you exit.

**Why it's useful**: Test commands quickly. Debug networking problems. Try different Linux distributions.

#### Backup container volumes

```bash
docker run --rm -v volume_name:/data -v $(pwd):/backup busybox \
  tar czf /backup/backup.tar.gz /data
```

**What it does**: Creates a backup file of all data in a Docker volume.

**Why it's useful**: Save important data before making changes. Move data between systems.

#### Use network debugging tools

```bash
docker run --rm -it nicolaka/netshoot    # Container with network debugging tools
# Inside container: ping, traceroute, nslookup, etc.
```

**What it does**: Runs a container with many network debugging tools already installed.

**Why it's useful**: Debug network problems between containers. Test connectivity without installing tools.

#### Order Dockerfile commands efficiently

```dockerfile
# Put things that change less often first:
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .    # Put changing files last
```

**What it does**: Arranges Dockerfile steps so Docker can reuse cached parts when only some things change.

**Why it's useful**: Much faster builds when you change your code. Docker skips steps that haven't changed.

---

## Performance Monitoring

**What it covers**: Watch how your computer uses its resources. Find programs that slow things down.

**When to use**: Computer runs slowly. Find what uses too much memory or CPU. Check if programs work correctly.

### System Resources

#### Use htop to see all running programs

```bash
htop                    # Better version of 'top' command
# Press F5 for tree view, F6 to sort by different columns
```

**What it does**: Shows all running programs with CPU and memory usage. You can control programs with keyboard.

**Why it's useful**: See what slows down your computer. Kill programs that use too much memory. Easy to read display.

**How to use**: Press F9 to kill a program, F6 to sort by CPU or memory usage.

#### Check detailed disk input/output

```bash
iostat -x 1             # Show disk activity every 1 second
iotop                   # Shows which programs read/write to disk (needs sudo)
```

**What it does**: Shows which programs read and write files to disk. Updates every second.

**Why it's useful**: Find programs that make your disk work hard. See if disk is causing slowness.

**Note**: `iotop` needs administrator rights (sudo) to show process names.

#### Show network usage per program

```bash
sudo nethogs            # Shows bandwidth usage for each program
```

**What it does**: Shows which programs use your internet connection and how much.

**Why it's useful**: Find programs that use lots of bandwidth. See if something downloads without permission.

**Install**: `apt install nethogs` or `brew install nethogs`

#### Use ss instead of old netstat

```bash
ss -tulpn              # Show listening ports (what programs accept connections)
ss -tuln               # Show only listening ports without process names
```

**What it does**: Shows which programs listen for network connections. Modern replacement for `netstat`.

**Why it's useful**: See what services run on your computer. Find open ports. Check network security.

**Learn more**: `man ss`

### Process Monitoring

#### Watch CPU usage in real time

```bash
perf top               # Shows real-time CPU usage by function (needs root)
```

**What it does**: Shows which parts of programs use the most CPU time right now.

**Why it's useful**: Find performance problems in programs. See exactly what takes CPU time.

**Note**: Needs administrator rights. Very detailed technical information.

#### Trace system calls made by programs

```bash
strace -c command      # Count system calls made by command
strace -p PID          # Watch system calls from running program
```

**What it does**: Shows what a program asks the system to do (open files, connect to network, etc).

**Why it's useful**: Understand why programs run slowly. See what files programs try to access.

**Example**: `strace -c ls` shows what system calls the `ls` command makes.

#### Find which program uses a specific port

```bash
lsof -i :8080          # Find what uses port 8080
lsof -i TCP:22         # Find what uses TCP port 22 (usually SSH)
```

**What it does**: Shows which program uses a specific network port.

**Why it's useful**: Find conflicts when programs can't start. See what listens on ports.

**Install**: Usually pre-installed on most systems.

### System Activity Reports

#### Generate system activity reports

```bash
sar -u 1 5             # Show CPU usage 5 times, 1 second apart
sar -r 1 5             # Show memory usage over time
```

**What it does**: Creates reports about system performance over time periods.

**Why it's useful**: See performance patterns. Find when system gets busy. Create performance reports.

**Install**: Part of `sysstat` package: `apt install sysstat`

#### Monitor virtual memory statistics

```bash
vmstat 1               # Show memory stats every 1 second
vmstat 1 10            # Show stats 10 times then stop
```

**What it does**: Shows memory, swap, and CPU statistics. Updates regularly.

**Why it's useful**: Monitor memory usage patterns. See if system swaps too much. Check system load.

#### Use versatile system statistics

```bash
dstat                  # Shows CPU, disk, network, memory stats together
dstat -cdn             # Show CPU, disk, and network only
```

**What it does**: Shows many different system stats in one place. Replaces several older tools.

**Why it's useful**: See complete system picture at once. Easier than running multiple commands.

**Install**: `apt install dstat` (may not be available on all systems)

### Advanced Monitoring

#### Comprehensive system monitor

```bash
glances               # Shows lots of system info in one screen
glances -w            # Start web interface (view in browser)
```

**What it does**: Shows CPU, memory, disk, network, and process information together. Can run a web interface.

**Why it's useful**: Complete system overview. Pretty display. Access from web browser.

**Install**: `apt install glances` or `pip install glances`

#### Monitor memory usage per process

```bash
pidstat -r 1           # Show memory usage per process every 1 second
pidstat -r -p PID 1    # Monitor specific process memory
```

**What it does**: Shows memory usage for each running program over time.

**Why it's useful**: Find memory leaks in programs. Track how much memory programs use.

**Install**: Part of `sysstat` package.

#### Capture network packets

```bash
sudo tcpdump -i any port 80        # Capture web traffic
sudo tcpdump -n -i eth0            # Capture all traffic on eth0 interface
```

**What it does**: Records network packets going in and out of your computer.

**Why it's useful**: Debug network problems. See what programs send over network. Security analysis.

**Warning**: Captures all network traffic. Be careful with sensitive data.

#### Benchmark command performance

```bash
time command           # Shows how long command takes to run
time ls -la           # Time how long 'ls -la' takes
```

**What it does**: Measures how long commands take to complete. Shows real time, CPU time.

**Why it's useful**: Compare performance of different approaches. Find slow commands. Optimize scripts.

**Built-in**: Available on all Unix-like systems.

---

## Text Editors

**What it covers**: Edit text and code files efficiently. Choose the right editor for your skill level and needs.

**When to use**: Write code. Edit config files. Work with any text files on servers or local computers.

### Vim Power User Tips

#### Change text inside brackets quickly

```bash
# In Vim:
ci(    # Change text inside parentheses ()
ci{    # Change text inside braces {}
ci[    # Change text inside brackets []
ci"    # Change text inside quotes ""
```

**What it does**: Deletes text inside brackets/quotes and puts you in insert mode to type new text.

**Why it's useful**: Edit function parameters quickly. Change quoted strings fast. Work with code structures efficiently.

**Example**: On `function(old_parameter)`, type `ci(` then `new_parameter`.

#### Repeat your last change easily

```bash
# In Vim:
.      # Repeat the last change you made
```

**What it does**: Does the same edit you just made at the cursor position.

**Why it's useful**: Make the same change in many places without retyping. Very powerful for repetitive edits.

**Example**: Delete a word with `dw`, then move cursor and press `.` to delete another word.

#### Auto-indent entire file

```bash
# In Vim:
gg=G   # Go to top, then auto-indent everything to bottom
```

**What it does**: Fixes indentation for the entire file automatically based on the code language.

**Why it's useful**: Clean up messy code formatting. Fix indentation after copying code.

#### Edit multiple lines at once

```bash
# In Vim:
Ctrl+v      # Enter visual block mode
# Select lines, then I to insert at start, A to append at end
```

**What it does**: Select rectangular blocks of text. Make changes to multiple lines simultaneously.

**Why it's useful**: Add comments to many lines. Edit similar code patterns quickly.

#### Open file under cursor

```bash
# In Vim:
gf         # Go to file under cursor
Ctrl+o     # Go back to previous file
```

**What it does**: Opens the file whose name is under your cursor. Returns to previous file with Ctrl+o.

**Why it's useful**: Navigate between related files quickly. Follow import statements or includes.

#### Save file with sudo when you forgot

```bash
# In Vim:
:w !sudo tee %
```

**What it does**: Saves the current file using sudo privileges even if you opened it without sudo.

**Why it's useful**: Save system files you forgot to open with sudo. Avoid losing your changes.

#### Record and replay actions

```bash
# In Vim:
qa         # Start recording macro into register 'a'
# ... do some actions ...
q          # Stop recording
@a         # Replay the macro
```

**What it does**: Records a sequence of actions you can replay multiple times.

**Why it's useful**: Automate repetitive editing tasks. Apply complex changes to many similar places.

#### Set paste mode to preserve formatting

```bash
# In Vim:
:set paste    # Turn on paste mode
# Paste your text (Ctrl+V or right-click)
:set nopaste  # Turn off paste mode
```

**What it does**: Prevents Vim from changing indentation when you paste code from other programs.

**Why it's useful**: Keep code formatting when pasting. Avoid broken indentation from clipboard.

### Nano Efficiency

#### Copy and paste lines easily

```bash
# In Nano:
Alt+6      # Copy current line
Ctrl+K     # Cut current line  
Ctrl+U     # Paste (uncut) line
```

**What it does**: Simple copy, cut, and paste operations for entire lines.

**Why it's useful**: Move lines around. Duplicate lines. Standard editing operations made simple.

#### Search and replace text

```bash
# In Nano:
Ctrl+W     # Search for text
Alt+W      # Search for same text again (find next)
Ctrl+\     # Search and replace
```

**What it does**: Find text in the file. Replace text with different text.

**Why it's useful**: Find specific code or configuration. Change variable names throughout file.

#### Select text for copying

```bash
# In Nano:
Alt+A      # Start selection (mark text)
# Move cursor to select text
Alt+6      # Copy selected text
Ctrl+U     # Paste copied text
```

**What it does**: Lets you select specific text (not just whole lines) for copying.

**Why it's useful**: Copy parts of lines. Select exactly what you need.

#### Go to specific line number

```bash
# In Nano:
Ctrl+_     # Go to line (asks for line number)
```

**What it does**: Jumps directly to any line number in the file.

**Why it's useful**: Navigate to error locations. Jump to specific parts of long files.

#### Enable/disable line wrapping

```bash
# In Nano:
Alt+N      # Toggle line wrapping on/off
```

**What it does**: Controls whether long lines wrap to the next line or scroll horizontally.

**Why it's useful**: See long code lines properly. Choose display style that works for your content.

#### Check spelling in your text

```bash
# In Nano:
Ctrl+T     # Run spell checker (if available)
```

**What it does**: Checks for spelling mistakes in your text and suggests corrections.

**Why it's useful**: Write better documentation. Check comments in code files.

**Note**: Requires spell checker to be installed on your system.

### Modern Alternatives

#### Try Micro - modern nano alternative

```bash
micro filename.txt    # Open file in micro editor
```

**What it does**: Modern text editor that works like nano but with mouse support and familiar shortcuts.

**Why it's useful**: Easy for beginners who are used to graphical editors. Mouse support in terminal. Familiar Ctrl+C, Ctrl+V shortcuts.

**Features**:
- Mouse support (click to position cursor)
- Standard shortcuts (Ctrl+S to save, Ctrl+C to copy)
- Multiple cursors
- Syntax highlighting

**Install**: Download from [micro-editor.github.io](https://micro-editor.github.io/) or `apt install micro`

#### Use modern terminal editors

**What they offer**: Features from graphical editors in terminal:
- **Helix**: Modal editing like Vim but more user-friendly
- **Kakoune**: Unique selection-based editing approach
- **Xi**: Fast editor with modern features

**Why try them**: Get power of advanced editors without steep learning curve. Modern features like multiple cursors and better defaults.

**When to use**: You want power editing but find Vim too complex. You work mostly in terminal but want modern features.

---

## Security and Permissions

**What it covers**: Security best practices, permission management, and system protection techniques.

**When to use**: System administration, security auditing, and protecting sensitive data.

### File Permissions and Access

#### Check file permissions easily

**What it does**: You see who can read, write, or run files. You understand file access rights.

**Why it's useful**: You protect important files. You fix permission problems. You secure your system.

**Command**: `ls -la` or `stat filename`

**Example output**: 
```
-rw-r--r-- 1 user group 1024 Jan 1 12:00 document.txt
drwxr-xr-x 2 user group 4096 Jan 1 12:00 folder
```

**What the letters mean**:
- First letter: `-` for file, `d` for directory
- Next 9 letters: Owner permissions, group permissions, others permissions
- `r` = read, `w` = write, `x` = execute

#### Secure your SSH keys

**What it does**: You set correct permissions on SSH private keys. Only you can read them.

**Why it's useful**: You protect your login credentials. You prevent unauthorized access to servers.

**Command**: `chmod 600 ~/.ssh/id_rsa`

**What happens**: Only file owner can read and write the key. No one else can access it.

**Important**: Private keys with wrong permissions are security risks. SSH may refuse to use them.

#### Find programs with special privileges

**What it does**: You locate programs that run with administrator rights. You check for security risks.

**Why it's useful**: These programs can be security vulnerabilities. You audit your system for potential risks.

**Command**: `find / -perm -4000 2>/dev/null`

**What it shows**: Programs with SUID bit set. These run as their owner regardless of who starts them.

**Security note**: Review these programs regularly. Remove unnecessary SUID programs.

#### Set secure default permissions

**What it does**: You control default permissions for new files and directories.

**Why it's useful**: New files get secure permissions automatically. You don't forget to secure files.

**Command**: `umask 077` (very secure) or `umask 022` (standard)

**What it means**:
- `077`: Only you can read/write new files
- `022`: You can read/write, others can only read

**Where to set**: Add to your shell configuration file (.bashrc, .zshrc)

### Encryption and Security

#### Encrypt files with GPG

**What it does**: You encrypt files so only intended recipients can read them.

**Why it's useful**: You protect sensitive documents. You send private information safely.

**For yourself**: `gpg -c filename` (asks for password)
**For others**: `gpg -e -r recipient@email.com filename`

**Result**: Creates filename.gpg that requires password or private key to decrypt.

**Decrypt**: `gpg filename.gpg` (asks for password)

#### Generate secure passwords

**What it does**: You create strong, random passwords that are hard to guess.

**Why it's useful**: Strong passwords protect your accounts. Random passwords are more secure than personal ones.

**Methods**:
- `openssl rand -base64 32` (creates 32-character password)
- `pwgen -sy 16` (creates readable 16-character password with symbols)

**Tips**: Use different passwords for different accounts. Store in password manager.

#### Verify file integrity

**What it does**: You check if files have been changed or corrupted. You detect tampering.

**Why it's useful**: You verify downloads are complete. You detect unauthorized file changes.

**Command**: `sha256sum filename`

**Creates hash**: Long string that changes if file content changes by even one bit.

**To verify**: Compare hash values. Different hashes mean different files.

#### Secure file deletion

**What it does**: You overwrite files multiple times before deletion. You prevent data recovery.

**Why it's useful**: Normal deletion only removes file references. Data can still be recovered by specialists.

**Command**: `shred -vfz -n 3 filename`

**What it does**:
- Overwrites file content 3 times with random data
- Shows progress (`-v`)
- Forces deletion (`-f`)
- Adds final zero overwrite (`-z`)

### System Auditing

#### Check what network ports are open

**What it does**: You see which programs are listening for network connections.

**Why it's useful**: You identify security risks. You find programs you didn't know were running.

**Commands**: 
- `sudo ss -tulpn` (modern, faster)
- `sudo netstat -tulpn` (traditional, widely available)

**What output shows**: Protocol, local address, port number, program name

**Security tip**: Close ports you don't need. Unknown listening programs may be security risks.

#### Monitor system logs

**What it does**: You check system activity and error messages. You investigate security events.

**Why it's useful**: Logs show login attempts, system errors, and security events. You detect problems early.

**Commands**:
- `sudo journalctl -xe` (recent system events)
- `last` (login history)
- `who` (currently logged in users)

**What to look for**: Failed login attempts, unusual activity times, unknown users

#### Check running processes

**What it does**: You see all programs running on your system. You identify suspicious processes.

**Why it's useful**: You spot malware or unwanted programs. You understand system resource usage.

**Command**: `ps aux --forest`

**Shows**: User, CPU usage, memory usage, start time, command. Tree view shows parent-child relationships.

**Security check**: Look for processes you don't recognize. Check processes running as root.

### Network Security

#### Check firewall status

**What it does**: You see if your firewall is active and what rules are in place.

**Why it's useful**: Firewalls block unauthorized network access. You need to know if yours is working.

**Commands**:
- `sudo ufw status verbose` (Ubuntu/Debian with UFW)
- `sudo firewall-cmd --list-all` (RedHat/CentOS with firewalld)
- `sudo iptables -L` (direct iptables rules)

**What to check**: Firewall should be active. Only necessary ports should be open.

#### Harden SSH access

**What it does**: You configure SSH server for better security. You prevent common attacks.

**Why it's useful**: SSH is common attack target. Better configuration reduces risks.

**Key settings in `/etc/ssh/sshd_config`**:
- `PermitRootLogin no` (disable root login)
- `PasswordAuthentication no` (require SSH keys)
- `Port 2222` (use non-standard port)

**Apply changes**: `sudo systemctl restart ssh`

#### Monitor network connections

**What it does**: You see active network connections to and from your computer.

**Why it's useful**: You detect unauthorized connections. You identify network-using programs.

**Command**: `sudo lsof -i -P -n | grep LISTEN`

**Shows**: Programs listening for connections, which ports they use, and their process IDs.

**Security check**: Research unknown listening programs. Close unnecessary network services.

---

## Networking

**What it covers**: Network configuration, debugging, and connectivity tools for system administration and troubleshooting.

**When to use**: Network troubleshooting, connectivity testing, and system administration.

### Connectivity Testing

#### Test if websites are reachable

**What it does**: You check if you can connect to websites or servers. You test internet connectivity.

**Why it's useful**: You diagnose connection problems. You verify servers are working.

**Command**: `ping -c 4 google.com`

**What `-c 4` means**: Send only 4 packets, then stop. Without it, ping runs forever.

**Output shows**: Time to reach server, packet loss percentage. Lower time is better.

**No response**: May mean server blocks ping or network problem exists.

#### Trace path to servers

**What it does**: You see the route your data takes to reach a server. You find where connections slow down.

**Why it's useful**: You locate network bottlenecks. You troubleshoot slow connections.

**Commands**:
- `traceroute google.com` (standard tool)
- `mtr google.com` (interactive, real-time updates)

**What it shows**: Each router your data passes through. Time to reach each step.

**Use MTR**: Shows continuous updates. Press `q` to quit. Better for ongoing monitoring.

#### Check if specific ports are open

**What it does**: You test if a server accepts connections on specific ports. You verify services are running.

**Why it's useful**: You confirm web servers, SSH, or other services work. You troubleshoot connection failures.

**Command**: `nc -zv hostname 22`

**What it means**:
- `nc` = netcat (Swiss Army knife of networking)
- `-z` = Just check connection, don't send data
- `-v` = Verbose output (show results)
- `22` = Port number (SSH in this example)

**Common ports**: 22 (SSH), 80 (HTTP), 443 (HTTPS), 21 (FTP)

#### Look up domain information

**What it does**: You find IP addresses for domain names. You check DNS records.

**Why it's useful**: You troubleshoot website problems. You verify DNS changes.

**Commands**:
- `dig @8.8.8.8 example.com` (detailed DNS information)
- `nslookup example.com` (simple IP lookup)

**What `@8.8.8.8` does**: Uses Google's DNS server instead of default. Helps test if DNS problem is local.

**Record types**: A (IPv4), AAAA (IPv6), MX (email), CNAME (alias)

### Network Configuration

#### View network interfaces

**What it does**: You see all network connections your computer has. You check IP addresses.

**Why it's useful**: You verify network settings. You troubleshoot connectivity issues.

**Commands**:
- `ip a` (modern Linux command)
- `ifconfig` (traditional, works on most systems)

**What you see**: Interface names (eth0, wlan0), IP addresses, network status (UP/DOWN)

**Common interfaces**: `lo` (localhost), `eth0` (ethernet), `wlan0` (WiFi)

#### Check routing table

**What it does**: You see how your computer decides where to send network traffic.

**Why it's useful**: You troubleshoot routing problems. You understand network paths.

**Commands**:
- `ip route` (modern)
- `route -n` (traditional)

**Default route**: Shows gateway (router) for internet traffic. Usually ends in `.1` or `.254`.

**Local routes**: Show networks you can reach directly without router.

#### Manage WiFi connections

**What it does**: You connect to wireless networks from command line. You manage WiFi settings.

**Why it's useful**: You connect to WiFi without graphical interface. You automate network connections.

**List networks**: `nmcli dev wifi`

**Connect**: `nmcli dev wifi connect NETWORK_NAME password YOUR_PASSWORD`

**Show saved connections**: `nmcli con show`

**Disconnect**: `nmcli con down CONNECTION_NAME`

#### View ARP cache

**What it does**: You see which MAC addresses belong to which IP addresses on your local network.

**Why it's useful**: You identify devices on your network. You troubleshoot local network problems.

**Command**: `arp -a`

**What it shows**: IP addresses and MAC addresses of devices your computer recently communicated with.

**MAC addresses**: Unique identifiers for network cards. Look like `12:34:56:78:9a:bc`.

### Traffic Analysis

#### Test internet speed

**What it does**: You measure your internet download speed. You test connection quality.

**Why it's useful**: You verify internet speed matches what you pay for. You troubleshoot slow connections.

**Command**: `curl -o /dev/null http://speedtest.tele2.net/1GB.zip`

**What happens**: Downloads test file, measures speed, throws away data (`/dev/null`).

**Time output**: Use `time` command before curl to see download time.

**Alternative sizes**: Use 100MB.zip for slower connections, 10GB.zip for very fast ones.

#### Download files with resume

**What it does**: You download large files and resume if interrupted. You don't restart from beginning.

**Why it's useful**: You handle unstable connections. You save time on large downloads.

**Commands**:
- `wget -c URL` (wget with continue option)
- `curl -C - -O URL` (curl with resume option)

**What `-c` and `-C -` do**: Continue partial downloads from where they stopped.

**Progress display**: Both tools show download progress and estimated time remaining.

#### Check HTTP headers

**What it does**: You see server information without downloading full content. You check website details.

**Why it's useful**: You debug website problems. You check server types and settings.

**Command**: `curl -I https://example.com`

**What `-I` does**: HEAD request only. Gets headers but no content.

**Headers show**: Server type, content type, caching info, redirects, error codes.

#### Monitor network usage

**What it does**: You track how much data your computer sends and receives over time.

**Why it's useful**: You monitor data usage. You identify programs using lots of bandwidth.

**Command**: `vnstat`

**What it shows**: Daily, weekly, monthly network statistics. Separate stats for each interface.

**First time**: May need to collect data for a while before showing useful statistics.

**Live monitoring**: `vnstat -l` shows real-time usage.

### Remote Access

#### Scan local network

**What it does**: You find all devices connected to your local network. You discover IP addresses in use.

**Why it's useful**: You identify unknown devices. You find servers or devices without known addresses.

**Command**: `nmap -sn 192.168.1.0/24`

**What it means**:
- `-sn` = Ping scan (no port scanning)
- `192.168.1.0/24` = Check all addresses from .1 to .254
- Adjust network range to match your router's settings

**Common ranges**: 192.168.1.x, 192.168.0.x, 10.0.0.x

**Output shows**: Active IP addresses and hostnames if available.

---

## Package Management

**What it covers**: Software installation, dependency management, and package system administration across different platforms.

**When to use**: Software installation, system maintenance, and development environment setup.

### System Package Managers

#### List all installed packages

**What it does**: You see every software package installed on your system. You understand what programs you have.

**Why it's useful**: You audit installed software. You find packages to remove. You document your system setup.

**Commands by system**:
- **Ubuntu/Debian**: `apt list --installed`
- **RedHat/CentOS**: `rpm -qa` or `dnf list installed`
- **Arch**: `pacman -Q`

**Output format**: Package name, version, and sometimes description. Very long list on most systems.

**Filter results**: Use `| grep search_term` to find specific packages.

#### Check available package versions

**What it does**: You see what versions of a package you can install. You check if updates exist.

**Why it's useful**: You choose specific versions. You see update possibilities before installing.

**Command**: `apt-cache policy package_name`

**Output shows**:
- Currently installed version
- Available versions in repositories
- Which repository each version comes from

**Other systems**: Use `dnf info package` or `pacman -Si package`

#### Find manually installed packages

**What it does**: You see packages you installed yourself, not system dependencies.

**Why it's useful**: You identify programs you actually use. You clean up unnecessary software.

**Command**: `apt-mark showmanual`

**What it shows**: Only packages you explicitly installed, not automatic dependencies.

**Use case**: Create minimal system by keeping only manual packages plus their dependencies.

#### View package installation history

**What it does**: You see when packages were installed, updated, or removed. You can undo changes.

**Why it's useful**: You troubleshoot problems after package changes. You undo recent installations.

**Command**: `dnf history` (RedHat/CentOS systems)

**What you can do**: See transaction numbers, dates, and changes. Use `dnf history undo N` to reverse transaction.

**Ubuntu equivalent**: Check `/var/log/apt/history.log` for similar information.

### Language-Specific Managers

#### Create Python virtual environments

**What it does**: You create isolated Python environments for different projects. You avoid version conflicts.

**Why it's useful**: Different projects need different package versions. Virtual environments prevent conflicts.

**Steps**:
1. `python -m venv project_env` (creates environment)
2. `source project_env/bin/activate` (activates it)
3. `pip install packages` (installs only in this environment)
4. `deactivate` (returns to system Python)

**Environment active**: Your prompt shows `(project_env)` when virtual environment is active.

#### Save and restore Python packages

**What it does**: You create a list of installed packages. You recreate the same setup elsewhere.

**Why it's useful**: You share environments with teammates. You set up identical development environments.

**Save packages**: `pip freeze > requirements.txt`

**Install from list**: `pip install -r requirements.txt`

**What requirements.txt contains**: Package names with exact version numbers for reproducible installs.

#### Use npm for JavaScript packages

**What it does**: You manage JavaScript packages and dependencies for web development projects.

**Why it's useful**: Modern web development depends on many packages. npm handles complex dependency trees.

**Key difference**: `npm ci` vs `npm install`
- `npm install`: Updates packages, creates package-lock.json
- `npm ci`: Installs exact versions from existing package-lock.json (faster, reproducible)

**Run without installing**: `npx package_name` runs packages temporarily without global installation.

#### Create package lists for easy reinstall

**What it does**: You save a complete list of your installed software. You recreate your setup on new machines.

**Why it's useful**: You backup your software setup. You set up identical environments quickly.

**Homebrew**: `brew bundle dump` creates Brewfile with all installed packages.

**Restore setup**: `brew bundle install` reads Brewfile and installs everything.

### Alternative Installation Methods

#### Use snap packages

**What it does**: You install software in isolated containers. You get newer versions on older systems.

**Why it's useful**: Software runs anywhere regardless of system libraries. Automatic updates.

**List all snaps**: `snap list --all`

**What `--all` shows**: Includes disabled/old versions, not just active ones.

**Channels**: Install from different update channels (stable, beta, edge) for different release types.

#### Use Flatpak applications

**What it does**: You install desktop applications in sandboxed environments. You get consistent software across Linux distributions.

**Why it's useful**: Applications work the same on different Linux versions. Better security through sandboxing.

**List applications**: `flatpak list --app`

**What `--app` does**: Shows only applications, not runtime libraries and frameworks.

**Runtimes**: Flatpak applications share common runtimes to save space.

#### Build software from source code

**What it does**: You compile programs directly from source code. You get latest versions or custom configurations.

**Why it's useful**: You access newest features. You customize software for your needs.

**Standard process**:
1. `./configure --prefix=$HOME/.local` (configure build)
2. `make` (compile source code)
3. `make install` (install to specified location)

**Install location**: `$HOME/.local` puts software in your home directory, no root access needed.

### Dependency Management

#### Check what libraries a program needs

**What it does**: You see which shared libraries a program requires to run.

**Why it's useful**: You troubleshoot missing library errors. You understand program dependencies.

**Command**: `ldd /path/to/program`

**Output shows**: Library file names and their locations on your system.

**Missing libraries**: Show as "not found" - install appropriate packages to fix.

#### Switch between different versions

**What it does**: You choose which version of a program to use when multiple versions are installed.

**Why it's useful**: Different projects need different Java, Python, or GCC versions.

**Command**: `update-alternatives --config java`

**What happens**: Shows menu of installed Java versions. You select which one becomes default.

**Common uses**: Java versions, text editors, web browsers.

#### See what files a package installed

**What it does**: You list all files that belong to an installed package.

**Why it's useful**: You find configuration files. You understand what a package changed.

**Commands**:
- **Debian/Ubuntu**: `dpkg -L package_name`
- **RedHat/CentOS**: `rpm -ql package_name`

**File types shown**: Executables, configuration files, documentation, libraries.

---

## Bash Programming

**What it covers**: Comprehensive bash scripting techniques, from basic string manipulation to advanced programming concepts.

**When to use**: Writing shell scripts, automating tasks, and advanced command-line operations.

### String Manipulation

**What it covers**: Techniques for processing and manipulating strings in bash without external tools.

**When to use**: Text processing, data cleaning, and string validation in shell scripts.

#### Remove spaces from strings

**What it does**: You clean up text by removing unwanted spaces from the beginning and end.

**Why it's useful**: User input often has extra spaces. Clean data makes scripts more reliable.

**Remove leading spaces**: `${var##*([[:space:]])}`
**Remove trailing spaces**: `${var%%*([[:space:]])}`
**Remove both**: `var=$(echo "$var" | xargs)`

**Simple method**: The `xargs` method works for basic cleanup and is easier to remember.

#### Get string length quickly

**What it does**: You count characters in a string without using external commands.

**Why it's useful**: Faster than using `wc -c`. You can validate input length in scripts.

**Command**: `${#variable_name}`

**Example**:
```bash
name="hello"
echo ${#name}  # outputs: 5
```

**Use in conditions**: `if [ ${#password} -lt 8 ]; then echo "Too short"; fi`

#### Split strings into arrays

**What it does**: You break text into pieces using a separator character. You create arrays from text.

**Why it's useful**: Process PATH variables, CSV data, or any delimited text.

**Method**: `IFS=: read -ra array <<< "$PATH"`

**What this means**:
- `IFS=:` sets colon as separator
- `read -ra array` reads into array
- `<<< "$PATH"` feeds the variable as input

**Access parts**: `echo ${array[0]}` for first part, `${array[@]}` for all parts

#### Change text case

**What it does**: You convert text to uppercase, lowercase, or toggle case.

**Why it's useful**: Normalize user input. Make case-insensitive comparisons.

**Bash 4+ methods**:
- **Lowercase**: `${var,,}`
- **Uppercase**: `${var^^}`
- **Toggle case**: `${var~~}`

**Older systems**: Use `tr '[:lower:]' '[:upper:]'` for uppercase, `tr '[:upper:]' '[:lower:]'` for lowercase

#### Remove all spaces from text

**What it does**: You delete every space character from a string.

**Why it's useful**: Clean phone numbers, remove formatting, create compact identifiers.

**Command**: `${var// /}`

**What it means**: Replace all spaces (` `) with nothing (``)

**Example**:
```bash
phone="555 123 4567"
clean=${phone// /}  # Result: 5551234567
```

#### Check if string contains text

**What it does**: You test if a string contains specific text without using grep.

**Why it's useful**: Faster than external commands. Works in conditional statements.

**Pattern matching**: `[[ $var == *"search_text"* ]]`

**Example**:
```bash
if [[ $filename == *".txt"* ]]; then
    echo "Text file found"
fi
```

**Case insensitive**: Convert both to lowercase first: `[[ ${var,,} == *"${search,,}"* ]]`

#### Check string beginning and ending

**What it does**: You test if strings start or end with specific text.

**Why it's useful**: Validate file extensions, URL protocols, or naming conventions.

**Starts with**: `[[ $var == prefix* ]]`
**Ends with**: `[[ $var == *suffix ]]`

**Examples**:
```bash
# Check if URL starts with https
[[ $url == https* ]] && echo "Secure URL"

# Check if file ends with .log
[[ $file == *.log ]] && echo "Log file"
```

#### Extract parts of strings

**What it does**: You get portions of strings by position or pattern.

**Why it's useful**: Extract filenames, dates, or specific data from formatted text.

**By position**:
- **First N characters**: `${var:0:N}`
- **Last N characters**: `${var: -N}` (note the space before minus)
- **Middle portion**: `${var:start:length}`

**Examples**:
```bash
date="2024-01-15"
year=${date:0:4}      # "2024"
month=${date:5:2}     # "01"
day=${date: -2}       # "15"
```

#### Remove text patterns

**What it does**: You delete text from the beginning or end of strings based on patterns.

**Why it's useful**: Remove file extensions, path prefixes, or unwanted text.

**Remove from start**:
- **Shortest match**: `${var#pattern}`
- **Longest match**: `${var##pattern}`

**Remove from end**:
- **Shortest match**: `${var%pattern}`
- **Longest match**: `${var%%pattern}`

**Examples**:
```bash
filepath="/home/user/document.txt"
filename=${filepath##*/}    # "document.txt"
basename=${filename%.*}     # "document"
extension=${filename##*.}   # "txt"
```

#### Check if string is all numbers

**What it does**: You verify that a string contains only digits.

**Why it's useful**: Validate numeric input before using in calculations.

**Pattern matching**: `[[ $var =~ ^[0-9]+$ ]]`

**What the pattern means**:
- `^` = Start of string
- `[0-9]+` = One or more digits
- `$` = End of string

**Example**:
```bash
if [[ $input =~ ^[0-9]+$ ]]; then
    echo "Valid number"
else
    echo "Contains non-digits"
fi
```

### Array Operations

**What it covers**: Working with bash arrays, including creation, manipulation, and advanced operations.

**When to use**: Processing lists of data, managing collections of items in scripts.

#### Reverse array order

**What it does**: You flip the order of elements in an array from last to first.

**Why it's useful**: Process items in reverse chronological order. Reverse sort order.

**Method**: 
```bash
for ((i=${#arr[@]}-1; i>=0; i--)); do 
    reversed+=("${arr[i]}")
done
```

**What this means**:
- `${#arr[@]}` gets array length
- Start from last index, count down to 0
- Build new array with elements in reverse order

**Simpler for display**: `printf '%s\n' "${arr[@]}" | tac`

#### Remove duplicate values

**What it does**: You create a new array with only unique values from the original.

**Why it's useful**: Clean data sets. Ensure unique identifiers.

**Method using associative array**:
```bash
declare -A seen
for item in "${arr[@]}"; do
    if [[ -z ${seen[$item]} ]]; then
        unique+=("$item")
        seen[$item]=1
    fi
done
```

**What this does**: Uses associative array as a set to track which items you've already seen.

#### Get random array element

**What it does**: You pick a random item from an array.

**Why it's useful**: Random selections, testing with sample data, games.

**Command**: `${arr[RANDOM % ${#arr[@]}]}`

**What it means**:
- `RANDOM` gives random number
- `% ${#arr[@]}` limits it to array size
- Result is valid array index

**Example**:
```bash
colors=("red" "blue" "green" "yellow")
echo "Random color: ${colors[RANDOM % ${#colors[@]}]}"
```

#### Cycle through array endlessly

**What it does**: You loop through array elements, returning to the beginning after the last element.

**Why it's useful**: Round-robin selection, rotating through options, infinite loops.

**Method**: `${arr[i++ % ${#arr[@]}]}`

**What happens**:
- `i++` increments counter after use
- `% ${#arr[@]}` wraps around to 0 after reaching array size
- Works for infinite cycling

**Example**:
```bash
i=0
servers=("web1" "web2" "web3")
# This will cycle: web1, web2, web3, web1, web2, web3, ...
echo "Next server: ${servers[i++ % ${#servers[@]}]}"
```

#### Toggle between two values

**What it does**: You switch between two states repeatedly.

**Why it's useful**: On/off switches, true/false toggles, binary states.

**Simple toggle**: `var=$((1-var))`

**What this does**:
- If `var` is 0, result is 1
- If `var` is 1, result is 0
- Only works for 0/1 values

**Example usage**:
```bash
debug=0
# Toggle debug mode
debug=$((1-debug))
[[ $debug -eq 1 ]] && echo "Debug mode ON" || echo "Debug mode OFF"
```

### Loop Constructs

**What it covers**: Different types of loops in bash for iterating over data, files, and ranges.

**When to use**: Repetitive operations, batch processing, and data iteration.

#### Loop over number ranges

**What it does**: You repeat actions for a series of numbers.

**Why it's useful**: Create numbered files, process ranges, count iterations.

**Simple range**: `for i in {1..10}; do echo $i; done`

**Variable range**: `for ((i=start; i<=end; i++)); do echo $i; done`

**Why two methods**: Brace expansion `{1..10}` is simpler but doesn't work with variables. C-style loop works with variables.

**Step values**: `{1..10..2}` gives odd numbers (1, 3, 5, 7, 9)

#### Loop over array elements

**What it does**: You process each item in an array.

**Why it's useful**: Handle lists of files, users, or any collection.

**Method**: `for item in "${arr[@]}"; do echo "$item"; done`

**Important**: Always quote `"${arr[@]}"` to handle elements with spaces correctly.

**With index**: `for i in "${!arr[@]}"; do echo "Index $i: ${arr[i]}"; done`

**What `"${!arr[@]}"` does**: Gets array indices instead of values.

#### Loop over file contents line by line

**What it does**: You read and process each line of a file.

**Why it's useful**: Process configuration files, logs, or data files.

**Safe method**: `while IFS= read -r line; do echo "$line"; done < file.txt`

**What each part does**:
- `IFS=` prevents word splitting
- `read -r` prevents backslash interpretation
- `< file.txt` redirects file to loop

**Why not `cat file | while`**: Creates subshell where variable changes don't persist.

#### Loop over files with pattern

**What it does**: You process files that match a pattern.

**Why it's useful**: Batch process images, documents, or any file type.

**Method**: `for file in *.txt; do [[ -e $file ]] || continue; echo "$file"; done`

**Why the check**: If no `.txt` files exist, `*.txt` remains literal. The check skips this case.

**Recursive pattern**: Use `**/*.txt` with `shopt -s globstar` to include subdirectories.

**Multiple patterns**: `for file in *.{jpg,png,gif}; do`

#### Variable-controlled loops

**What it does**: You loop using variables for start, end, and step values.

**Why it's useful**: Dynamic loops based on user input or calculated values.

**Method**: `for ((i=start; i<=end; i+=step)); do echo $i; done`

**Example**:
```bash
start=5
end=20
step=3
for ((i=start; i<=end; i+=step)); do
    echo "Processing item $i"
done
```

#### Loop with both index and values

**What it does**: You get both position and content when looping over arrays.

**Why it's useful**: Know position for logging, create numbered lists, track progress.

**Method**: `for i in "${!arr[@]}"; do echo "$i: ${arr[i]}"; done`

**Alternative with counter**:
```bash
counter=0
for item in "${arr[@]}"; do
    echo "$counter: $item"
    ((counter++))
done
```

### File Handling

**What it covers**: Reading, writing, and processing files efficiently in bash scripts.

**When to use**: File processing, data extraction, and file system operations.

#### Read entire file into variable

**What it does**: You load a complete file's contents into a shell variable quickly.

**Why it's useful**: Faster than using `cat` for variable assignment. Process file contents as single unit.

**Command**: `content=$(<filename)`

**Benefits over `cat`**:
- Faster (no external process)
- Cleaner syntax
- Better performance for large files

**Example**:
```bash
config=$(<config.txt)
if [[ $config == *"debug=true"* ]]; then
    echo "Debug mode enabled"
fi
```

#### Read file into array by lines

**What it does**: You load each line of a file as a separate array element.

**Why it's useful**: Process files line by line while keeping all lines accessible.

**Command**: `readarray -t lines < filename` or `mapfile -t lines < filename`

**What `-t` does**: Removes trailing newlines from each line.

**Example usage**:
```bash
readarray -t todos < todo.txt
echo "You have ${#todos[@]} tasks"
for task in "${todos[@]}"; do
    echo "- $task"
done
```

#### Get just the first line

**What it does**: You read only the first line of a file without processing the rest.

**Why it's useful**: Read headers, get file types, or sample content without reading entire file.

**Command**: `IFS= read -r first_line < filename`

**Why this works**: `read` stops after first line, doesn't process remaining content.

**Example**:
```bash
IFS= read -r header < data.csv
echo "CSV columns: $header"
```

#### Count lines in file

**What it does**: You get the number of lines without using external commands.

**Why it's useful**: Validate file size, show progress, or check empty files.

**Method**:
```bash
count=0
while IFS= read -r _; do
    ((count++))
done < filename
echo "File has $count lines"
```

**What `read -r _` does**: Reads line into throwaway variable `_` (not stored).

#### Get random line from file

**What it does**: You select a random line from a file.

**Why it's useful**: Random quotes, sample data, or random selections.

**Method**:
```bash
readarray -t lines < filename
random_line=${lines[RANDOM % ${#lines[@]}]}
echo "$random_line"
```

**Two-step process**: First load all lines, then pick random element.

#### Create temporary files safely

**What it does**: You create temporary files in secure locations with unique names.

**Why it's useful**: Avoid file conflicts, ensure cleanup, work with sensitive data.

**Command**: `tmp=$(mktemp) || exit 1`

**What `mktemp` provides**:
- Unique filename in secure temp directory
- Proper permissions (600 - only you can read/write)
- Returns full path to created file

**Cleanup**: `trap "rm -f $tmp" EXIT` removes file when script ends

#### Extract filename parts

**What it does**: You separate directory, filename, and extension from full paths.

**Why it's useful**: Process files by type, create backup names, organize output.

**Get basename (filename only)**: `${path##*/}`
**Get directory**: `${path%/*}`
**Get filename without extension**: `${filename%.*}`
**Get extension only**: `${filename##*.}`

**Examples**:
```bash
fullpath="/home/user/documents/report.pdf"
dir=${fullpath%/*}        # "/home/user/documents"
file=${fullpath##*/}      # "report.pdf"
name=${file%.*}           # "report"
ext=${file##*.}           # "pdf"
```

### Conditionals and Testing

**What it covers**: Conditional statements, test operations, and decision-making in bash scripts.

**When to use**: Script logic, error handling, and flow control.

#### Test file types and existence

**What it does**: You check if files exist and what type they are. You make decisions based on file properties.

**Why it's useful**: Prevent errors by checking files before using them. Handle different file types appropriately.

**File existence and types**:
- **Regular file**: `[[ -f $file ]]` - Normal files (not directories or special files)
- **Directory**: `[[ -d $dir ]]` - Folders that contain other files
- **Exists**: `[[ -e $path ]]` - Any type of file or directory

**Example usage**:
```bash
if [[ -f "config.txt" ]]; then
    echo "Config file exists"
elif [[ -d "config" ]]; then
    echo "Config directory exists"
else
    echo "No config found"
fi
```

**Other useful tests**: `-r` (readable), `-w` (writable), `-x` (executable)

#### Check if strings are empty

**What it does**: You test if variables contain text or are empty. You validate user input.

**Why it's useful**: Prevent errors from empty variables. Require input from users before continuing.

**Empty string tests**:
- **Is empty**: `[[ -z $var ]]` - True if variable is empty or unset
- **Not empty**: `[[ -n $var ]]` - True if variable contains text

**Example**:
```bash
read -p "Enter your name: " name
if [[ -z $name ]]; then
    echo "Name cannot be empty"
    exit 1
else
    echo "Hello, $name"
fi
```

**Common mistake**: Always quote variables in tests: `[[ -z "$var" ]]` handles spaces correctly.

#### Use ternary-like operations

**What it does**: You set variables based on conditions in a single line. You provide conditional values.

**Why it's useful**: Shorter than full if statements. Set defaults or conditional values quickly.

**Conditional expansion**: `result=${var:+set}`

**What this means**:
- If `var` is not empty, `result` becomes "set"
- If `var` is empty, `result` becomes empty
- The opposite is `${var:-default}` (use default if empty)

**Example**:
```bash
debug=true
flags=${debug:+--verbose}  # flags="--verbose" if debug is set
command="myapp $flags"     # Includes --verbose only if debug is true
```

**Use cases**: Optional command flags, conditional messages, feature toggles.

#### Check if item exists in array

**What it does**: You find if a specific value is present in an array. You validate choices.

**Why it's useful**: Verify user input against valid options. Check membership in lists.

**Method 1 - Loop and test**:
```bash
colors=("red" "blue" "green")
search="blue"
found=false

for color in "${colors[@]}"; do
    if [[ $color == $search ]]; then
        found=true
        break
    fi
done

[[ $found == true ]] && echo "Found $search"
```

**Method 2 - Associative array as set**:
```bash
declare -A valid_colors
for color in red blue green; do
    valid_colors[$color]=1
done

if [[ ${valid_colors[$user_input]} ]]; then
    echo "Valid color: $user_input"
fi
```

**When to use each**: Loop method for small arrays or when you need the index. Associative array method for large lists or frequent lookups.

### Variables and References

**What it covers**: Variable manipulation, scoping, and advanced variable techniques in bash.

**When to use**: Script configuration, parameter passing, and dynamic variable handling.

#### Create variable references

**What it does**: You create a variable that points to another variable. You access variables indirectly.

**Why it's useful**: Dynamic variable access. Build flexible scripts that work with different variable names.

**Command**: `declare -n ref=variable_name`

**What this creates**: `ref` becomes an alias for `variable_name`. Changes to `ref` affect the original variable.

**Example**:
```bash
name="Alice"
declare -n person_ref=name

echo $person_ref    # Outputs: Alice
person_ref="Bob"    # Changes the original 'name' variable
echo $name          # Outputs: Bob
```

**Use cases**: 
- Function parameters that modify caller variables
- Generic functions that work with different variable names
- Configuration systems with dynamic variable access

**Important**: The reference variable name should not be the same as what it points to.

#### Set default values for variables

**What it does**: You provide fallback values when variables are empty or unset. You prevent errors from missing data.

**Why it's useful**: Handle missing configuration values. Provide sensible defaults for optional parameters.

**Parameter expansion**: `${variable:-default_value}`

**What this means**:
- If `variable` has a value, use it
- If `variable` is empty or unset, use `default_value`
- Original variable is not changed

**Examples**:
```bash
# Use provided port or default to 8080
port=${PORT:-8080}
echo "Server running on port $port"

# Use provided name or ask for it
username=${USER:-$(whoami)}
echo "Hello, $username"

# Chain multiple defaults
config_file=${CONFIG_FILE:-${HOME}/.config/app.conf}
```

**Related operations**:
- `${var:=default}` - Sets variable to default if empty
- `${var:?message}` - Shows error message if variable is empty
- `${var:+alternate}` - Uses alternate value if variable is NOT empty

**Best practice**: Always provide reasonable defaults for optional configuration values.

### Arithmetic Operations

**What it covers**: Mathematical operations and numeric processing in bash.

**When to use**: Calculations, counters, and numeric data processing in scripts.

#### Perform math operations in bash

**What it does**: You calculate numbers directly in bash without external tools. You do arithmetic in scripts.

**Why it's useful**: Faster than calling calculator programs. Handle counters, percentages, and simple math in scripts.

**Arithmetic expansion**: `((result = 5 + 3 * 2))`

**What this means**:
- Math happens inside `(( ))` 
- Result follows standard math rules (multiplication before addition)
- Variables don't need `$` inside arithmetic expressions
- Result: `5 + 6 = 11`

**Examples**:
```bash
# Simple calculations
((count = count + 1))          # Increment counter
((percentage = total / count))  # Calculate percentage
((result = value * 100 / max))  # Convert to percentage

# Using in conditions
if ((score > 80)); then
    echo "Great job!"
fi

# Getting random numbers in range
((random_num = RANDOM % 100 + 1))  # 1 to 100
```

**Operators available**: `+` `-` `*` `/` `%` (modulo), `**` (power), `++` `--` (increment/decrement)

#### Generate number sequences without external tools

**What it does**: You create lists of numbers using bash features. You avoid calling the `seq` command.

**Why it's useful**: Faster than external commands. Works on systems without `seq` command.

**Brace expansion**: `{1..100}` expands to `1 2 3 4 ... 100`

**Examples**:
```bash
# Print numbers 1 to 10
for i in {1..10}; do
    echo "Number: $i"
done

# Create numbered files
touch file{001..100}.txt  # Creates file001.txt to file100.txt

# Step values
echo {0..20..5}     # Outputs: 0 5 10 15 20
echo {10..1..2}     # Outputs: 10 8 6 4 2

# Zero-padded numbers
echo {001..010}     # Outputs: 001 002 003 ... 010
```

**Limitations**: 
- Cannot use variables directly: `{1..$max}` doesn't work
- For variable ranges, use C-style loop: `for ((i=1; i<=max; i++))`

**When to use each**:
- Brace expansion: Fixed ranges known at script write time
- C-style loop: Variable ranges calculated at runtime

### Signal Handling and Traps

**What it covers**: Handling system signals, cleanup operations, and error recovery in bash scripts.

**When to use**: Script robustness, cleanup operations, and signal handling.

#### Clean up when script exits

**What it does**: You run cleanup code when your script ends, regardless of how it ends.

**Why it's useful**: Remove temporary files. Close connections. Ensure clean exits even if script crashes.

**Command**: `trap cleanup EXIT`

**What this does**: Calls the `cleanup` function whenever the script exits (normal exit, error, or interruption).

**Example**:
```bash
#!/bin/bash

cleanup() {
    echo "Cleaning up..."
    rm -f /tmp/myapp_$$*
    kill $background_pid 2>/dev/null
}

trap cleanup EXIT

# Your script code here
touch /tmp/myapp_$$.tmp
some_command &
background_pid=$!

# Script continues...
# cleanup() will run automatically when script ends
```

**Common cleanup tasks**: Remove temp files, kill background processes, unlock resources, save state.

#### Ignore interrupt signals

**What it does**: You prevent users from stopping your script with Ctrl+C. You make scripts unstoppable.

**Why it's useful**: Critical operations that must complete. Prevent accidental interruption during important tasks.

**Command**: `trap '' INT`

**What this means**: Empty string for INT signal means "ignore it". Ctrl+C will have no effect.

**Example**:
```bash
#!/bin/bash

echo "Starting critical backup process..."
trap '' INT    # Ignore Ctrl+C

# Critical backup code here
for file in *.important; do
    cp "$file" /backup/
    echo "Backed up $file"
    sleep 1
done

trap - INT     # Restore normal Ctrl+C behavior
echo "Backup complete. Ctrl+C works again."
```

**Be careful**: Only ignore signals for short periods. Always restore normal behavior afterward.

#### Handle multiple signals

**What it does**: You react to different system signals with the same function. You handle various ways your script might be stopped.

**Why it's useful**: Consistent cleanup regardless of how script is terminated. Handle SIGTERM from system shutdown.

**Command**: `trap "echo Caught" INT TERM`

**What this handles**:
- `INT` - Ctrl+C from user
- `TERM` - Termination request from system

**Example**:
```bash
#!/bin/bash

handle_signal() {
    echo "Received signal: $1"
    echo "Gracefully shutting down..."
    # Cleanup code here
    exit 0
}

trap 'handle_signal SIGINT' INT
trap 'handle_signal SIGTERM' TERM

echo "Script running... try Ctrl+C or send SIGTERM"
while true; do
    sleep 1
done
```

**Other useful signals**: `HUP` (terminal closed), `QUIT` (Ctrl+\), `USR1`/`USR2` (custom signals).

#### Run commands in background

**What it does**: You start commands that run parallel to your script. You manage multiple processes.

**Why it's useful**: Run slow tasks in background. Monitor multiple processes. Improve script performance.

**Start background**: `command &`
**Wait for completion**: `wait`

**Example**:
```bash
#!/bin/bash

echo "Starting multiple downloads..."

# Start downloads in background
wget https://example.com/file1.zip &
pid1=$!

wget https://example.com/file2.zip &  
pid2=$!

wget https://example.com/file3.zip &
pid3=$!

echo "Downloads started. Waiting for completion..."

# Wait for specific process
wait $pid1
echo "File 1 downloaded"

# Wait for all background jobs
wait
echo "All downloads complete"
```

**Get background PID**: `$!` gives PID of last background command.

#### Use timeout with cleanup

**What it does**: You limit how long operations can run. You clean up if operations take too long.

**Why it's useful**: Prevent scripts from hanging forever. Handle network timeouts gracefully.

**Using trap with timeout**:
```bash
#!/bin/bash

timeout_handler() {
    echo "Operation timed out!"
    kill $operation_pid 2>/dev/null
    exit 1
}

# Set timeout trap
trap timeout_handler ALRM

# Start operation in background
long_running_command &
operation_pid=$!

# Set alarm for 30 seconds
(sleep 30; kill -ALRM $$) &
timeout_pid=$!

# Wait for operation to complete
if wait $operation_pid; then
    # Success - cancel timeout
    kill $timeout_pid 2>/dev/null
    echo "Operation completed successfully"
else
    echo "Operation failed"
fi
```

**Alternative**: Use system `timeout` command: `timeout 30s long_running_command`

### Terminal Control

**What it covers**: Controlling terminal behavior, cursor movement, and output formatting.

**When to use**: Interactive scripts, progress bars, and terminal-based interfaces.

#### Get terminal dimensions

**What it does**: You find out how big the terminal window is. You get the number of rows and columns.

**Why it's useful**: Format output to fit screen. Create responsive terminal interfaces. Avoid text wrapping.

**Command**: `read -r LINES COLUMNS < <(stty size)`

**What this does**:
- `stty size` outputs terminal dimensions as "rows columns"
- `read -r LINES COLUMNS` splits the output into two variables
- `< <(...)` uses process substitution to feed the output to read

**Example**:
```bash
#!/bin/bash

# Get terminal size
read -r LINES COLUMNS < <(stty size)

echo "Your terminal is ${COLUMNS} columns wide and ${LINES} lines tall"

# Use for formatting
if ((COLUMNS < 80)); then
    echo "Terminal too narrow for full display"
else
    echo "==================== FULL WIDTH HEADER ===================="
fi
```

**Use cases**: Progress bars that fit screen width, responsive menus, text formatting.

#### Move cursor to specific position

**What it does**: You control where text appears on screen. You position output exactly where you want it.

**Why it's useful**: Create dashboards, update specific areas, build terminal interfaces.

**Command**: `printf '\e[5;10H'`

**What this means**:
- `\e[` starts ANSI escape sequence
- `5;10` means line 5, column 10
- `H` is the "move cursor" command

**Examples**:
```bash
#!/bin/bash

# Clear screen and move to top-left
printf '\e[2J\e[H'

# Display menu at specific positions
printf '\e[5;20H1. Option One'
printf '\e[6;20H2. Option Two'
printf '\e[7;20H3. Option Three'

# Show status in bottom-right corner
printf '\e[24;60HStatus: OK'

# Return cursor to bottom for user input
printf '\e[25;1H'
```

**Line and column numbering**: Starts at 1,1 for top-left corner (not 0,0).

#### Clear screen and control display

**What it does**: You erase screen content and control what the user sees. You reset the display.

**Why it's useful**: Clean up display between operations. Create full-screen interfaces. Reset messy output.

**Commands**:
- **Clear screen**: `printf '\e[2J\e[H'`
- **Clear to end of line**: `printf '\e[K'`
- **Clear to end of screen**: `printf '\e[J'`

**What the codes mean**:
- `\e[2J` - Clear entire screen
- `\e[H` - Move cursor to home position (1,1)
- `\e[K` - Clear from cursor to end of current line
- `\e[J` - Clear from cursor to end of screen

**Progress bar example**:
```bash
#!/bin/bash

total=100
for ((i=1; i<=total; i++)); do
    # Calculate progress
    percent=$((i * 100 / total))
    
    # Move to beginning of line and clear it
    printf '\r\e[K'
    
    # Show progress
    printf 'Progress: %d%% [' $percent
    
    # Draw progress bar
    for ((j=1; j<=percent/2; j++)); do
        printf '='
    done
    printf ']'
    
    sleep 0.1
done

echo  # New line at end
```

**Benefits over `clear` command**: Faster (no external process), more control over what gets cleared.

### Shell Internals

**What it covers**: Advanced bash features, built-in variables, and shell behavior.

**When to use**: Advanced scripting, debugging, and understanding shell behavior.

#### Get current function name

**What it does**: You find out which function your code is currently running in. You access function call information.

**Why it's useful**: Debug scripts by tracking function calls. Create generic error messages. Build logging systems.

**Variable**: `${FUNCNAME[0]}`

**What the array contains**:
- `${FUNCNAME[0]}` - Current function name
- `${FUNCNAME[1]}` - Calling function name  
- `${FUNCNAME[2]}` - Function that called the caller, etc.

**Example**:
```bash
#!/bin/bash

log_error() {
    echo "ERROR in ${FUNCNAME[1]}: $1"
}

process_data() {
    echo "Processing in function: ${FUNCNAME[0]}"
    
    if [[ -z $1 ]]; then
        log_error "No data provided"
        return 1
    fi
    
    echo "Data: $1"
}

main() {
    process_data "test"
    process_data ""  # This will trigger error
}

main
```

**Output shows**: Function names in error messages, making debugging easier.

#### Get hostname without external commands

**What it does**: You get the computer's hostname using shell built-ins. You avoid calling external programs.

**Why it's useful**: Faster than running `hostname` command. Works when external commands are restricted.

**Variable**: `${HOSTNAME:-$(hostname)}`

**What this means**:
- Try `HOSTNAME` variable first (set by some shells)
- If not set, fall back to `hostname` command
- Provides best compatibility across different systems

**Example**:
```bash
#!/bin/bash

# Get hostname reliably
host=${HOSTNAME:-$(hostname)}

echo "Running on: $host"

# Use in logging
log_file="/var/log/myapp-${host}.log"
echo "$(date): Script started" >> "$log_file"

# Use in networking
if [[ $host == "production-server" ]]; then
    echo "Running in production mode"
else
    echo "Running in development mode"
fi
```

**Alternative sources**: `$HOST` (some shells), `/etc/hostname` file, `uname -n` command.

#### Use brace expansion for sequences

**What it does**: You generate lists and sequences using shell expansion. You create multiple items with pattern.

**Why it's useful**: Quick way to create file names, sequences, or combinations without loops.

**Basic syntax**: `{1..10}` expands to `1 2 3 4 5 6 7 8 9 10`

**Advanced examples**:
```bash
# Create backup files
cp important.txt{,.bak}  # Same as: cp important.txt important.txt.bak

# Multiple extensions
ls file.{txt,pdf,doc}    # Same as: ls file.txt file.pdf file.doc

# Number sequences with padding
touch log{001..010}.txt  # Creates log001.txt to log010.txt

# Letter sequences  
echo {a..z}              # Outputs: a b c d e f ... z
echo {A..Z}              # Outputs: A B C D E F ... Z

# Combinations
mkdir -p project/{src,docs,tests}/{js,css,html}
# Creates: project/src/js, project/src/css, etc.

# Step values
echo {0..100..10}        # Outputs: 0 10 20 30 40 50 60 70 80 90 100
```

**When it happens**: Expansion occurs before command runs, creating all combinations.

#### Check what type of command you're running

**What it does**: You find out if a command is built into the shell, an external program, an alias, or a function.

**Why it's useful**: Understand command behavior. Debug PATH issues. Verify command availability.

**Command**: `type -t command_name`

**Return values**:
- `alias` - Command is a shell alias
- `function` - Command is a shell function
- `builtin` - Command is built into the shell
- `file` - Command is an external executable file
- Nothing - Command not found

**Examples**:
```bash
#!/bin/bash

check_command() {
    local cmd=$1
    local cmd_type=$(type -t "$cmd")
    
    case $cmd_type in
        alias)
            echo "$cmd is an alias: $(alias $cmd)"
            ;;
        function)
            echo "$cmd is a function"
            ;;
        builtin)
            echo "$cmd is a shell builtin"
            ;;
        file)
            echo "$cmd is an external command: $(which $cmd)"
            ;;
        *)
            echo "$cmd not found"
            ;;
    esac
}

# Test different command types
check_command "cd"       # builtin
check_command "ls"       # file (usually)
check_command "grep"     # file
check_command "ll"       # alias (if defined)
```

**Use in scripts**: Check if required commands are available before using them.

### Advanced Techniques

**What it covers**: Complex bash programming techniques, optimization, and best practices.

**When to use**: Complex automation, performance optimization, and advanced scripting projects.

#### Generate unique identifiers

**What it does**: You create unique ID strings for temporary files, process tracking, or data identification.

**Why it's useful**: Avoid file name conflicts. Create unique session IDs. Track processes across systems.

**Method**: Read from `/proc/sys/kernel/random/uuid` (if available)

**Example**:
```bash
#!/bin/bash

generate_uuid() {
    if [[ -r /proc/sys/kernel/random/uuid ]]; then
        cat /proc/sys/kernel/random/uuid
    else
        # Fallback for systems without /proc/sys/kernel/random/uuid
        echo "$(date +%s)-$$-$RANDOM"
    fi
}

# Create unique temporary file
uuid=$(generate_uuid)
temp_file="/tmp/myapp-${uuid}.tmp"
echo "Using temporary file: $temp_file"

# Create unique session ID
session_id=$(generate_uuid)
echo "Session ID: $session_id"

# Use in logging
log_entry="[${session_id}] $(date): Process started"
echo "$log_entry" >> /var/log/myapp.log
```

**Fallback method**: Combines timestamp, process ID, and random number for systems without UUID support.

#### Create dynamic progress bars

**What it does**: You show progress that updates on the same line. You create interactive displays.

**Why it's useful**: Show long-running operations progress. Provide user feedback. Create professional interfaces.

**Key technique**: Use carriage return `\r` to return to beginning of line

**Example**:
```bash
#!/bin/bash

show_progress() {
    local current=$1
    local total=$2
    local width=50
    
    # Calculate percentage and bar length
    local percent=$((current * 100 / total))
    local filled=$((current * width / total))
    
    # Build progress bar
    printf '\r['
    for ((i=0; i<filled; i++)); do printf '='; done
    for ((i=filled; i<width; i++)); do printf ' '; done
    printf '] %d%% (%d/%d)' $percent $current $total
}

# Simulate long-running process
total_files=100
for ((i=1; i<=total_files; i++)); do
    show_progress $i $total_files
    sleep 0.1  # Simulate work
done

echo  # New line when complete
echo "Processing complete!"
```

**Advanced features**: Add time estimates, different bar styles, color coding.

#### Get current time without external commands

**What it does**: You get timestamps and format dates using shell built-ins. You avoid calling `date` command.

**Why it's useful**: Faster than external commands. Works in restricted environments. Available in Bash 4.2+.

**Commands**:
- **Epoch time**: `printf '%(%s)T' -1`
- **Formatted date**: `printf '%(%Y-%m-%d)T' -1`
- **Full timestamp**: `printf '%(%Y-%m-%d %H:%M:%S)T' -1`

**Examples**:
```bash
#!/bin/bash

# Get current epoch timestamp
epoch=$(printf '%(%s)T' -1)
echo "Current epoch: $epoch"

# Format dates
today=$(printf '%(%Y-%m-%d)T' -1)
timestamp=$(printf '%(%Y-%m-%d %H:%M:%S)T' -1)

echo "Today: $today"
echo "Now: $timestamp"

# Use in filenames
backup_file="backup-$(printf '%(%Y%m%d_%H%M%S)T' -1).tar.gz"
echo "Backup file: $backup_file"

# Calculate time differences
start_time=$(printf '%(%s)T' -1)
sleep 2
end_time=$(printf '%(%s)T' -1)
duration=$((end_time - start_time))
echo "Operation took $duration seconds"
```

**Format codes**: Same as `strftime()` - `%Y` (year), `%m` (month), `%d` (day), `%H` (hour), etc.

#### Convert between color formats

**What it does**: You transform colors between hexadecimal and RGB formats. You work with color values in scripts.

**Why it's useful**: Process web colors in shell scripts. Convert between different color systems. Generate color palettes.

**Hex to RGB**: `printf '%d' 0x${hex:0:2}` converts hex digits to decimal

**RGB to Hex**: `printf '#%02x%02x%02x' $r $g $b` converts RGB to hex

**Examples**:
```bash
#!/bin/bash

hex_to_rgb() {
    local hex=$1
    # Remove # if present
    hex=${hex#\#}
    
    # Extract RGB components
    local r=$(printf '%d' 0x${hex:0:2})
    local g=$(printf '%d' 0x${hex:2:2})
    local b=$(printf '%d' 0x${hex:4:2})
    
    echo "rgb($r, $g, $b)"
}

rgb_to_hex() {
    local r=$1 g=$2 b=$3
    printf '#%02x%02x%02x' $r $g $b
}

# Convert colors
echo "Converting #ff6b35:"
hex_to_rgb "#ff6b35"

echo "Converting RGB 255, 107, 53:"
rgb_to_hex 255 107 53

# Generate color palette
echo "Color palette:"
for ((i=0; i<=255; i+=51)); do
    hex=$(rgb_to_hex $i $i $i)
    echo "Gray level $i: $hex"
done
```

**Use cases**: Theme generation, color validation, image processing scripts.

#### Generate controlled random numbers

**What it does**: You create random numbers with specific ranges and patterns. You control randomization for testing.

**Why it's useful**: Create test data. Simulate random events. Generate passwords or identifiers.

**Basic usage**: `$((RANDOM % 100))` gives 0-99

**Advanced techniques**:
```bash
#!/bin/bash

# Random number in range (min to max inclusive)
random_range() {
    local min=$1 max=$2
    echo $((RANDOM % (max - min + 1) + min))
}

# Random with seed for reproducible results
random_with_seed() {
    local seed=$1
    RANDOM=$seed
    echo $RANDOM
}

# Generate random string
random_string() {
    local length=$1
    local chars='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local result=''
    
    for ((i=0; i<length; i++)); do
        local index=$((RANDOM % ${#chars}))
        result+=${chars:index:1}
    done
    
    echo "$result"
}

# Examples
echo "Random 1-10: $(random_range 1 10)"
echo "Random 50-100: $(random_range 50 100)"

# Reproducible random (same seed = same sequence)
echo "Seeded random:"
random_with_seed 12345
random_with_seed 12345  # Same result as above

echo "Random string: $(random_string 8)"
```

**Seeding**: Set `RANDOM=seed` to get reproducible sequences for testing.

---

## Additional Resources

### Official Documentation
- [Zsh Documentation](http://zsh.sourceforge.net/Doc/)
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Git Documentation](https://git-scm.com/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Tmux Manual](https://man.openbsd.org/tmux.1)

### Learning Resources
- [The Linux Command Line](http://linuxcommand.org/)
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

### Community
- [PathWise GitHub Repository](https://github.com/smattymatty/pathwise)
- [Unix & Linux Stack Exchange](https://unix.stackexchange.com/)
- [r/commandline](https://reddit.com/r/commandline)

---

## Contributing

This documentation is generated from the PathWise tips database. To suggest improvements or report issues:

1. Open an issue on the [PathWise GitHub repository](https://github.com/smattymatty/pathwise)
2. Suggest new tips or corrections
3. Share your own productivity techniques

---

*This guide is part of PathWise - Be Wise About Your Paths*

*Last updated: 2025*