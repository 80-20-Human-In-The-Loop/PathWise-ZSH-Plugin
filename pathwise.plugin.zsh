#!/usr/bin/env zsh
# Frequent Directories Plugin with Daily Rotation
# Tracks your most visited directories with intelligent daily rotation

# Data files
FREQ_DIRS_TODAY="${HOME}/.frequent_dirs.today"
FREQ_DIRS_YESTERDAY="${HOME}/.frequent_dirs.yesterday"
FREQ_DIRS_CONFIG="${HOME}/.frequent_dirs.config"
FREQ_DIRS_LAST_RESET="${HOME}/.frequent_dirs.last_reset"

# Default configuration
DEFAULT_AUTO_RESET="true"
DEFAULT_RESET_HOUR="0"
DEFAULT_SHOW_COUNT="5"

# Initialize files if they don't exist
[[ ! -f "$FREQ_DIRS_TODAY" ]] && touch "$FREQ_DIRS_TODAY"
[[ ! -f "$FREQ_DIRS_YESTERDAY" ]] && touch "$FREQ_DIRS_YESTERDAY"
[[ ! -f "$FREQ_DIRS_LAST_RESET" ]] && date +%Y-%m-%d > "$FREQ_DIRS_LAST_RESET"

# Load configuration
_freq_dirs_load_config() {
    if [[ -f "$FREQ_DIRS_CONFIG" ]]; then
        source "$FREQ_DIRS_CONFIG"
    else
        FREQ_AUTO_RESET="${DEFAULT_AUTO_RESET}"
        FREQ_RESET_HOUR="${DEFAULT_RESET_HOUR}"
        FREQ_SHOW_COUNT="${DEFAULT_SHOW_COUNT}"
    fi
}

# Save configuration
_freq_dirs_save_config() {
    cat > "$FREQ_DIRS_CONFIG" <<EOF
FREQ_AUTO_RESET="${FREQ_AUTO_RESET}"
FREQ_RESET_HOUR="${FREQ_RESET_HOUR}"
FREQ_SHOW_COUNT="${FREQ_SHOW_COUNT}"
EOF
}

# Check if we need to rotate data (daily reset)
_freq_dirs_check_rotation() {
    _freq_dirs_load_config
    
    if [[ "$FREQ_AUTO_RESET" != "true" ]]; then
        return
    fi
    
    local today=$(date +%Y-%m-%d)
    local last_reset=$(cat "$FREQ_DIRS_LAST_RESET" 2>/dev/null || echo "1970-01-01")
    
    if [[ "$today" != "$last_reset" ]]; then
        # It's a new day! Rotate the data
        if [[ -f "$FREQ_DIRS_TODAY" ]]; then
            mv "$FREQ_DIRS_TODAY" "$FREQ_DIRS_YESTERDAY"
        fi
        touch "$FREQ_DIRS_TODAY"
        echo "$today" > "$FREQ_DIRS_LAST_RESET"
    fi
}

# Update directory visit count
_freq_dirs_update() {
    local current_dir="${PWD/#$HOME/~}"
    
    # Check for rotation first
    _freq_dirs_check_rotation
    
    # Don't track home directory itself or root
    if [[ "$current_dir" == "~" ]] || [[ "$current_dir" == "/" ]]; then
        return
    fi
    
    # Update the count for current directory in today's file
    if grep -q "^${current_dir}|" "$FREQ_DIRS_TODAY" 2>/dev/null; then
        # Directory exists, increment count
        local old_count=$(grep "^${current_dir}|" "$FREQ_DIRS_TODAY" | cut -d'|' -f2)
        local new_count=$((old_count + 1))
        # Use a temp file for atomic update
        grep -v "^${current_dir}|" "$FREQ_DIRS_TODAY" > "${FREQ_DIRS_TODAY}.tmp" 2>/dev/null
        echo "${current_dir}|${new_count}" >> "${FREQ_DIRS_TODAY}.tmp"
        mv "${FREQ_DIRS_TODAY}.tmp" "$FREQ_DIRS_TODAY"
    else
        # New directory, add with count 1
        echo "${current_dir}|1" >> "$FREQ_DIRS_TODAY"
    fi
}

# Merge today's and yesterday's data for display
_freq_dirs_get_merged_data() {
    local show_count="${1:-$FREQ_SHOW_COUNT}"
    local merged_file=$(mktemp)
    
    # Add today's data with "today" marker
    if [[ -s "$FREQ_DIRS_TODAY" ]]; then
        while IFS='|' read -r dir count; do
            echo "${dir}|${count}|today" >> "$merged_file"
        done < "$FREQ_DIRS_TODAY"
    fi
    
    # Add yesterday's data with "yesterday" marker (only if not already in today)
    if [[ -s "$FREQ_DIRS_YESTERDAY" ]]; then
        while IFS='|' read -r dir count; do
            if ! grep -q "^${dir}|" "$FREQ_DIRS_TODAY" 2>/dev/null; then
                echo "${dir}|${count}|yesterday" >> "$merged_file"
            fi
        done < "$FREQ_DIRS_YESTERDAY"
    fi
    
    # Sort and return top N entries
    sort -t'|' -k2 -rn "$merged_file" | head -n "$show_count"
    rm -f "$merged_file"
}

