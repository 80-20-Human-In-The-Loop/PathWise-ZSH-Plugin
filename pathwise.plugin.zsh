#!/usr/bin/env zsh
# PathWise - Frequent Directories Plugin with Time Tracking, Git Integration & Insights
# Be Wise About Your Paths 🗺️
# Tracks visited directories, time spent, git commits, and provides productivity insights

# Data files
FREQ_DIRS_TODAY="${HOME}/.frequent_dirs.today"
FREQ_DIRS_YESTERDAY="${HOME}/.frequent_dirs.yesterday"
FREQ_DIRS_CONFIG="${HOME}/.frequent_dirs.config"
FREQ_DIRS_LAST_RESET="${HOME}/.frequent_dirs.last_reset"
FREQ_DIRS_SESSIONS="${HOME}/.frequent_dirs.sessions"
FREQ_DIRS_INSIGHTS="${HOME}/.frequent_dirs.insights"
FREQ_DIRS_PATTERNS="${HOME}/.frequent_dirs.patterns"
FREQ_DIRS_GIT="${HOME}/.frequent_dirs.git"
FREQ_DIRS_GIT_TODAY="${HOME}/.frequent_dirs.git.today"

# Time tracking variables
typeset -g FREQ_CURRENT_DIR=""
typeset -g FREQ_ENTER_TIME=""
typeset -g FREQ_SESSION_START=""
typeset -g FREQ_IDLE_THRESHOLD=1800  # 30 minutes in seconds

# Default configuration
DEFAULT_AUTO_RESET="true"
DEFAULT_RESET_HOUR="0"
DEFAULT_SHOW_COUNT="5"
DEFAULT_TRACK_TIME="true"
DEFAULT_MIN_TIME="5"  # Minimum seconds in directory to track
DEFAULT_TRACK_GIT="true"
DEFAULT_SORT_BY="time"  # Options: visits, time, commits

# Initialize files if they don't exist
[[ ! -f "$FREQ_DIRS_TODAY" ]] && touch "$FREQ_DIRS_TODAY"
[[ ! -f "$FREQ_DIRS_YESTERDAY" ]] && touch "$FREQ_DIRS_YESTERDAY"
[[ ! -f "$FREQ_DIRS_LAST_RESET" ]] && date +%Y-%m-%d > "$FREQ_DIRS_LAST_RESET"
[[ ! -f "$FREQ_DIRS_SESSIONS" ]] && touch "$FREQ_DIRS_SESSIONS"
[[ ! -f "$FREQ_DIRS_INSIGHTS" ]] && touch "$FREQ_DIRS_INSIGHTS"
[[ ! -f "$FREQ_DIRS_PATTERNS" ]] && touch "$FREQ_DIRS_PATTERNS"
[[ ! -f "$FREQ_DIRS_GIT" ]] && touch "$FREQ_DIRS_GIT"
[[ ! -f "$FREQ_DIRS_GIT_TODAY" ]] && touch "$FREQ_DIRS_GIT_TODAY"

# Load configuration
_freq_dirs_load_config() {
    # Load config file if it exists
    if [[ -f "$FREQ_DIRS_CONFIG" ]]; then
        source "$FREQ_DIRS_CONFIG"
    fi
    
    # Set defaults for any missing values
    [[ -z "$FREQ_AUTO_RESET" ]] && FREQ_AUTO_RESET="${DEFAULT_AUTO_RESET}"
    [[ -z "$FREQ_RESET_HOUR" ]] && FREQ_RESET_HOUR="${DEFAULT_RESET_HOUR}"
    [[ -z "$FREQ_SHOW_COUNT" ]] && FREQ_SHOW_COUNT="${DEFAULT_SHOW_COUNT}"
    [[ -z "$FREQ_TRACK_TIME" ]] && FREQ_TRACK_TIME="${DEFAULT_TRACK_TIME}"
    [[ -z "$FREQ_MIN_TIME" ]] && FREQ_MIN_TIME="${DEFAULT_MIN_TIME}"
    [[ -z "$FREQ_TRACK_GIT" ]] && FREQ_TRACK_GIT="${DEFAULT_TRACK_GIT}"
    [[ -z "$FREQ_SORT_BY" ]] && FREQ_SORT_BY="${DEFAULT_SORT_BY}"
}

