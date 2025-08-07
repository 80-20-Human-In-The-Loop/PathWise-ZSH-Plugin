#!/bin/bash
# PathWise Installation Script
# Be Wise About Your Paths 🗺️

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BOLD}${BLUE}🗺️  PathWise Installer${NC}"
echo -e "${BOLD}Be Wise About Your Paths${NC}"
echo ""

# Check if Zsh is installed on the system
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}Error: PathWise requires Zsh${NC}"
    echo "Please install Zsh and try again"
    echo ""
    echo "Installation instructions:"
    echo "  Ubuntu/Debian: sudo apt install zsh"
    echo "  Fedora/RHEL:   sudo dnf install zsh"
    echo "  macOS:         brew install zsh"
    echo "  Arch:          sudo pacman -S zsh"
    exit 1
else
    ZSH_PATH=$(command -v zsh)
    echo -e "${GREEN}✓${NC} Zsh detected at $ZSH_PATH"
fi

# Check for Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}✓${NC} Oh My Zsh detected"
    OMZ_INSTALL=true
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/pathwise"
else
    echo -e "${YELLOW}ℹ${NC} Oh My Zsh not detected - using manual installation"
    OMZ_INSTALL=false
    PLUGIN_DIR="$HOME/.pathwise"
fi

# Check if already installed
if [ -d "$PLUGIN_DIR" ]; then
    echo -e "${YELLOW}⚠${NC} PathWise appears to be already installed at $PLUGIN_DIR"
    read -p "Do you want to reinstall/update? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
    rm -rf "$PLUGIN_DIR"
fi

# Clone repository
echo -e "${BLUE}→${NC} Installing PathWise..."
if command -v git &> /dev/null; then
    git clone https://github.com/yourusername/pathwise.git "$PLUGIN_DIR" 2>/dev/null || {
        # If GitHub repo doesn't exist yet, copy local files
        if [ -d "$(dirname "$0")" ]; then
            cp -r "$(dirname "$0")" "$PLUGIN_DIR"
            echo -e "${GREEN}✓${NC} Installed from local files"
        else
            echo -e "${RED}Error: Could not install PathWise${NC}"
            exit 1
        fi
    }
else
    echo -e "${RED}Error: Git is required for installation${NC}"
    exit 1
fi

# Configure .zshrc
echo -e "${BLUE}→${NC} Configuring .zshrc..."

if [ "$OMZ_INSTALL" = true ]; then
    # Add to Oh My Zsh plugins
    if grep -q "^plugins=" "$HOME/.zshrc"; then
        # Check if pathwise is already in plugins
        if ! grep -q "pathwise" "$HOME/.zshrc"; then
            # Add pathwise to existing plugins line
            sed -i.bak '/^plugins=/s/)/ pathwise)/' "$HOME/.zshrc"
            echo -e "${GREEN}✓${NC} Added PathWise to Oh My Zsh plugins"
        else
            echo -e "${GREEN}✓${NC} PathWise already in plugins list"
        fi
    else
        echo -e "${YELLOW}⚠${NC} Could not find plugins line in .zshrc"
        echo "Please add 'pathwise' to your plugins manually:"
        echo "  plugins=(... pathwise)"
    fi
else
    # Manual installation - add source line
    if ! grep -q "pathwise.plugin.zsh" "$HOME/.zshrc"; then
        echo "" >> "$HOME/.zshrc"
        echo "# PathWise - Be Wise About Your Paths" >> "$HOME/.zshrc"
        echo "source $PLUGIN_DIR/pathwise.plugin.zsh" >> "$HOME/.zshrc"
        echo -e "${GREEN}✓${NC} Added PathWise to .zshrc"
    else
        echo -e "${GREEN}✓${NC} PathWise already configured in .zshrc"
    fi
fi

# Add startup display configuration
if ! grep -q "_show_freq_dirs_once" "$HOME/.zshrc"; then
    echo -e "${BLUE}→${NC} Configuring startup display..."
    cat >> "$HOME/.zshrc" << 'EOF'

# PathWise startup display (shows after prompt loads)
_FREQ_DIRS_SHOWN=false
_show_freq_dirs_once() {
    if [[ "$_FREQ_DIRS_SHOWN" == "true" ]]; then
        return
    fi
    _FREQ_DIRS_SHOWN=true
    
    # Quick check for data
    if [[ -s "$HOME/.frequent_dirs.today" ]] || [[ -s "$HOME/.frequent_dirs.yesterday" ]]; then
        freq
    fi
    
    # Remove from precmd after showing
    precmd_functions=(${precmd_functions[@]/_show_freq_dirs_once})
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _show_freq_dirs_once
EOF
    echo -e "${GREEN}✓${NC} Configured startup display"
fi

# Success message
echo ""
echo -e "${GREEN}${BOLD}✨ PathWise installed successfully!${NC}"
echo ""
echo -e "${BOLD}Quick Start:${NC}"
echo -e "  1. Reload your shell: ${BLUE}source ~/.zshrc${NC}"
echo -e "  2. Navigate to some directories"
echo -e "  3. Type ${BLUE}freq${NC} to see your frequent paths"
echo -e "  4. Use ${BLUE}j1${NC} through ${BLUE}j5${NC} to jump instantly"
echo ""
echo -e "${BOLD}Commands:${NC}"
echo -e "  ${BLUE}freq${NC}          - Show frequent directories"
echo -e "  ${BLUE}freq --config${NC} - Configure settings"
echo -e "  ${BLUE}freq --reset${NC}  - Clear data"
echo -e "  ${BLUE}freq --help${NC}   - Show help"
echo ""
echo -e "${BOLD}Philosophy:${NC}"
echo -e "  80% automation, 20% human wisdom, 100% growth 🚀"
echo ""
echo -e "Happy navigating! 🗺️"