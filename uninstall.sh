#!/bin/bash
# PathWise Uninstall Script
# Clean removal of PathWise plugin

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BOLD}${BLUE}🗺️  PathWise Uninstaller${NC}"
echo -e "${BOLD}Removing PathWise from your system${NC}"
echo ""

# Detect installation type
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/pathwise" ]; then
    PLUGIN_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/pathwise"
    OMZ_INSTALL=true
    echo -e "${BLUE}ℹ${NC} Oh My Zsh installation detected"
elif [ -d "$HOME/.pathwise" ]; then
    PLUGIN_DIR="$HOME/.pathwise"
    OMZ_INSTALL=false
    echo -e "${BLUE}ℹ${NC} Manual installation detected"
else
    echo -e "${RED}✗${NC} PathWise installation not found"
    echo ""
    echo "PathWise does not appear to be installed on this system."
    exit 1
fi

echo -e "Installation directory: ${YELLOW}$PLUGIN_DIR${NC}"
echo ""

# Confirm uninstall
read -p "Are you sure you want to uninstall PathWise? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstall cancelled"
    exit 0
fi

echo ""
echo -e "${BLUE}→${NC} Removing PathWise files..."

# 1. Remove plugin directory
if [ -d "$PLUGIN_DIR" ]; then
    rm -rf "$PLUGIN_DIR"
    echo -e "${GREEN}✓${NC} Removed plugin directory"
else
    echo -e "${YELLOW}⚠${NC} Plugin directory not found"
fi

# 2. Clean up .zshrc
echo -e "${BLUE}→${NC} Cleaning .zshrc configuration..."

if [ -f "$HOME/.zshrc" ]; then
    # Create backup
    cp "$HOME/.zshrc" "$HOME/.zshrc.pathwise-backup"
    echo -e "${GREEN}✓${NC} Created backup at ~/.zshrc.pathwise-backup"
    
    if [ "$OMZ_INSTALL" = true ]; then
        # Remove from Oh My Zsh plugins list
        if grep -q "pathwise" "$HOME/.zshrc"; then
            # Remove pathwise from plugins list (handles various formats)
            sed -i.tmp 's/ pathwise//g; s/pathwise //g; s/(pathwise)/()/g' "$HOME/.zshrc"
            echo -e "${GREEN}✓${NC} Removed from Oh My Zsh plugins"
        fi
    else
        # Remove manual source line
        if grep -q "pathwise.plugin.zsh" "$HOME/.zshrc"; then
            # Remove PathWise source line and its comment
            sed -i.tmp '/# PathWise - Be Wise About Your Paths/d' "$HOME/.zshrc"
            sed -i.tmp '/pathwise.plugin.zsh/d' "$HOME/.zshrc"
            echo -e "${GREEN}✓${NC} Removed manual source configuration"
        fi
    fi
    
    # Remove startup display configuration
    if grep -q "_show_freq_dirs_once" "$HOME/.zshrc"; then
        # Remove the entire startup display block
        sed -i.tmp '/# PathWise startup display/,/add-zsh-hook precmd _show_freq_dirs_once/d' "$HOME/.zshrc"
        echo -e "${GREEN}✓${NC} Removed startup display configuration"
    fi
    
    # Clean up temp files
    rm -f "$HOME/.zshrc.tmp"
else
    echo -e "${YELLOW}⚠${NC} .zshrc not found"
fi

# 3. Remove data files (optional)
echo ""
echo -e "${BLUE}→${NC} PathWise data files found:"
DATA_FILES=(
    "$HOME/.frequent_dirs.config"
    "$HOME/.frequent_dirs.today"
    "$HOME/.frequent_dirs.yesterday"
    "$HOME/.frequent_dirs.last_reset"
    "$HOME/.frequent_dirs.sessions"
    "$HOME/.frequent_dirs.insights"
    "$HOME/.frequent_dirs.patterns"
    "$HOME/.frequent_dirs.git"
    "$HOME/.frequent_dirs.git.today"
    "$HOME/.frequent_dirs.tools"
    "$HOME/.frequent_dirs.learning"
    "$HOME/.frequent_dirs.sessions.archive"
)

FOUND_DATA=false
for file in "${DATA_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "   ${YELLOW}•${NC} $file"
        FOUND_DATA=true
    fi
done

if [ "$FOUND_DATA" = true ]; then
    echo ""
    read -p "Do you want to remove PathWise data files? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        for file in "${DATA_FILES[@]}"; do
            if [ -f "$file" ]; then
                rm -f "$file"
            fi
        done
        echo -e "${GREEN}✓${NC} Removed data files"
    else
        echo -e "${BLUE}ℹ${NC} Data files preserved"
    fi
else
    echo -e "   ${GREEN}None found${NC}"
fi

# 4. Clean up any remaining empty lines in .zshrc
if [ -f "$HOME/.zshrc" ]; then
    # Remove multiple consecutive empty lines
    sed -i.tmp '/^$/N;/^\n$/d' "$HOME/.zshrc"
    rm -f "$HOME/.zshrc.tmp"
fi

echo ""
echo -e "${GREEN}${BOLD}✨ PathWise has been uninstalled${NC}"
echo ""
echo -e "${BOLD}Notes:${NC}"
echo -e "  • A backup of your .zshrc was saved to: ${BLUE}~/.zshrc.pathwise-backup${NC}"
echo -e "  • Please reload your shell: ${BLUE}source ~/.zshrc${NC}"
if [ "$FOUND_DATA" = true ] && [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "  • Your frequency data has been preserved"
fi
echo ""
echo -e "Thanks for trying PathWise! 🗺️"
echo -e "If you have feedback, we'd love to hear it."