# Save configuration
_freq_dirs_save_config() {
    cat > "$FREQ_DIRS_CONFIG" <<EOF
FREQ_AUTO_RESET="${FREQ_AUTO_RESET}"
FREQ_RESET_HOUR="${FREQ_RESET_HOUR}"
FREQ_SHOW_COUNT="${FREQ_SHOW_COUNT}"
FREQ_TRACK_TIME="${FREQ_TRACK_TIME}"
FREQ_MIN_TIME="${FREQ_MIN_TIME}"
FREQ_TRACK_GIT="${FREQ_TRACK_GIT}"
FREQ_SORT_BY="${FREQ_SORT_BY}"
EOF
}

# Format time duration for display
_freq_dirs_format_time() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$(((seconds % 3600) / 60))
    local secs=$((seconds % 60))
    
    if [[ $hours -gt 0 ]]; then
        echo "${hours}h ${minutes}m"
    elif [[ $minutes -gt 0 ]]; then
        echo "${minutes}m ${secs}s"
    else
        echo "${secs}s"
    fi
}

# Track git commits
_freq_dirs_track_git_commit() {
    if [[ "$FREQ_TRACK_GIT" != "true" ]]; then
        return
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return
    fi
    
    local current_dir="${PWD/#$HOME/~}"
    local commit_hash=$(git rev-parse HEAD 2>/dev/null)
    local commit_msg=$(git log -1 --pretty=%s 2>/dev/null)
    local timestamp=$(date +%s)
    
    # Record commit
    echo "${current_dir}|${commit_hash}|${timestamp}|${commit_msg}" >> "$FREQ_DIRS_GIT"
    
    # Update today's git count
    if grep -q "^${current_dir}|" "$FREQ_DIRS_GIT_TODAY" 2>/dev/null; then
        local count=$(grep "^${current_dir}|" "$FREQ_DIRS_GIT_TODAY" | cut -d'|' -f2)
        local new_count=$((count + 1))
        grep -v "^${current_dir}|" "$FREQ_DIRS_GIT_TODAY" > "${FREQ_DIRS_GIT_TODAY}.tmp" 2>/dev/null
        echo "${current_dir}|${new_count}" >> "${FREQ_DIRS_GIT_TODAY}.tmp"
        mv "${FREQ_DIRS_GIT_TODAY}.tmp" "$FREQ_DIRS_GIT_TODAY"
    else
        echo "${current_dir}|1" >> "$FREQ_DIRS_GIT_TODAY"
    fi
}

# Get git commit count for a directory
_freq_dirs_get_git_count() {
    local dir="$1"
    if [[ -f "$FREQ_DIRS_GIT_TODAY" ]]; then
        grep "^${dir}|" "$FREQ_DIRS_GIT_TODAY" 2>/dev/null | cut -d'|' -f2 || echo "0"
    else
        echo "0"
    fi
}

