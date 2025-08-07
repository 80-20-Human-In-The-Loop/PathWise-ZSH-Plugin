#!/bin/bash
# PathWise Installation Script
# Be Wise About Your Paths 🗺️

set -e

BOLD=$'\033[1m'
GREEN=$'\033[0;32m'
BLUE=$'\033[0;34m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m' # No Color

# Parse command line arguments
LOCAL_INSTALL=false
UPDATE_MODE=false

# Check for update mode first
if [ "$1" = "update" ] || [ "$1" = "--update" ]; then
    UPDATE_MODE=true
    if [ "$2" = "local" ]; then
        LOCAL_INSTALL=true
    fi
    echo -e "${BLUE}🔄 Updating PathWise...${NC}"
elif [ "$1" = "local" ]; then
    LOCAL_INSTALL=true
    echo -e "${YELLOW}📦 Local installation mode${NC}"
fi

# Show header only for non-update installs
if [ "$UPDATE_MODE" = false ]; then
    echo -e "${BOLD}${BLUE}🗺️  PathWise Installer${NC}"
    echo -e "${BOLD}Be Wise About Your Paths${NC}"
    echo ""
fi

# Check if Zsh is installed on the system
if ! command -v zsh &> /dev/null; then
    echo -e "${RED}Error: PathWise requires Zsh${NC}"
    if [ "$UPDATE_MODE" = false ]; then
        echo "Please install Zsh and try again"
        echo ""
        echo "Installation instructions:"
        echo "  Ubuntu/Debian: sudo apt install zsh"
        echo "  Fedora/RHEL:   sudo dnf install zsh"
        echo "  macOS:         brew install zsh"
        echo "  Arch:          sudo pacman -S zsh"
    fi
    exit 1
else
    if [ "$UPDATE_MODE" = false ]; then
        ZSH_PATH=$(command -v zsh)
        echo -e "${GREEN}✓${NC} Zsh detected at $ZSH_PATH"
    fi
fi

# Check for Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${GREEN}✓${NC} Oh My Zsh detected"
    fi
    OMZ_INSTALL=true
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/pathwise"
else
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${YELLOW}ℹ${NC} Oh My Zsh not detected - using manual installation"
    fi
    OMZ_INSTALL=false
    PLUGIN_DIR="$HOME/.pathwise"
fi

# Check if already installed
if [ -d "$PLUGIN_DIR" ]; then
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${YELLOW}⚠${NC} PathWise appears to be already installed at $PLUGIN_DIR"
        read -p "Do you want to reinstall/update? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled"
            exit 0
        fi
    fi
    rm -rf "$PLUGIN_DIR"
fi

# Install PathWise
if [ "$UPDATE_MODE" = false ]; then
    echo -e "${BLUE}→${NC} Installing PathWise..."
fi
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$LOCAL_INSTALL" = true ]; then
    # Local installation - build and copy from current directory
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${BLUE}→${NC} Building plugin from source..."
    fi
    
    # Build the plugin if build script exists
    if [ -f "$SCRIPT_DIR/build_plugin.py" ]; then
        if command -v python3 &> /dev/null; then
            (cd "$SCRIPT_DIR" && python3 build_plugin.py) > /dev/null 2>&1
            if [ "$UPDATE_MODE" = false ]; then
                echo -e "${GREEN}✓${NC} Plugin built successfully"
            fi
        else
            if [ "$UPDATE_MODE" = false ]; then
                echo -e "${YELLOW}⚠${NC} Python3 not found, using existing plugin file"
            fi
        fi
    fi
    
    # Copy files from local directory
    mkdir -p "$PLUGIN_DIR"
    cp "$SCRIPT_DIR/pathwise.plugin.zsh" "$PLUGIN_DIR/" 2>/dev/null
    [ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/LICENSE" ] && cp "$SCRIPT_DIR/LICENSE" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/install.sh" ] && cp "$SCRIPT_DIR/install.sh" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/uninstall.sh" ] && cp "$SCRIPT_DIR/uninstall.sh" "$PLUGIN_DIR/"
    [ -f "$SCRIPT_DIR/build_plugin.py" ] && cp "$SCRIPT_DIR/build_plugin.py" "$PLUGIN_DIR/"
    [ -d "$SCRIPT_DIR/python" ] && cp -r "$SCRIPT_DIR/python" "$PLUGIN_DIR/"
    
    if [ "$UPDATE_MODE" = false ]; then
        echo -e "${GREEN}✓${NC} Installed from local files"
    fi
