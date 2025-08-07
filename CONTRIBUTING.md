# Contributing to PathWise

Thank you for your interest in contributing to PathWise! We follow the **80-20 Human-in-the-Loop** philosophy: 80% automation, 20% human wisdom, 100% growth.

## 🎯 Our Philosophy

When contributing, please keep these principles in mind:

1. **Educational Value**: Features should help users learn, not just automate
2. **Human Control**: Users should understand and control what's happening
3. **Transparency**: Code should be readable and well-documented
4. **Privacy First**: Never collect or transmit user data without explicit consent

## 🤝 How to Contribute

### Reporting Issues

- Check existing issues first
- Provide clear reproduction steps
- Include your Zsh version and OS
- Describe expected vs actual behavior

### Suggesting Features

Features that align with our philosophy:
- ✅ Help users understand their patterns
- ✅ Provide actionable insights
- ✅ Respect user privacy
- ✅ Educate while automating

Features we avoid:
- ❌ Complete automation without understanding
- ❌ Data collection without user control
- ❌ Complex features that hide functionality

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test thoroughly
5. Update documentation if needed
6. Commit with clear messages: `git commit -m 'Add feature: description'`
7. Push to your fork: `git push origin feature/your-feature`
8. Open a Pull Request

### Code Style

- Use meaningful variable names
- Comment complex logic
- Follow existing patterns
- Keep functions focused and small
- Add inline documentation for learning

### Testing

Before submitting:
- Test with fresh installation
- Test with existing data
- Test edge cases
- Verify backward compatibility

## 📚 Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/pathwise.git
cd pathwise

# Create a test symlink
ln -s $(pwd)/pathwise.plugin.zsh ~/.oh-my-zsh/custom/plugins/pathwise-dev/

# Add pathwise-dev to your plugins for testing
# Edit ~/.zshrc: plugins=(... pathwise-dev)

# Reload shell
source ~/.zshrc
```

## 🎓 Learning Resources

- [Zsh Plugin Standard](https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html)
- [Oh My Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [80-20 Philosophy](https://github.com/80-20-Human-In-The-Loop/Community)

## 💡 Feature Ideas

We're especially interested in:
- Analytics that teach workflow optimization
- Export formats for team knowledge sharing
- Security auditing features
- Educational tutorials and challenges
- Integration with other 80-20 tools

## 📝 Documentation

When adding features:
- Update README.md with new commands
- Add examples to the examples/ directory
- Document the "why" not just the "what"
- Include learning points for users

## 🌟 Recognition

Contributors who align with our philosophy will be:
- Added to CONTRIBUTORS.md
- Mentioned in release notes
- Invited to shape future direction

## 📜 License

By contributing, you agree that your contributions will be licensed under the GPL-3.0 License.

## 🙏 Thank You!

Every contribution, no matter how small, helps make PathWise better for everyone. Together, we're building tools that enhance human capability rather than replace it.

---

*Remember: The goal isn't just to navigate faster, but to navigate wiser.* 🗺️