# Analyze git commit types
_freq_dirs_analyze_commits() {
    local temp_file=$(mktemp)
    
    # Keywords for categorization
    local fix_keywords="fix fixed fixes bugfix hotfix patch bug resolve"
    local feat_keywords="add added feat feature implement new create"
    local test_keywords="test tests testing spec specs"
    local refactor_keywords="refactor refactoring cleanup clean improve"
    local docs_keywords="docs documentation readme comment comments"
    local chore_keywords="chore update bump deps dependencies version"
    
    local fix_count=0
    local feat_count=0
    local test_count=0
    local refactor_count=0
    local docs_count=0
    local chore_count=0
    local other_count=0
    
    if [[ -s "$FREQ_DIRS_GIT" ]]; then
        # Get today's commits
        local today=$(date +%Y-%m-%d)
        local today_timestamp=$(date -d "$today" +%s)
        
        while IFS='|' read -r dir hash timestamp msg; do
            [[ -z "$timestamp" ]] && continue
            [[ $timestamp -lt $today_timestamp ]] && continue
            
            local msg_lower=$(echo "$msg" | tr '[:upper:]' '[:lower:]')
            local categorized=false
            
            for keyword in $fix_keywords; do
                if [[ "$msg_lower" == *"$keyword"* ]]; then
                    ((fix_count++))
                    categorized=true
                    break
                fi
            done
            
            if [[ "$categorized" == "false" ]]; then
                for keyword in $feat_keywords; do
                    if [[ "$msg_lower" == *"$keyword"* ]]; then
                        ((feat_count++))
                        categorized=true
                        break
                    fi
                done
            fi
            
            if [[ "$categorized" == "false" ]]; then
                for keyword in $test_keywords; do
                    if [[ "$msg_lower" == *"$keyword"* ]]; then
                        ((test_count++))
                        categorized=true
                        break
                    fi
                done
            fi
            
            if [[ "$categorized" == "false" ]]; then
                for keyword in $refactor_keywords; do
                    if [[ "$msg_lower" == *"$keyword"* ]]; then
                        ((refactor_count++))
                        categorized=true
                        break
                    fi
                done
            fi
            
            if [[ "$categorized" == "false" ]]; then
                for keyword in $docs_keywords; do
                    if [[ "$msg_lower" == *"$keyword"* ]]; then
                        ((docs_count++))
                        categorized=true
                        break
                    fi
                done
            fi
            
            if [[ "$categorized" == "false" ]]; then
                for keyword in $chore_keywords; do
                    if [[ "$msg_lower" == *"$keyword"* ]]; then
                        ((chore_count++))
                        categorized=true
                        break
                    fi
                done
            fi
            
            [[ "$categorized" == "false" ]] && ((other_count++))
        done < "$FREQ_DIRS_GIT"
        
        local total_commits=$((fix_count + feat_count + test_count + refactor_count + docs_count + chore_count + other_count))
        
        if [[ $total_commits -gt 0 ]]; then
            echo "📊 Git Activity Analysis:" > "$temp_file"
            echo "  Total commits today: $total_commits" >> "$temp_file"
            echo "" >> "$temp_file"
            echo "  Activity breakdown:" >> "$temp_file"
            
            [[ $fix_count -gt 0 ]] && printf "    🐛 Fixes: %d commits (%d%%)\n" "$fix_count" $((fix_count * 100 / total_commits)) >> "$temp_file"
            [[ $feat_count -gt 0 ]] && printf "    ✨ Features: %d commits (%d%%)\n" "$feat_count" $((feat_count * 100 / total_commits)) >> "$temp_file"
            [[ $test_count -gt 0 ]] && printf "    🧪 Tests: %d commits (%d%%)\n" "$test_count" $((test_count * 100 / total_commits)) >> "$temp_file"
            [[ $refactor_count -gt 0 ]] && printf "    🔧 Refactoring: %d commits (%d%%)\n" "$refactor_count" $((refactor_count * 100 / total_commits)) >> "$temp_file"
            [[ $docs_count -gt 0 ]] && printf "    📚 Documentation: %d commits (%d%%)\n" "$docs_count" $((docs_count * 100 / total_commits)) >> "$temp_file"
            [[ $chore_count -gt 0 ]] && printf "    🔨 Chores: %d commits (%d%%)\n" "$chore_count" $((chore_count * 100 / total_commits)) >> "$temp_file"
            [[ $other_count -gt 0 ]] && printf "    📝 Other: %d commits (%d%%)\n" "$other_count" $((other_count * 100 / total_commits)) >> "$temp_file"
            
            # Find most active git project
            echo "" >> "$temp_file"
            if [[ -s "$FREQ_DIRS_GIT_TODAY" ]]; then
                local most_active=$(sort -t'|' -k2 -rn "$FREQ_DIRS_GIT_TODAY" | head -1)
                if [[ -n "$most_active" ]]; then
                    local dir=$(echo "$most_active" | cut -d'|' -f1)
                    local count=$(echo "$most_active" | cut -d'|' -f2)
                    echo "  Most active project: $dir ($count commits)" >> "$temp_file"
                fi
            fi
        fi
    fi
    
    cat "$temp_file"
    rm -f "$temp_file"
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
        
        # Archive session data with date
        if [[ -s "$FREQ_DIRS_SESSIONS" ]]; then
            cat "$FREQ_DIRS_SESSIONS" >> "${FREQ_DIRS_SESSIONS}.archive"
            > "$FREQ_DIRS_SESSIONS"
        fi
        
        # Reset git counts for today
        > "$FREQ_DIRS_GIT_TODAY"
    fi
}

