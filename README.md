# 🗺️ PathWise - Smart Directory Navigation for Zsh

PathWise helps you work faster by remembering the directories you visit most. Jump to your favorite folders with simple shortcuts and see how you spend your time.

## What PathWise Does

PathWise watches where you work and helps you:
- Jump to favorite folders with shortcuts like `j1`, `j2`, `j3`
- See how much time you spend in each directory
- Track your git commits and understand your work patterns
- Learn about your workflow to work better

## Getting Started

### Step 1: Install PathWise

**Option A: Using Oh My Zsh** (Recommended)

1. Copy PathWise to your plugins folder:
```bash
git clone https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pathwise
```

2. Add PathWise to your plugin list. Open `~/.zshrc` and find the plugins line:
```bash
plugins=(git pathwise)  # Add pathwise here
```

3. Restart your terminal or run:
```bash
source ~/.zshrc
```

**Option B: Manual Installation**

1. Copy PathWise to your computer:
```bash
git clone https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin.git \
  ~/projects/zshplugs/pathwise
```

2. Add this line to your `~/.zshrc` file:
```bash
source ~/projects/zshplugs/pathwise/pathwise.plugin.zsh
```

3. Restart your terminal or run:
```bash
source ~/.zshrc
```

### Step 2: Start Using PathWise

After installation, PathWise starts working right away. Navigate to some folders:

```bash
cd ~/Documents
cd ~/Downloads
cd ~/projects
```

Now see your most visited directories:
```bash
freq
```

You will see something like this:
```
📍 Your frequent directories:

  [j1] ~/projects          (3 visits · 15m 30s today)
  [j2] ~/Documents         (2 visits · 5m 12s today)
  [j3] ~/Downloads         (1 visit · 2m 5s today)

💡 Commands: freq | freq --insights | freq --reset | freq --config
```

### Step 3: Use Jump Shortcuts

PathWise creates shortcuts for your top 5 directories:

```bash
j1  # Jump to your #1 most visited directory
j2  # Jump to your #2 most visited directory
j3  # Jump to your #3 most visited directory
```

These shortcuts update as your habits change!

## Configuration Guide

PathWise has settings you can change. Run `freq --config` to see this menu:

```
🎨 PathWise Configuration

Current Settings:
  • Auto-reset: true
  • Reset hour: 0 (midnight)
  • Show count: 5 directories
  • Track time: true
  • Minimum time: 5 seconds
  • Track git: true
  • Sort by: time

Options: on/off, 0-23, 1-10, on/off, 1-60, on/off, time/visits
Enable auto-reset? (current: true):
```

### What Each Setting Does

1. **Auto-reset** (on/off)
   - Starts fresh tracking each day at midnight
   - Yesterday's data becomes backup

2. **Reset hour** (0-23)
   - When to start fresh (0 = midnight, 12 = noon)
   - Only works if auto-reset is on

3. **Show count** (1-10)
   - How many directories to show in `freq` command
   - More directories = more jump shortcuts

4. **Track time** (on/off)
   - Measure time spent in each directory
   - Helps you understand your work patterns

5. **Minimum time** (1-60 seconds)
   - Only count visits longer than this
   - Prevents quick navigation from counting

6. **Track git** (on/off)
   - Analyze your git commits in each directory
   - Shows what kind of work you do where

7. **Sort by** (time/visits)
   - Order directories by time spent or visit count
   - Choose what matters to you

## Git Commit Tracking

When you enable git tracking, PathWise analyzes your commits and shows what type of work you do:

```bash
freq  # With git tracking enabled
```

Shows:
```
📍 Your frequent directories:

  [j1] ~/projects/my-app (15 visits · 2h 34m today) [25 commits]
       📊 Git Activity:
       🐛 Fixes: 8 commits (32%) "bugfix"
       ✨ Features: 6 commits (24%) "add"
       📝 Docs: 4 commits (16%) "readme"
       ♻️ Refactor: 3 commits (12%) "cleanup"
       🔧 Config: 2 commits (8%) "setup"
       🧹 Other: 2 commits (8%)
```

PathWise recognizes 11 types of commits:
- 🔄 **Reverts** - Undoing changes
- 🐛 **Fixes** - Bug fixes and corrections
- ✨ **Features** - New functionality
- 📝 **Documentation** - README and docs
- ♻️ **Refactor** - Code improvements
- ⚡ **Performance** - Speed improvements
- 🧪 **Tests** - Test files
- 🔧 **Config** - Settings and setup
- 🚀 **Deploy** - Release and deployment
- 🎨 **Style** - Formatting changes
- 🧹 **Chore** - Maintenance tasks

## Commands Reference

### Basic Commands

```bash
freq              # Show your top directories
freq --help       # See all commands
freq --insights   # Show detailed analytics
freq --reset      # Clear all data and start fresh
freq --config     # Change settings
```

### Understanding the Display

When you run `freq`, you see:
```
[j1] ~/projects/app (10 visits · 1h 20m today)
 ↑    ↑              ↑           ↑
 │    │              │           └─ Time spent today
 │    │              └─ How many times visited
 │    └─ Directory path
 └─ Shortcut to jump there
```

### Productivity Insights

See detailed information about your work:

```bash
freq --insights
```

This shows:
- Total directories visited today
- Time spent in each directory
- Your busiest work hours
- Common navigation patterns

## Safe Uninstallation

If you need to remove PathWise, we have a safe uninstall script that:
- Backs up your settings
- Removes all PathWise files
- Cleans your .zshrc file
- Lets you keep your data if you want

### How to Uninstall

1. Run the uninstall script:
```bash
./uninstall.sh
```

2. The script will:
   - Find your PathWise installation
   - Ask for confirmation
   - Create a backup of .zshrc
   - Remove PathWise from your plugins
   - Ask if you want to keep your data

3. After uninstalling:
   - Your .zshrc backup is saved as `~/.zshrc.pathwise-backup`
   - Reload your shell: `source ~/.zshrc`
   - Your navigation data is preserved unless you chose to delete it

### What Gets Removed

The uninstaller removes:
- PathWise plugin directory
- PathWise entries in .zshrc
- Jump shortcuts (j1, j2, etc.)
- Configuration settings (optional)
- Navigation history (optional)

## Troubleshooting

### PathWise Not Working?

1. Check if PathWise is loaded:
```bash
echo $FREQ_DIRS_LOADED
```
Should show: `true`

2. Reload your shell:
```bash
source ~/.zshrc
```

3. Check for errors:
```bash
freq --help
```

### Jump Shortcuts Not Working?

First visit some directories, then run `freq` to create shortcuts.

### Time Tracking Not Working?

1. Check if time tracking is enabled:
```bash
freq --config
```

2. Make sure you stay in directories longer than the minimum time (default: 5 seconds)

### Data Not Resetting Daily?

Check your auto-reset settings:
```bash
freq --config
```
Make sure auto-reset is "on" and reset hour is correct.

## Support

Need help? Found a bug?

- **Issues**: [GitHub Issues](https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin/discussions)
- **Updates**: Watch the repository for new features

## License

MIT License - You can use PathWise for any purpose. See [LICENSE](LICENSE) file for details.

---

**PathWise** - Navigate smarter, work better 🗺️

Made with care by the 80-20 Human-In-The-Loop community.