else
    # GitHub installation
    if command -v git &> /dev/null; then
        # Clone or pull from GitHub
        git clone https://github.com/80-20-Human-In-The-Loop/PathWise-ZSH-Plugin.git "$PLUGIN_DIR" 2>/dev/null || {
            # If GitHub repo doesn't exist yet, copy local files
            if [ -d "$SCRIPT_DIR" ]; then
                mkdir -p "$PLUGIN_DIR"
                # Copy only the necessary plugin files
                cp "$SCRIPT_DIR/pathwise.plugin.zsh" "$PLUGIN_DIR/" 2>/dev/null
                [ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/LICENSE" ] && cp "$SCRIPT_DIR/LICENSE" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/install.sh" ] && cp "$SCRIPT_DIR/install.sh" "$PLUGIN_DIR/"
                [ -f "$SCRIPT_DIR/uninstall.sh" ] && cp "$SCRIPT_DIR/uninstall.sh" "$PLUGIN_DIR/"
                if [ "$UPDATE_MODE" = false ]; then
                    echo -e "${GREEN}✓${NC} Installed from local files"
                fi
            else
                echo -e "${RED}Error: Could not install PathWise${NC}"
                exit 1
            fi
        }
        
        # Build the plugin if build script exists and we have Python
        if [ -f "$PLUGIN_DIR/build_plugin.py" ] && command -v python3 &> /dev/null; then
            (cd "$PLUGIN_DIR" && python3 build_plugin.py) > /dev/null 2>&1
        fi
    else
        echo -e "${RED}Error: Git is required for installation${NC}"
        exit 1
    fi
fi

# Configure .zshrc (skip during updates - already configured)
if [ "$UPDATE_MODE" = false ]; then
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
        wfreq
    fi
    
    # Remove from precmd after showing
    precmd_functions=(${precmd_functions[@]/_show_freq_dirs_once})
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd _show_freq_dirs_once
EOF
        echo -e "${GREEN}✓${NC} Configured startup display"
    fi
fi

# Success message
if [ "$UPDATE_MODE" = true ]; then
    echo -e "${GREEN}✅ PathWise updated successfully!${NC}"
    echo "Reload your shell to use the latest version: ${BLUE}source ~/.zshrc${NC}"
else
    echo ""
    echo -e "${GREEN}${BOLD}✨ PathWise installed successfully!${NC}"
    echo ""
    echo -e "${BOLD}Quick Start:${NC}"
    echo -e "  1. Reload your shell: ${BLUE}source ~/.zshrc${NC}"
    echo -e "  2. Navigate to some directories"
    echo -e "  3. Type ${BLUE}wfreq${NC} to see your frequent paths"
    echo -e "  4. Use ${BLUE}wj1${NC} through ${BLUE}wj5${NC} to jump instantly"
    echo ""
    echo -e "${BOLD}Commands:${NC}"
    echo -e "  ${BLUE}wfreq${NC}          - Show frequent directories"
    echo -e "  ${BLUE}wfreq --config${NC} - Configure settings"
    echo -e "  ${BLUE}wfreq --reset${NC}  - Clear data"
    echo -e "  ${BLUE}wfreq --help${NC}   - Show help"
    echo ""
    echo -e "${BOLD}Philosophy:${NC}"
    echo -e "  80% automation, 20% human wisdom, 100% growth 🚀"
    echo -e "  Learn more: ${BLUE}https://github.com/80-20-Human-In-The-Loop/Community${NC}"
    echo ""
    echo -e "Happy navigating! 🗺️"
fi