# Record time spent in previous directory
_freq_dirs_record_time() {
    if [[ -n "$FREQ_CURRENT_DIR" ]] && [[ -n "$FREQ_ENTER_TIME" ]]; then
        local exit_time=$(date +%s)
        local duration=$((exit_time - FREQ_ENTER_TIME))
        
        # Only record if spent minimum time
        if [[ $duration -ge $FREQ_MIN_TIME ]]; then
            # Record session
            echo "${FREQ_CURRENT_DIR}|${FREQ_ENTER_TIME}|${exit_time}|${duration}" >> "$FREQ_DIRS_SESSIONS"
            
            # Update today's time tracking
            if grep -q "^${FREQ_CURRENT_DIR}|" "$FREQ_DIRS_TODAY" 2>/dev/null; then
                local line=$(grep "^${FREQ_CURRENT_DIR}|" "$FREQ_DIRS_TODAY")
                local count=$(echo "$line" | cut -d'|' -f2)
                local total_time=$(echo "$line" | cut -d'|' -f3)
                [[ -z "$total_time" ]] && total_time=0
                local new_time=$((total_time + duration))
                
                grep -v "^${FREQ_CURRENT_DIR}|" "$FREQ_DIRS_TODAY" > "${FREQ_DIRS_TODAY}.tmp" 2>/dev/null
                echo "${FREQ_CURRENT_DIR}|${count}|${new_time}" >> "${FREQ_DIRS_TODAY}.tmp"
                mv "${FREQ_DIRS_TODAY}.tmp" "$FREQ_DIRS_TODAY"
            fi
        fi
    fi
}

# Update directory visit count and time tracking
_freq_dirs_update() {
    local current_dir="${PWD/#$HOME/~}"
    
    # Check for rotation first
    _freq_dirs_check_rotation
    
    # Record time in previous directory
    if [[ "$FREQ_TRACK_TIME" == "true" ]]; then
        _freq_dirs_record_time
    fi
    
    # Don't track home directory itself or root
    if [[ "$current_dir" == "~" ]] || [[ "$current_dir" == "/" ]]; then
        FREQ_CURRENT_DIR=""
        FREQ_ENTER_TIME=""
        return
    fi
    
    # Set new directory and time
    FREQ_CURRENT_DIR="$current_dir"
    FREQ_ENTER_TIME=$(date +%s)
    
    # Initialize session if needed
    if [[ -z "$FREQ_SESSION_START" ]]; then
        FREQ_SESSION_START=$FREQ_ENTER_TIME
    fi
    
    # Update the count for current directory in today's file
    if grep -q "^${current_dir}|" "$FREQ_DIRS_TODAY" 2>/dev/null; then
        # Directory exists, increment count
        local line=$(grep "^${current_dir}|" "$FREQ_DIRS_TODAY")
        local old_count=$(echo "$line" | cut -d'|' -f2)
        local total_time=$(echo "$line" | cut -d'|' -f3)
        [[ -z "$total_time" ]] && total_time=0
        local new_count=$((old_count + 1))
        
        grep -v "^${current_dir}|" "$FREQ_DIRS_TODAY" > "${FREQ_DIRS_TODAY}.tmp" 2>/dev/null
        echo "${current_dir}|${new_count}|${total_time}" >> "${FREQ_DIRS_TODAY}.tmp"
        mv "${FREQ_DIRS_TODAY}.tmp" "$FREQ_DIRS_TODAY"
    else
        # New directory, add with count 1 and time 0
        echo "${current_dir}|1|0" >> "$FREQ_DIRS_TODAY"
    fi
}

