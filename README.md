# 🗺️ PathWise - Be Wise About Your Paths

> Navigate with intelligence. Learn from patterns. Share with your team.

PathWise is a Zsh plugin that tracks your navigation patterns, helps you jump to frequent directories instantly, and provides insights into your workflow efficiency. Built with the **80-20 Human-in-the-Loop** philosophy: 80% automation, 20% human wisdom, 100% growth.

## ✨ Features

### Core Features
- **📍 Smart Tracking** - Automatically tracks your most visited directories
- **⚡ Quick Jump** - Use `j1` through `j5` to instantly jump to your top directories  
- **📊 Daily Rotation** - Intelligent daily reset with yesterday's data as fallback
- **🎯 Pattern Recognition** - Learns your navigation habits over time

### Commands
- `freq` - Display your most frequently visited directories
- `freq --reset` - Clear all navigation data
- `freq --config` - Configure auto-reset, display count, and more
- `freq --help` - Show available commands

### Jump Shortcuts
After visiting directories, PathWise creates dynamic shortcuts:
- `j1` - Jump to your #1 most visited directory
- `j2` - Jump to your #2 most visited directory
- ... up to `j5`

## 🚀 Installation

### Oh My Zsh

1. Clone the repository into your Oh My Zsh custom plugins directory:
```bash
git clone https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/pathwise
```

2. Add `pathwise` to your plugins list in `~/.zshrc`:
```bash
plugins=(git zsh-autosuggestions pathwise)
```

3. Reload your shell:
```bash
source ~/.zshrc
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin.git ~/projects/zshplugs/pathwise
```

2. Source the plugin in your `~/.zshrc`:
```bash
source ~/projects/zshplugs/pathwise/pathwise.plugin.zsh
```

3. Reload your shell:
```bash
source ~/.zshrc
```

### Quick Install Script
```bash
curl -fsSL https://raw.githubusercontent.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin/main/install.sh | bash
```

## 📖 Usage

### Basic Usage

Simply navigate as you normally would. PathWise tracks your directories automatically:

```bash
cd ~/projects/my-app
cd ~/Documents
cd ~/Downloads

freq  # See your top directories
```

Output:
```
📍 Your frequent directories:

  [j1] ~/projects/my-app        (15 visits today)
  [j2] ~/Documents              (8 visits today)
  [j3] ~/Downloads              (5 visits today)
  [j4] ~/.config                (12 visits yesterday) 📅
  [j5] ~/projects               (10 visits yesterday) 📅

💡 Commands: freq | freq --reset | freq --config
```

### Configuration

Configure PathWise to match your workflow:

```bash
freq --config
```

Options:
- **Auto-reset**: Daily rotation at midnight (default: enabled)
- **Reset hour**: When to rotate data (default: 0/midnight)
- **Show count**: Number of directories to display (default: 5)

### Startup Display

PathWise can show your frequent directories when you open a new terminal. This is configured in your `.zshrc` and works with Powerlevel10k and other themes.

## 🎯 Philosophy: 80-20 Human-in-the-Loop

PathWise follows the **80-20 Human-in-the-Loop** principle:

- **80% Automation**: PathWise handles tracking, rotation, and shortcut creation automatically
- **20% Human Wisdom**: You decide which patterns to keep and optimize
- **100% Learning**: Every navigation teaches you about your workflow

This approach ensures you become more efficient while understanding your patterns, rather than blindly depending on automation.

## 🔮 Upcoming Features

Aligned with our 80-20 philosophy, these features are planned:

### 📊 Analytics Mode (`freq --analytics`)
- Peak navigation hours
- Directory depth analysis  
- Workflow efficiency scoring
- Pattern detection (thrashing, deep diving, etc.)

### 📚 Educational Mode (`freq --edu`)
- Learn why certain directories matter
- Tips for better organization
- Navigation best practices
- Progress tracking

### 🛡️ Security Audit (`freq --audit`)
- Sensitive directory access monitoring
- Unusual pattern detection
- Security best practices
- Directory health checks

### 🤝 Team Features (`freq --export`)
- Export navigation patterns for onboarding
- Share project navigation maps in PRs
- Team workflow optimization

## 🤝 Contributing

We welcome contributions that align with the 80-20 Human-in-the-Loop philosophy! 

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test thoroughly
5. Commit: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Part of the [80-20-Human-In-The-Loop](https://github.com/80-20-Human-In-The-Loop) ecosystem
- Inspired by tools like `z`, `autojump`, and `fasd`
- Built for developers who value understanding over just automation

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin/discussions)
- **Philosophy**: [80-20 Human-in-the-Loop](https://github.com/80-20-Human-In-The-Loop/Community)

---

**PathWise** - Because being wise about your paths makes you a better developer 🗺️

Built with ❤️ and the belief that humans and AI should work together, not apart.