# Main freq function with argument parsing
freq() {
    _freq_dirs_load_config
    
    # Parse arguments
    case "$1" in
        --reset|-r)
            echo -n "Reset all frequency data? (y/N): "
            read response
            if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                > "$FREQ_DIRS_TODAY"
                > "$FREQ_DIRS_YESTERDAY"
                date +%Y-%m-%d > "$FREQ_DIRS_LAST_RESET"
                echo "✅ Frequency data reset."
            else
                echo "Cancelled."
            fi
            return
            ;;
        --config|-c)
            echo ""
            echo "⚙️  Frequent Directories Configuration"
            echo "────────────────────────────────────"
            echo ""
            echo "Current settings:"
            echo "  Auto-reset: ${FREQ_AUTO_RESET}"
            echo "  Reset hour: ${FREQ_RESET_HOUR}:00"
            echo "  Show count: ${FREQ_SHOW_COUNT} directories"
            echo ""
            echo "Configure:"
            echo -n "  Enable auto-reset? (y/n) [${FREQ_AUTO_RESET}]: "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_AUTO_RESET="true"
                else
                    FREQ_AUTO_RESET="false"
                fi
            fi
            
            if [[ "$FREQ_AUTO_RESET" == "true" ]]; then
                echo -n "  Reset hour (0-23) [${FREQ_RESET_HOUR}]: "
                read response
                if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 0 ]] && [[ "$response" -le 23 ]]; then
                    FREQ_RESET_HOUR="$response"
                fi
            fi
            
            echo -n "  Number of directories to show (1-10) [${FREQ_SHOW_COUNT}]: "
            read response
            if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 1 ]] && [[ "$response" -le 10 ]]; then
                FREQ_SHOW_COUNT="$response"
            fi
            
            _freq_dirs_save_config
            echo ""
            echo "✅ Configuration saved!"
            return
            ;;
        --help|-h)
            echo "freq - Show frequently visited directories"
            echo ""
            echo "Usage:"
            echo "  freq           Show top directories"
            echo "  freq --reset   Reset all frequency data"
            echo "  freq --config  Configure settings"
            echo "  freq --help    Show this help"
            echo ""
            echo "Jump shortcuts:"
            echo "  j1-j${FREQ_SHOW_COUNT}  Jump to your top directories"
            return
            ;;
    esac
    
    # Check for rotation
    _freq_dirs_check_rotation
    
    # Get merged data
    local merged_data=$(_freq_dirs_get_merged_data)
    
    if [[ -z "$merged_data" ]]; then
        echo "No frequently visited directories yet. Start navigating!"
        return
    fi
    
    echo ""
    echo "📍 Your frequent directories:"
    echo ""
    
    # Display and create aliases
    local i=1
    while IFS='|' read -r dir count period; do
        local display_dir="$dir"
        local period_indicator=""
        
        if [[ "$period" == "yesterday" ]]; then
            period_indicator=" 📅"
            printf "  \033[36m[j%d]\033[0m %-50s \033[90m(%d visits yesterday)%s\033[0m\n" "$i" "$display_dir" "$count" "$period_indicator"
        else
            printf "  \033[36m[j%d]\033[0m %-50s \033[33m(%d visits today)\033[0m\n" "$i" "$display_dir" "$count"
        fi
        
        # Create the jump alias dynamically
        eval "alias j${i}='cd \"${dir/#\~/$HOME}\"'"
        
        i=$((i + 1))
    done <<< "$merged_data"
    
    echo ""
    echo "💡 Commands: freq | freq --reset | freq --config"
    echo ""
}

# Setup jump aliases on shell startup
_freq_dirs_setup_aliases() {
    _freq_dirs_load_config
    _freq_dirs_check_rotation
    
    local merged_data=$(_freq_dirs_get_merged_data)
    
    if [[ -z "$merged_data" ]]; then
        return
    fi
    
    # Create aliases for top directories
    local i=1
    while IFS='|' read -r dir count period; do
        eval "alias j${i}='cd \"${dir/#\~/$HOME}\"'"
        i=$((i + 1))
    done <<< "$merged_data"
}

# Hook into directory change
autoload -U add-zsh-hook
add-zsh-hook chpwd _freq_dirs_update

# Setup aliases on startup
_freq_dirs_setup_aliases

# Startup display is now handled at the top of .zshrc for priority visibility
# The freq command and aliases are still available after plugin loads