# Generate insights from collected data
_freq_dirs_generate_insights() {
    local temp_file=$(mktemp)
    
    # Analyze today's data
    if [[ -s "$FREQ_DIRS_TODAY" ]]; then
        # Calculate total time and visits
        local total_time=0
        local total_visits=0
        while IFS='|' read -r dir count time; do
            [[ -z "$time" ]] && time=0
            total_time=$((total_time + time))
            total_visits=$((total_visits + count))
        done < "$FREQ_DIRS_TODAY"
        
        echo "📊 Today's Activity Summary" > "$temp_file"
        echo "────────────────────────────" >> "$temp_file"
        echo "Total directories visited: $(cat "$FREQ_DIRS_TODAY" | wc -l)" >> "$temp_file"
        echo "Total navigation events: $total_visits" >> "$temp_file"
        echo "Total tracked time: $(_freq_dirs_format_time $total_time)" >> "$temp_file"
        echo "" >> "$temp_file"
        
        # Top directories by time
        if [[ $total_time -gt 0 ]]; then
            echo "⏱️  Time Distribution:" >> "$temp_file"
            sort -t'|' -k3 -rn "$FREQ_DIRS_TODAY" | head -5 | while IFS='|' read -r dir count time; do
                [[ -z "$time" ]] && time=0
                if [[ $time -gt 0 ]]; then
                    local percent=$((time * 100 / total_time))
                    printf "  %-40s %s (%d%%)\n" "$dir" "$(_freq_dirs_format_time $time)" "$percent" >> "$temp_file"
                fi
            done
            echo "" >> "$temp_file"
        fi
        
        # Session analysis
        if [[ -s "$FREQ_DIRS_SESSIONS" ]]; then
            echo "📈 Session Patterns:" >> "$temp_file"
            
            # Find peak hours
            local hour_counts=$(mktemp)
            cat "$FREQ_DIRS_SESSIONS" | while IFS='|' read -r dir start_time end_time duration; do
                date -d "@$start_time" +%H >> "$hour_counts"
            done
            
            if [[ -s "$hour_counts" ]]; then
                local peak_hour=$(sort "$hour_counts" | uniq -c | sort -rn | head -1 | awk '{print $2}')
                [[ -n "$peak_hour" ]] && echo "  Peak activity hour: ${peak_hour}:00" >> "$temp_file"
            fi
            rm -f "$hour_counts"
            
            # Average session duration
            local session_count=$(wc -l < "$FREQ_DIRS_SESSIONS")
            if [[ $session_count -gt 0 ]]; then
                local total_session_time=$(awk -F'|' '{sum+=$4} END {print sum}' "$FREQ_DIRS_SESSIONS")
                local avg_time=$((total_session_time / session_count))
                echo "  Average time per directory: $(_freq_dirs_format_time $avg_time)" >> "$temp_file"
            fi
            
            # Directory sequences (patterns)
            echo "" >> "$temp_file"
            echo "🔄 Common Navigation Patterns:" >> "$temp_file"
            local prev_dir=""
            local patterns=$(mktemp)
            cat "$FREQ_DIRS_SESSIONS" | sort -t'|' -k2 -n | while IFS='|' read -r dir start_time end_time duration; do
                if [[ -n "$prev_dir" ]]; then
                    echo "${prev_dir} → ${dir}" >> "$patterns"
                fi
                prev_dir="$dir"
            done
            
            if [[ -s "$patterns" ]]; then
                sort "$patterns" | uniq -c | sort -rn | head -3 | while read count pattern; do
                    echo "  $pattern (${count}x)" >> "$temp_file"
                done
            fi
            rm -f "$patterns"
            echo "" >> "$temp_file"
        fi
        
        # Add git analytics
        local git_analysis=$(_freq_dirs_analyze_commits)
        if [[ -n "$git_analysis" ]]; then
            echo "$git_analysis" >> "$temp_file"
        fi
    fi
    
    cat "$temp_file"
    rm -f "$temp_file"
}

# Merge today's and yesterday's data for display
_freq_dirs_get_merged_data() {
    local show_count="${1:-$FREQ_SHOW_COUNT}"
    local merged_file=$(mktemp)
    
    # Add today's data with "today" marker
    if [[ -s "$FREQ_DIRS_TODAY" ]]; then
        while IFS='|' read -r dir count time; do
            [[ -z "$time" ]] && time=0
            local git_count=$(_freq_dirs_get_git_count "$dir")
            echo "${dir}|${count}|${time}|${git_count}|today" >> "$merged_file"
        done < "$FREQ_DIRS_TODAY"
    fi
    
    # Add yesterday's data with "yesterday" marker (only if not already in today)
    if [[ -s "$FREQ_DIRS_YESTERDAY" ]]; then
        while IFS='|' read -r dir count time; do
            [[ -z "$time" ]] && time=0
            if ! grep -q "^${dir}|" "$FREQ_DIRS_TODAY" 2>/dev/null; then
                echo "${dir}|${count}|${time}|0|yesterday" >> "$merged_file"
            fi
        done < "$FREQ_DIRS_YESTERDAY"
    fi
    
    # Sort based on configuration
    case "$FREQ_SORT_BY" in
        visits)
            sort -t'|' -k2 -rn "$merged_file" | head -n "$show_count"
            ;;
        commits)
            sort -t'|' -k4 -rn "$merged_file" | head -n "$show_count"
            ;;
        time|*)
            sort -t'|' -k3 -rn "$merged_file" | head -n "$show_count"
            ;;
    esac
    
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
                > "$FREQ_DIRS_SESSIONS"
                > "$FREQ_DIRS_INSIGHTS"
                > "$FREQ_DIRS_PATTERNS"
                > "$FREQ_DIRS_GIT"
                > "$FREQ_DIRS_GIT_TODAY"
                date +%Y-%m-%d > "$FREQ_DIRS_LAST_RESET"
                FREQ_CURRENT_DIR=""
                FREQ_ENTER_TIME=""
                FREQ_SESSION_START=""
                echo "✅ Frequency data reset."
            else
                echo "Cancelled."
            fi
            return
            ;;
        --insights|-i)
            echo ""
            _freq_dirs_generate_insights
            echo ""
            return
            ;;
        --config|-c)
            echo ""
            echo "⚙️  PathWise Configuration"
            echo "────────────────────────────────────"
            echo ""
            echo "Current settings:"
            echo "  Auto-reset: ${FREQ_AUTO_RESET}"
            echo "  Reset hour: ${FREQ_RESET_HOUR}:00"
            echo "  Show count: ${FREQ_SHOW_COUNT} directories"
            echo "  Track time: ${FREQ_TRACK_TIME}"
            echo "  Min time: ${FREQ_MIN_TIME} seconds"
            echo "  Track git: ${FREQ_TRACK_GIT}"
            echo "  Sort by: ${FREQ_SORT_BY}"
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
            
            echo -n "  Enable time tracking? (y/n) [${FREQ_TRACK_TIME}]: "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_TIME="true"
                else
                    FREQ_TRACK_TIME="false"
                fi
            fi
            
            if [[ "$FREQ_TRACK_TIME" == "true" ]]; then
                echo -n "  Minimum time to track (seconds) [${FREQ_MIN_TIME}]: "
                read response
                if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]]; then
                    FREQ_MIN_TIME="$response"
                fi
            fi
            
            echo -n "  Enable git tracking? (y/n) [${FREQ_TRACK_GIT}]: "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_GIT="true"
                else
                    FREQ_TRACK_GIT="false"
                fi
            fi
            
            echo -n "  Sort by (visits/time/commits) [${FREQ_SORT_BY}]: "
            read response
            if [[ -n "$response" ]] && [[ "$response" == "visits" || "$response" == "time" || "$response" == "commits" ]]; then
                FREQ_SORT_BY="$response"
            fi
            
            _freq_dirs_save_config
            echo ""
            echo "✅ Configuration saved!"
            return
            ;;
        --help|-h)
            echo "PathWise - Be Wise About Your Paths 🗺️"
            echo ""
            echo "Usage:"
            echo "  freq              Show top directories"
            echo "  freq --insights   Show productivity insights"
            echo "  freq --reset      Reset all frequency data"
            echo "  freq --config     Configure settings"
            echo "  freq --help       Show this help"
            echo ""
            echo "Jump shortcuts:"
            echo "  j1-j${FREQ_SHOW_COUNT}            Jump to your top directories"
            echo ""
            echo "Philosophy:"
            echo "  80% automation, 20% human wisdom, 100% growth 🚀"
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
    while IFS='|' read -r dir count time git_count period; do
        local display_dir="$dir"
        local time_display=""
        local git_display=""
        
        [[ -z "$time" ]] && time=0
        [[ -z "$git_count" ]] && git_count=0
        
        if [[ $time -gt 0 ]]; then
            time_display=" · $(_freq_dirs_format_time $time)"
        fi
        
        if [[ $git_count -gt 0 ]]; then
            git_display=" [$git_count commits]"
        fi
        
        if [[ "$period" == "yesterday" ]]; then
            if [[ -n "$git_display" ]]; then
                printf "  \033[36m[j%d]\033[0m %-35s \033[90m(%d visits%s yesterday)\033[0m \033[93m%s\033[0m\n" \
                    "$i" "$display_dir" "$count" "$time_display" "$git_display"
            else
                printf "  \033[36m[j%d]\033[0m %-35s \033[90m(%d visits%s yesterday)\033[0m\n" \
                    "$i" "$display_dir" "$count" "$time_display"
            fi
        else
            # Color code by time spent (longer = warmer)
            local color="33"  # Yellow default
            if [[ $time -gt 3600 ]]; then
                color="31"  # Red for > 1 hour
            elif [[ $time -gt 1800 ]]; then
                color="91"  # Light red for > 30 min
            elif [[ $time -gt 600 ]]; then
                color="93"  # Light yellow for > 10 min
            fi
            
            if [[ -n "$git_display" ]]; then
                printf "  \033[36m[j%d]\033[0m %-35s \033[${color}m(%d visits%s today)\033[0m \033[93m%s\033[0m\n" \
                    "$i" "$display_dir" "$count" "$time_display" "$git_display"
            else
                printf "  \033[36m[j%d]\033[0m %-35s \033[${color}m(%d visits%s today)\033[0m\n" \
                    "$i" "$display_dir" "$count" "$time_display"
            fi
        fi
        
        # Create the jump alias dynamically
        eval "alias j${i}='cd \"${dir/#\~/$HOME}\"'"
        
        i=$((i + 1))
    done <<< "$merged_data"
    
    echo ""
    echo "💡 Commands: freq | freq --insights | freq --reset | freq --config"
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
    while IFS='|' read -r dir count time git_count period; do
        eval "alias j${i}='cd \"${dir/#\~/$HOME}\"'"
        i=$((i + 1))
    done <<< "$merged_data"
}

# Cleanup on exit (record final time)
_freq_dirs_exit() {
    if [[ "$FREQ_TRACK_TIME" == "true" ]]; then
        _freq_dirs_record_time
    fi
}

# Git post-commit hook wrapper
_freq_dirs_git_wrapper() {
    local git_cmd="$1"
    shift
    
    # Run the actual git command
    command git "$git_cmd" "$@"
    local exit_code=$?
    
    # Track commit if successful
    if [[ "$git_cmd" == "commit" ]] && [[ $exit_code -eq 0 ]]; then
        _freq_dirs_track_git_commit
    fi
    
    return $exit_code
}

# Hook into directory change
autoload -U add-zsh-hook
add-zsh-hook chpwd _freq_dirs_update
add-zsh-hook zshexit _freq_dirs_exit

# Create git alias to track commits
alias git='_freq_dirs_git_wrapper'

# Setup aliases on startup
_freq_dirs_setup_aliases

# Initialize session tracking
FREQ_SESSION_START=$(date +%s)

# Startup display is handled in .zshrc for priority visibility