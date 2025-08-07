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
FREQ_DIRS_TOOLS="${HOME}/.frequent_dirs.tools"

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
DEFAULT_TRACK_TOOLS="true"
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
[[ ! -f "$FREQ_DIRS_TOOLS" ]] && touch "$FREQ_DIRS_TOOLS"

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
    [[ -z "$FREQ_TRACK_TOOLS" ]] && FREQ_TRACK_TOOLS="${DEFAULT_TRACK_TOOLS}"
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
FREQ_TRACK_TOOLS="${FREQ_TRACK_TOOLS}"
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

# Categorize commit with priority-based scoring
_freq_dirs_categorize_commit() {
    local msg_lower="$1"
    local best_category="other"
    local best_score=0
    
    # Keywords for categorization (priority-ordered)
    local revert_keywords="revert rollback undo back out backout rewind restore reset reverse unmerge"
    local fix_keywords="fix fixed fixes bugfix hotfix patch bug resolve resolved resolves solved solve issue error crash broken fault mistake correct repair handle prevent avoid typo oops"
    local feat_keywords="feat feature add added adds new implement implemented introduce introduced create created enhance enhanced extend support enable allow integrate develop include provide setup"
    local perf_keywords="perf performance optimize optimized optimization faster speed speedup improve boost accelerate efficient reduce decreased cache lazy quick enhance performance reduce memory reduce time"
    local refactor_keywords="refactor refactored refactoring restructure rewrite rework simplify extract move moved rename renamed reorganize clean cleanup improve decouple abstract consolidate deduplicate modularize split"
    local test_keywords="test tests testing spec specs coverage unit integration e2e jest pytest mock stub fixture assertion expect should verify validate check ensure prove tdd bdd"
    local build_keywords="build compile bundle webpack rollup vite make cmake gradle maven npm yarn pnpm package dist transpile babel typescript tsc esbuild swc minify uglify compress"
    local ci_keywords="ci cd pipeline github actions actions travis jenkins circle circleci deploy deployment release publish docker kubernetes k8s helm terraform ansible workflow automation"
    local docs_keywords="docs documentation readme comment comments javadoc jsdoc docstring api doc guide tutorial example clarify explain describe document wiki changelog notes annotation usage"
    local style_keywords="style format formatting lint linting prettier eslint pylint rubocop whitespace indent indentation semicolon quotes spacing code style convention pep8 black gofmt rustfmt standardize"
    local chore_keywords="chore update updated upgrade bump deps dependencies dependency version maintain routine housekeeping misc minor tweak adjust modify prepare setup config configure init bootstrap"
    
    # Check each category and calculate scores
    local categories=(revert fix feat perf refactor test build ci docs style chore)
    local priorities=(100 90 80 70 60 50 40 30 20 10 5)
    
    local i=1  # Zsh arrays are 1-indexed
    for category in "${categories[@]}"; do
        local keyword_count=0
        local keywords_var="${category}_keywords"
        eval "local keywords=\$${keywords_var}"
        
        for keyword in ${=keywords}; do  # Use word splitting in zsh
            if [[ "$msg_lower" == *"$keyword"* ]]; then
                ((keyword_count++))
            fi
        done
        
        if [[ $keyword_count -gt 0 ]]; then
            local score=$((keyword_count * priorities[$i]))  # Use $i for proper array access
            if [[ $score -gt $best_score ]]; then
                best_score=$score
                best_category=$category
            fi
        fi
        ((i++))
    done
    
    echo "$best_category"
}

# Get category and matching keyword for a commit
_freq_dirs_categorize_with_keyword() {
    local msg_lower="$1"
    local best_category="other"
    local best_keyword=""
    local best_score=0
    
    # Keywords for categorization (priority-ordered)
    local revert_keywords="revert rollback undo back out backout rewind restore reset reverse unmerge"
    local fix_keywords="fix fixed fixes bugfix hotfix patch bug resolve resolved resolves solved solve issue error crash broken fault mistake correct repair handle prevent avoid typo oops"
    local feat_keywords="feat feature add added adds new implement implemented introduce introduced create created enhance enhanced extend support enable allow integrate develop include provide setup"
    local perf_keywords="perf performance optimize optimized optimization faster speed speedup improve boost accelerate efficient reduce decreased cache lazy quick enhance performance reduce memory reduce time"
    local refactor_keywords="refactor refactored refactoring restructure rewrite rework simplify extract move moved rename renamed reorganize clean cleanup improve decouple abstract consolidate deduplicate modularize split"
    local test_keywords="test tests testing spec specs coverage unit integration e2e jest pytest mock stub fixture assertion expect should verify validate check ensure prove tdd bdd"
    local build_keywords="build compile bundle webpack rollup vite make cmake gradle maven npm yarn pnpm package dist transpile babel typescript tsc esbuild swc minify uglify compress"
    local ci_keywords="ci cd pipeline github actions actions travis jenkins circle circleci deploy deployment release publish docker kubernetes k8s helm terraform ansible workflow automation"
    local docs_keywords="docs documentation readme comment comments javadoc jsdoc docstring api doc guide tutorial example clarify explain describe document wiki changelog notes annotation usage"
    local style_keywords="style format formatting lint linting prettier eslint pylint rubocop whitespace indent indentation semicolon quotes spacing code style convention pep8 black gofmt rustfmt standardize"
    local chore_keywords="chore update updated upgrade bump deps dependencies dependency version maintain routine housekeeping misc minor tweak adjust modify prepare setup config configure init bootstrap"
    
    # Check each category and calculate scores
    local categories=(revert fix feat perf refactor test build ci docs style chore)
    local priorities=(100 90 80 70 60 50 40 30 20 10 5)
    
    local i=1  # Zsh arrays are 1-indexed
    for category in "${categories[@]}"; do
        local keyword_count=0
        local found_keyword=""
        local keywords_var="${category}_keywords"
        eval "local keywords=\$${keywords_var}"
        
        for keyword in ${=keywords}; do  # Use word splitting in zsh
            if [[ "$msg_lower" == *"$keyword"* ]]; then
                ((keyword_count++))
                [[ -z "$found_keyword" ]] && found_keyword="$keyword"
            fi
        done
        
        if [[ $keyword_count -gt 0 ]]; then
            local score=$((keyword_count * priorities[$i]))  # Use $i for proper array access
            if [[ $score -gt $best_score ]]; then
                best_score=$score
                best_category=$category
                best_keyword=$found_keyword
            fi
        fi
        ((i++))
    done
    
    echo "${best_category}|${best_keyword}"
}

# Analyze git commit types
_freq_dirs_analyze_commits() {
    local temp_file=$(mktemp)
    
    # Category counters and keywords
    local revert_count=0
    local fix_count=0
    local feat_count=0
    local perf_count=0
    local refactor_count=0
    local test_count=0
    local build_count=0
    local ci_count=0
    local docs_count=0
    local style_count=0
    local chore_count=0
    local other_count=0
    
    # Store found keywords for each category
    local revert_keywords=""
    local fix_keywords=""
    local feat_keywords=""
    local perf_keywords=""
    local refactor_keywords=""
    local test_keywords=""
    local build_keywords=""
    local ci_keywords=""
    local docs_keywords=""
    local style_keywords=""
    local chore_keywords=""
    
    if [[ -s "$FREQ_DIRS_GIT" ]]; then
        # Get today's commits
        local today=$(date +%Y-%m-%d)
        local today_timestamp=$(date -d "$today" +%s)
        
        while IFS='|' read -r dir hash timestamp msg; do
            [[ -z "$timestamp" ]] && continue
            [[ $timestamp -lt $today_timestamp ]] && continue
            
            local msg_lower=$(echo "$msg" | tr '[:upper:]' '[:lower:]')
            local result=$(_freq_dirs_categorize_with_keyword "$msg_lower")
            local category=$(echo "$result" | cut -d'|' -f1)
            local keyword=$(echo "$result" | cut -d'|' -f2)
            
            case "$category" in
                revert) 
                    ((revert_count++))
                    [[ -n "$keyword" ]] && revert_keywords="$revert_keywords $keyword"
                    ;;
                fix) 
                    ((fix_count++))
                    [[ -n "$keyword" ]] && fix_keywords="$fix_keywords $keyword"
                    ;;
                feat) 
                    ((feat_count++))
                    [[ -n "$keyword" ]] && feat_keywords="$feat_keywords $keyword"
                    ;;
                perf) 
                    ((perf_count++))
                    [[ -n "$keyword" ]] && perf_keywords="$perf_keywords $keyword"
                    ;;
                refactor) 
                    ((refactor_count++))
                    [[ -n "$keyword" ]] && refactor_keywords="$refactor_keywords $keyword"
                    ;;
                test) 
                    ((test_count++))
                    [[ -n "$keyword" ]] && test_keywords="$test_keywords $keyword"
                    ;;
                build) 
                    ((build_count++))
                    [[ -n "$keyword" ]] && build_keywords="$build_keywords $keyword"
                    ;;
                ci) 
                    ((ci_count++))
                    [[ -n "$keyword" ]] && ci_keywords="$ci_keywords $keyword"
                    ;;
                docs) 
                    ((docs_count++))
                    [[ -n "$keyword" ]] && docs_keywords="$docs_keywords $keyword"
                    ;;
                style) 
                    ((style_count++))
                    [[ -n "$keyword" ]] && style_keywords="$style_keywords $keyword"
                    ;;
                chore) 
                    ((chore_count++))
                    [[ -n "$keyword" ]] && chore_keywords="$chore_keywords $keyword"
                    ;;
                *) 
                    ((other_count++))
                    ;;
            esac
        done < "$FREQ_DIRS_GIT"
        
        local total_commits=$((revert_count + fix_count + feat_count + perf_count + refactor_count + test_count + build_count + ci_count + docs_count + style_count + chore_count + other_count))
        
        if [[ $total_commits -gt 0 ]]; then
            printf "\033[94m📊 Git Activity Analysis:\033[0m\n" > "$temp_file"
            printf "  \033[93mTotal commits today: %d\033[0m\n" "$total_commits" >> "$temp_file"
            echo "" >> "$temp_file"
            printf "  \033[36mActivity breakdown:\033[0m\n" >> "$temp_file"
            
            if [[ $revert_count -gt 0 ]]; then
                local keyword=$(echo $revert_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    ⏪ Reverts: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$revert_count" $((revert_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $fix_count -gt 0 ]]; then
                local keyword=$(echo $fix_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    🐛 Fixes: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$fix_count" $((fix_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $feat_count -gt 0 ]]; then
                local keyword=$(echo $feat_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    ✨ Features: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$feat_count" $((feat_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $perf_count -gt 0 ]]; then
                local keyword=$(echo $perf_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    ⚡ Performance: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$perf_count" $((perf_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $refactor_count -gt 0 ]]; then
                local keyword=$(echo $refactor_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    🔧 Refactoring: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$refactor_count" $((refactor_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $test_count -gt 0 ]]; then
                local keyword=$(echo $test_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    🧪 Tests: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$test_count" $((test_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $build_count -gt 0 ]]; then
                local keyword=$(echo $build_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    📦 Build: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$build_count" $((build_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $ci_count -gt 0 ]]; then
                local keyword=$(echo $ci_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    🔄 CI/CD: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$ci_count" $((ci_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $docs_count -gt 0 ]]; then
                local keyword=$(echo $docs_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    📚 Documentation: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$docs_count" $((docs_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $style_count -gt 0 ]]; then
                local keyword=$(echo $style_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    💅 Style: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$style_count" $((style_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            if [[ $chore_count -gt 0 ]]; then
                local keyword=$(echo $chore_keywords | tr ' ' '\n' | grep -v '^$' | shuf -n 1)
                printf "    🔨 Chores: %d commits \033[93m(%d%%) \033[90m\"%s\"\033[0m\n" "$chore_count" $((chore_count * 100 / total_commits)) "$keyword" >> "$temp_file"
            fi
            [[ $other_count -gt 0 ]] && printf "    📝 Other: %d commits \033[93m(%d%%)\033[0m\n" "$other_count" $((other_count * 100 / total_commits)) >> "$temp_file"
            
            # Add keyword suggestions if there are "other" commits
            if [[ $other_count -gt 0 ]]; then
                echo "" >> "$temp_file"
                # Generate random suggestions dynamically at runtime using shuf
                local all_keywords="fix feat add test refactor docs perf build ci style chore resolve implement create update improve optimize enhance cleanup bugfix hotfix patch feature testing spec coverage deploy release revert rollback configure setup install upgrade bump"
                
                # Use shuf to randomly select 3 keywords
                local selected=$(echo $all_keywords | tr ' ' '\n' | shuf -n 3)
                local keyword1=$(echo "$selected" | sed -n '1p')
                local keyword2=$(echo "$selected" | sed -n '2p')
                local keyword3=$(echo "$selected" | sed -n '3p')
                
                printf "  💡 \033[33mTip:\033[0m Use keywords like " >> "$temp_file"
                printf "\033[91m%s\033[0m, " "$keyword1" >> "$temp_file"
                printf "\033[92m%s\033[0m, or " "$keyword2" >> "$temp_file"  
                printf "\033[94m%s\033[0m in commits\n" "$keyword3" >> "$temp_file"
            fi
            
            # Find most active git project
            echo "" >> "$temp_file"
            if [[ -s "$FREQ_DIRS_GIT_TODAY" ]]; then
                local most_active=$(sort -t'|' -k2 -rn "$FREQ_DIRS_GIT_TODAY" | head -1)
                if [[ -n "$most_active" ]]; then
                    local dir=$(echo "$most_active" | cut -d'|' -f1)
                    local count=$(echo "$most_active" | cut -d'|' -f2)
                    printf "  \033[32mMost active project:\033[0m %s \033[93m(%d commits)\033[0m\n" "$dir" "$count" >> "$temp_file"
                fi
            fi
        fi
    fi
    
    cat "$temp_file"
    rm -f "$temp_file"
}

# Track tool usage
_freq_dirs_track_tool() {
    if [[ "$FREQ_TRACK_TOOLS" != "true" ]]; then
        return
    fi
    
    local full_cmd="$1"
    # Extract just the tool name (first word)
    local tool=$(echo "$full_cmd" | awk '{print $1}')
    
    # Skip if empty or builtin
    [[ -z "$tool" ]] && return
    
    # Skip PathWise's own commands to avoid noise in tool tracking
    case "$tool" in
        wfreq|wj1|wj2|wj3|wj4|wj5|wj6|wj7|wj8|wj9|wj10)
            return
            ;;
    esac
    
    # Check if it's an actual executable command
    if command -v "$tool" >/dev/null 2>&1; then
        local tool_path=$(which "$tool" 2>/dev/null)
        local tool_type="other"
        local current_dir="${PWD/#$HOME/~}"
        
        # Categorize the tool
        if [[ "$tool_path" == "$HOME/"* ]]; then
            tool_type="custom"  # User's custom scripts
        elif [[ "$tool" =~ ^(nano|vim|vi|nvim|neovim|emacs|code|subl|atom|gedit|kate|micro|helix|hx|kakoune|kak|git|svn|hg|fossil|bzr|make|cmake|ninja|bazel|gradle|maven|mvn|ant|scons|npm|yarn|pnpm|pip|pip3|poetry|cargo|go|gem|bundle|composer|apt|yum|brew|snap|flatpak|python|python3|node|deno|bun|ruby|perl|php|java|javac|gcc|g++|clang|rustc|go|cat|less|more|head|tail|grep|rg|ag|ack|find|fd|ls|tree|bat|eza|lsd|docker|podman|kubectl|k9s|helm|terraform|ansible|vagrant|systemctl|ps|top|htop|btop|netstat|ss|pytest|jest|mocha|rspec|phpunit|cargo test|go test|npm test|yarn test)$ ]]; then
            tool_type="known"  # From our predefined list
        fi
        
        # Record tool usage
        echo "${current_dir}|${tool}|${tool_type}|$(date +%s)" >> "$FREQ_DIRS_TOOLS"
    fi
}

# Analyze tool usage for a directory
_freq_dirs_analyze_tools() {
    local target_dir="${1:-${PWD/#$HOME/~}}"
    local temp_file=$(mktemp)
    
    if [[ ! -s "$FREQ_DIRS_TOOLS" ]]; then
        return
    fi
    
    # Get tools used in this directory
    grep "^${target_dir}|" "$FREQ_DIRS_TOOLS" 2>/dev/null > "$temp_file" || true
    
    if [[ ! -s "$temp_file" ]]; then
        rm -f "$temp_file"
        return
    fi
    
    # Count tool usage
    local total_uses=$(wc -l < "$temp_file")
    
    printf "\033[94m🛠️  Tool Usage in ${target_dir}:\033[0m\n"
    printf "  \033[93mTotal tool invocations: ${total_uses}\033[0m\n"
    echo ""
    
    # Top 10 tools
    printf "  \033[36mTop 10 Tools:\033[0m\n"
    awk -F'|' '{print $2}' "$temp_file" | sort | uniq -c | sort -rn | head -10 | while read count tool; do
        local percent=$((count * 100 / total_uses))
        local tool_info=$(grep "|${tool}|" "$temp_file" | head -1 | awk -F'|' '{print $3}')
        
        # Color based on type
        local color="\033[37m"  # Default white
        if [[ "$tool_info" == "custom" ]]; then
            color="\033[95m"  # Magenta for custom
        elif [[ "$tool_info" == "known" ]]; then
            color="\033[96m"  # Cyan for known
        fi
        
        printf "    ${color}%-15s\033[0m %3d uses \033[90m(%d%%)\033[0m\n" "$tool:" "$count" "$percent"
    done
    
    # Add hint about --tools flag
    echo ""
    printf "  \033[90m💡 Use 'wfreq --tools' to see tool usage across top directories\033[0m\n"
    
    # Show custom scripts if any
    echo ""
    local custom_tools=$(awk -F'|' '$3=="custom" {print $2}' "$temp_file" | sort -u)
    if [[ -n "$custom_tools" ]]; then
        printf "  \033[35mCustom Scripts Used Here:\033[0m\n"
        echo "    $custom_tools" | tr ' ' '\n' | head -5 | while read tool; do
            [[ -n "$tool" ]] && printf "    🔧 %s\n" "$tool"
        done
    fi
    
    rm -f "$temp_file"
}

# Analyze tool usage across top directories
_freq_dirs_analyze_tools_multi() {
    if [[ "$FREQ_TRACK_TOOLS" != "true" ]]; then
        echo "Tool tracking is disabled. Enable it with: wfreq --config"
        return
    fi
    
    if [[ ! -s "$FREQ_DIRS_TOOLS" ]]; then
        echo "No tool usage data yet. Start using tools to see analytics!"
        return
    fi
    
    printf "\033[94m🛠️  Tool Usage Across Top Directories\033[0m\n"
    printf "\033[90m════════════════════════════════════\033[0m\n"
    echo ""
    
    # Get merged data for top directories
    local merged_data=$(_freq_dirs_get_merged_data)
    
    if [[ -z "$merged_data" ]]; then
        echo "No frequently visited directories yet."
        return
    fi
    
    # Process each top directory
    while IFS='|' read -r dir count time git_count period; do
        local temp_file=$(mktemp)
        
        # Get tools used in this directory
        grep "^${dir}|" "$FREQ_DIRS_TOOLS" 2>/dev/null > "$temp_file" || true
        
        if [[ -s "$temp_file" ]]; then
            local total_uses=$(wc -l < "$temp_file")
            
            printf "\033[96m📁 %s\033[0m \033[90m(%d tool invocations)\033[0m\n" "$dir" "$total_uses"
            
            # Top 5 tools for this directory
            awk -F'|' '{print $2}' "$temp_file" | sort | uniq -c | sort -rn | head -5 | while read count tool; do
                local percent=$((count * 100 / total_uses))
                local tool_info=$(grep "|${tool}|" "$temp_file" | head -1 | awk -F'|' '{print $3}')
                
                # Determine category label
                local category_label=""
                if [[ "$tool_info" == "custom" ]]; then
                    category_label="custom script"
                elif [[ "$tool_info" == "known" ]]; then
                    # Map known tools to categories
                    case "$tool" in
                        nano|vim|vi|nvim|neovim|emacs|code|subl)
                            category_label="editor" ;;
                        git|svn|hg)
                            category_label="version control" ;;
                        npm|yarn|pnpm|pip|cargo|go|gem)
                            category_label="package manager" ;;
                        make|cmake|ninja|gradle|maven)
                            category_label="build tool" ;;
                        python|python3|node|ruby|java)
                            category_label="runner" ;;
                        cat|less|grep|find|ls|tree)
                            category_label="file tool" ;;
                        *)
                            category_label="tool" ;;
                    esac
                else
                    category_label="tool"
                fi
                
                # Color based on percentage
                local color="\033[37m"  # Default white
                if [[ $percent -gt 40 ]]; then
                    color="\033[91m"  # Bright red for dominant
                elif [[ $percent -gt 25 ]]; then
                    color="\033[93m"  # Yellow for frequent
                elif [[ $percent -gt 15 ]]; then
                    color="\033[92m"  # Green for moderate
                fi
                
                printf "   ${color}%-12s %3d uses (%2d%%)\033[0m  \033[90m← %s\033[0m\n" "${tool}:" "$count" "$percent" "$category_label"
            done
            echo ""
        fi
        
        rm -f "$temp_file"
    done <<< "$merged_data"
    
    echo ""
    printf "  \033[90mShowing top 5 tools per directory\033[0m\n"
    printf "  \033[90m💡 Use 'wfreq --config' to change number of directories shown\033[0m\n"
}

# Get tool category for export
_freq_dirs_get_tool_category() {
    local tool="$1"
    
    # Check known tools categories from our tracking
    case "$tool" in
        nano|vim|vi|nvim|emacs|code|subl|atom|gedit|kate|micro)
            echo "editor"
            ;;
        python|python3|ruby|node|java|go|rust|gcc|g++|clang)
            echo "language"
            ;;
        pip|pip3|npm|yarn|cargo|maven|gradle|gem|bundle)
            echo "package_manager"
            ;;
        git|svn|hg|bzr)
            echo "version_control"
            ;;
        pytest|jest|mocha|rspec|unittest|coverage)
            echo "testing"
            ;;
        make|cmake|gradle|mvn|cargo)
            echo "build"
            ;;
        docker|kubectl|helm|terraform)
            echo "devops"
            ;;
        ls|cd|cp|mv|rm|mkdir|find|grep|awk|sed)
            echo "file_tool"
            ;;
        mypy|ruff|flake8|black|prettier|eslint|pylint)
            echo "linting"
            ;;
        *)
            # Check if it's a custom script or other tool
            if [[ "$tool" == ./* ]] || [[ "$tool" == *".sh" ]]; then
                echo "script"
            elif command -v "$tool" >/dev/null 2>&1; then
                echo "tool"
            else
                echo "other"
            fi
            ;;
    esac
}

# Export PathWise data to TOML format
_freq_dirs_export_toml() {
    local output_path="pathwise_export.toml"
    local filter_pattern=""
    
    # Parse arguments - check for filter first, then output path
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -filter=*)
                filter_pattern="${1#-filter=}"
                shift
                ;;
            *)
                # If it doesn't start with -, treat as output path
                if [[ "$1" != -* ]]; then
                    output_path="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Handle special filter cases
    if [[ "$filter_pattern" == "." ]]; then
        # Convert current directory to use ~ notation for matching
        local current_dir="$(pwd)"
        filter_pattern="${current_dir/#$HOME/~}"
    fi
    
    # If output path is a directory, add default filename
    if [[ -d "$output_path" ]]; then
        output_path="${output_path%/}/pathwise_export.toml"
    fi
    
    # Get filtered data
    local merged_data=$(_freq_dirs_get_merged_data 100)  # Get more for filtering
    local filtered_data=""
    
    if [[ -n "$filter_pattern" ]]; then
        # For directory tree filtering, match directories that start with the filter pattern
        # This allows filtering to current directory and its subdirectories
        if [[ "$filter_pattern" == ~* ]] || [[ "$filter_pattern" == /* ]]; then
            # It's a path - do prefix matching for tree filtering
            # Remove trailing slash if present
            filter_pattern="${filter_pattern%/}"
            # Filter to show this directory and all subdirectories
            filtered_data=$(echo "$merged_data" | while IFS='|' read -r dir rest; do
                # Check if dir matches exactly or is a subdirectory
                if [[ "$dir" == "$filter_pattern" ]] || [[ "$dir" == "$filter_pattern/"* ]]; then
                    echo "${dir}|${rest}"
                fi
            done)
        else
            # Regular text filter - case-insensitive matching anywhere in path
            filtered_data=$(echo "$merged_data" | grep -i "$filter_pattern")
        fi
    else
        # Use configured limit
        filtered_data=$(_freq_dirs_get_merged_data)
    fi
    
    if [[ -z "$filtered_data" ]]; then
        echo "❌ No directories match filter: ${filter_pattern:-all}"
        return 1
    fi
    
    # Start building TOML
    {
        # Metadata section
        echo "[metadata]"
        echo "exported_at = \"$(date -Iseconds)\""
        echo "hostname = \"$(hostname)\""
        echo "user = \"$USER\""
        echo "filter = \"${filter_pattern:-all}\""
        echo "tracking_period = \"today + yesterday\""
        echo "sort_method = \"$FREQ_SORT_BY\""
        echo "directories_shown = $FREQ_SHOW_COUNT"
        echo ""
        
        # Calculate summary statistics
        local total_dirs=0
        local total_visits=0
        local total_time=0
        local total_commits=0
        
        while IFS='|' read -r dir count time git_count period; do
            [[ -z "$dir" ]] && continue
            total_dirs=$((total_dirs + 1))
            total_visits=$((total_visits + count))
            total_time=$((total_time + ${time:-0}))
            total_commits=$((total_commits + ${git_count:-0}))
        done <<< "$filtered_data"
        
        # Summary section
        echo "[summary]"
        echo "total_directories = $total_dirs"
        echo "total_visits = $total_visits"
        echo "total_time_seconds = $total_time"
        echo "total_time_formatted = \"$(_freq_dirs_format_time $total_time)\""
        echo "total_commits = $total_commits"
        echo ""
        
        # Time patterns (if we have session data)
        if [[ -s "$FREQ_DIRS_SESSIONS" ]]; then
            echo "[time_patterns]"
            
            # Find peak hour
            local hour_counts=$(mktemp)
            cat "$FREQ_DIRS_SESSIONS" | while IFS='|' read -r dir start_time end_time duration; do
                # Filter sessions to match our directories
                if echo "$filtered_data" | grep -q "^${dir}|"; then
                    date -d "@$start_time" +%H 2>/dev/null >> "$hour_counts" || true
                fi
            done
            
            if [[ -s "$hour_counts" ]]; then
                local peak_hour=$(sort "$hour_counts" | uniq -c | sort -rn | head -1 | awk '{print $2}')
                [[ -n "$peak_hour" ]] && echo "peak_hour = ${peak_hour}"
            fi
            rm -f "$hour_counts"
            
            # Average session duration
            local session_count=0
            local total_session_time=0
            while IFS='|' read -r dir start_time end_time duration; do
                if echo "$filtered_data" | grep -q "^${dir}|"; then
                    session_count=$((session_count + 1))
                    total_session_time=$((total_session_time + duration))
                fi
            done < "$FREQ_DIRS_SESSIONS"
            
            if [[ $session_count -gt 0 ]]; then
                local avg_time=$((total_session_time / session_count))
                echo "average_session_minutes = $((avg_time / 60))"
            fi
            echo ""
        fi
        
        # Export each directory
        while IFS='|' read -r dir count time git_count period; do
            [[ -z "$dir" ]] && continue
            
            echo "[[directories]]"
            echo "path = \"$dir\""
            echo "visits = $count"
            echo "time_seconds = ${time:-0}"
            echo "time_formatted = \"$(_freq_dirs_format_time ${time:-0})\""
            echo "last_visited = \"$period\""
            echo "git_commits = ${git_count:-0}"
            
            # Add tools used in this directory
            if [[ "$FREQ_TRACK_TOOLS" == "true" ]] && [[ -s "$FREQ_DIRS_TOOLS" ]]; then
                local tools_data=$(grep "^${dir}|" "$FREQ_DIRS_TOOLS" 2>/dev/null | \
                    awk -F'|' '{print $2}' | sort | uniq -c | sort -rn | head -10)
                
                if [[ -n "$tools_data" ]]; then
                    echo ""
                    echo "[directories.tools_used]"
                    while read count tool; do
                        [[ -n "$tool" ]] && echo "$tool = $count"
                    done <<< "$tools_data"
                fi
            fi
            
            # Add git categories if available
            if [[ "$FREQ_TRACK_GIT" == "true" ]] && [[ $git_count -gt 0 ]]; then
                echo ""
                echo "[directories.git_categories]"
                # Use shared git analysis function
                local git_analysis=$(_freq_dirs_analyze_git_commits "$dir" "toml")
                if [[ -n "$git_analysis" ]]; then
                    echo "$git_analysis"
                else
                    echo "# No categorized commits found"
                fi
            fi
            
            echo ""
        done <<< "$filtered_data"
        
        # Tools section - show top N tools and where they're used
        if [[ "$FREQ_TRACK_TOOLS" == "true" ]] && [[ -s "$FREQ_DIRS_TOOLS" ]]; then
            echo "# Top Tools Analysis"
            echo "# Shows where each tool is most frequently used"
            echo ""
            
            # Collect all tool usage for filtered directories
            local all_tools=$(mktemp)
            while IFS='|' read -r dir count time git_count period; do
                [[ -z "$dir" ]] && continue
                grep "^${dir}|" "$FREQ_DIRS_TOOLS" >> "$all_tools" 2>/dev/null || true
            done <<< "$filtered_data"
            
            if [[ -s "$all_tools" ]]; then
                # Get top N tools
                local top_n="${FREQ_SHOW_COUNT:-5}"
                local top_tools=$(awk -F'|' '{print $2}' "$all_tools" | sort | uniq -c | sort -rn | head -n "$top_n" | awk '{print $2}')
                
                while read tool; do
                    [[ -z "$tool" ]] && continue
                    
                    echo "[tools.$tool]"
                    
                    # Get total uses
                    local total=$(grep "|${tool}|" "$all_tools" | wc -l)
                    echo "total_uses = $total"
                    
                    # Get category
                    local category=$(_freq_dirs_get_tool_category "$tool")
                    echo "category = \"$category\""
                    
                    # Show top directories where this tool is used
                    echo "directories = ["
                    grep "|${tool}|" "$all_tools" | awk -F'|' '{print $1}' | sort | uniq -c | sort -rn | head -5 | while read count dir; do
                        local percent=$((count * 100 / total))
                        echo "    { path = \"$dir\", uses = $count, percentage = $percent },"
                    done
                    echo "]"
                    echo ""
                done <<< "$top_tools"
            fi
            rm -f "$all_tools"
        fi
        
        # Navigation patterns
        if [[ -s "$FREQ_DIRS_SESSIONS" ]]; then
            echo "# Navigation Patterns"
            echo ""
            
            local patterns=$(mktemp)
            local prev_dir=""
            cat "$FREQ_DIRS_SESSIONS" | sort -t'|' -k2 -n | while IFS='|' read -r dir start_time end_time duration; do
                # Only include if directory is in filtered set
                if echo "$filtered_data" | grep -q "^${dir}|"; then
                    if [[ -n "$prev_dir" ]] && [[ "$prev_dir" != "$dir" ]]; then
                        echo "${prev_dir} → ${dir}" >> "$patterns"
                    fi
                    prev_dir="$dir"
                fi
            done
            
            if [[ -s "$patterns" ]]; then
                sort "$patterns" | uniq -c | sort -rn | head -10 | while read count pattern; do
                    local from_dir=$(echo "$pattern" | awk -F' → ' '{print $1}')
                    local to_dir=$(echo "$pattern" | awk -F' → ' '{print $2}')
                    
                    echo "[[navigation_patterns]]"
                    echo "from = \"$from_dir\""
                    echo "to = \"$to_dir\""
                    echo "count = $count"
                    echo ""
                done
            fi
            rm -f "$patterns"
        fi
        
    } > "$output_path"
    
    # Success message
    echo "✅ Exported PathWise data to $output_path"
    [[ -n "$filter_pattern" ]] && echo "   Filter applied: $filter_pattern"
    echo "   Directories exported: $total_dirs"
    echo "   Total visits tracked: $total_visits"
    [[ "$FREQ_TRACK_TIME" == "true" ]] && echo "   Total time tracked: $(_freq_dirs_format_time $total_time)"
    [[ "$FREQ_TRACK_GIT" == "true" ]] && [[ $total_commits -gt 0 ]] && echo "   Total commits tracked: $total_commits"
    echo ""
    echo "💡 Share this TOML with your team to show your work patterns!"
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

# Shared git commit analysis function
_freq_dirs_analyze_git_commits() {
    local target_dir="$1"
    local format="${2:-toml}"  # "display" or "toml"
    
    if [[ "$FREQ_TRACK_GIT" != "true" ]]; then
        return
    fi
    
    # Get git commits for target directory (or all if not specified)
    local git_data=""
    if [[ -n "$target_dir" ]]; then
        git_data=$(grep "^${target_dir}|" "$FREQ_DIRS_GIT" 2>/dev/null)
    else
        git_data=$(cat "$FREQ_DIRS_GIT" 2>/dev/null)
    fi
    
    [[ -z "$git_data" ]] && return
    
    # Load category keywords
    local revert_keywords="revert reverted"
    local fix_keywords="fix fixed fixes bugfix bug error issue problem broken crash"
    local feat_keywords="add added adds feature feat new implement create build"
    local perf_keywords="improve improved improves optimization optimize performance fast speed"
    local refactor_keywords="refactor refactors refactored restructure reorganize cleanup clean"
    local test_keywords="test tests testing spec specs coverage unittest"
    local build_keywords="build builds built compile compilation make cmake package"
    local ci_keywords="ci cd pipeline deploy deployment github actions workflow"
    local docs_keywords="doc docs readme documentation comment comments md markdown"
    local style_keywords="style styles styling format formatting prettier lint linting"
    local chore_keywords="chore maintenance update updates version merge merged"
    
    # Count commits by category
    local revert_count=0 fix_count=0 feat_count=0 perf_count=0 refactor_count=0
    local test_count=0 build_count=0 ci_count=0 docs_count=0 style_count=0 chore_count=0 other_count=0
    
    while IFS='|' read -r dir hash timestamp message; do
        local msg=$(echo "$message" | tr '[:upper:]' '[:lower:]')
        local categorized=false
        
        # Check each category (same logic as existing insights)
        for keyword in $revert_keywords; do
            if [[ "$msg" == *"$keyword"* ]]; then
                revert_count=$((revert_count + 1))
                categorized=true
                break
            fi
        done
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $fix_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    fix_count=$((fix_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $feat_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    feat_count=$((feat_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $perf_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    perf_count=$((perf_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $refactor_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    refactor_count=$((refactor_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $test_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    test_count=$((test_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $build_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    build_count=$((build_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $ci_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    ci_count=$((ci_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $docs_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    docs_count=$((docs_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $style_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    style_count=$((style_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            for keyword in $chore_keywords; do
                if [[ "$msg" == *"$keyword"* ]]; then
                    chore_count=$((chore_count + 1))
                    categorized=true
                    break
                fi
            done
        fi
        
        if [[ "$categorized" != "true" ]]; then
            other_count=$((other_count + 1))
        fi
    done <<< "$git_data"
    
    local total_commits=$((revert_count + fix_count + feat_count + perf_count + refactor_count + test_count + build_count + ci_count + docs_count + style_count + chore_count + other_count))
    
    if [[ $total_commits -eq 0 ]]; then
        return
    fi
    
    # Output in requested format
    if [[ "$format" == "toml" ]]; then
        # TOML key=value format for export
        [[ $revert_count -gt 0 ]] && echo "reverts = $revert_count"
        [[ $fix_count -gt 0 ]] && echo "fixes = $fix_count"
        [[ $feat_count -gt 0 ]] && echo "features = $feat_count"
        [[ $perf_count -gt 0 ]] && echo "performance = $perf_count"
        [[ $refactor_count -gt 0 ]] && echo "refactoring = $refactor_count"
        [[ $test_count -gt 0 ]] && echo "tests = $test_count"
        [[ $build_count -gt 0 ]] && echo "build = $build_count"
        [[ $ci_count -gt 0 ]] && echo "ci_cd = $ci_count"
        [[ $docs_count -gt 0 ]] && echo "documentation = $docs_count"
        [[ $style_count -gt 0 ]] && echo "style = $style_count"
        [[ $chore_count -gt 0 ]] && echo "chore = $chore_count"
        [[ $other_count -gt 0 ]] && echo "other = $other_count"
    fi
    
    # Return total count for reference
    return $total_commits
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
        
        printf "\033[94m📊 Today's Activity Summary\033[0m\n" > "$temp_file"
        printf "\033[90m────────────────────────────\033[0m\n" >> "$temp_file"
        printf "Total directories visited: \033[93m$(cat "$FREQ_DIRS_TODAY" | wc -l)\033[0m\n" >> "$temp_file"
        printf "Total navigation events: \033[93m$total_visits\033[0m\n" >> "$temp_file"
        printf "Total tracked time: \033[92m$(_freq_dirs_format_time $total_time)\033[0m\n" >> "$temp_file"
        echo "" >> "$temp_file"
        
        # Top directories by time
        if [[ $total_time -gt 0 ]]; then
            printf "\033[36m⏱️  Time Distribution:\033[0m\n" >> "$temp_file"
            sort -t'|' -k3 -rn "$FREQ_DIRS_TODAY" | head -5 | while IFS='|' read -r dir count time; do
                [[ -z "$time" ]] && time=0
                if [[ $time -gt 0 ]]; then
                    local percent=$((time * 100 / total_time))
                    # Color based on percentage
                    local color="37"  # White default
                    if [[ $percent -gt 50 ]]; then
                        color="91"  # Bright red for > 50%
                    elif [[ $percent -gt 30 ]]; then
                        color="93"  # Bright yellow for > 30%
                    elif [[ $percent -gt 10 ]]; then
                        color="92"  # Bright green for > 10%
                    fi
                    printf "  %-40s \033[${color}m%s (%d%%)\033[0m\n" "$dir" "$(_freq_dirs_format_time $time)" "$percent" >> "$temp_file"
                fi
            done
            echo "" >> "$temp_file"
        fi
        
        # Session analysis
        if [[ -s "$FREQ_DIRS_SESSIONS" ]]; then
            printf "\033[35m📈 Session Patterns:\033[0m\n" >> "$temp_file"
            
            # Find peak hours
            local hour_counts=$(mktemp)
            cat "$FREQ_DIRS_SESSIONS" | while IFS='|' read -r dir start_time end_time duration; do
                date -d "@$start_time" +%H >> "$hour_counts"
            done
            
            if [[ -s "$hour_counts" ]]; then
                local peak_hour=$(sort "$hour_counts" | uniq -c | sort -rn | head -1 | awk '{print $2}')
                [[ -n "$peak_hour" ]] && printf "  Peak activity hour: \033[93m${peak_hour}:00\033[0m\n" >> "$temp_file"
            fi
            rm -f "$hour_counts"
            
            # Average session duration
            local session_count=$(wc -l < "$FREQ_DIRS_SESSIONS")
            if [[ $session_count -gt 0 ]]; then
                local total_session_time=$(awk -F'|' '{sum+=$4} END {print sum}' "$FREQ_DIRS_SESSIONS")
                local avg_time=$((total_session_time / session_count))
                printf "  Average time per directory: \033[92m$(_freq_dirs_format_time $avg_time)\033[0m\n" >> "$temp_file"
            fi
            
            # Directory sequences (patterns)
            echo "" >> "$temp_file"
            printf "\033[96m🔄 Common Navigation Patterns:\033[0m\n" >> "$temp_file"
            local prev_dir=""
            local patterns=$(mktemp)
            cat "$FREQ_DIRS_SESSIONS" | sort -t'|' -k2 -n | while IFS='|' read -r dir start_time end_time duration; do
                if [[ -n "$prev_dir" ]] && [[ "$prev_dir" != "$dir" ]]; then
                    # Only record if actually changed directories (skip self-navigation from editors)
                    echo "${prev_dir} → ${dir}" >> "$patterns"
                fi
                prev_dir="$dir"
            done
            
            if [[ -s "$patterns" ]]; then
                sort "$patterns" | uniq -c | sort -rn | head -3 | while read count pattern; do
                    # Split pattern into parts and colorize arrow (using awk for multi-byte delimiter)  
                    local from_dir=$(echo "$pattern" | awk -F' → ' '{print $1}')
                    local to_dir=$(echo "$pattern" | awk -F' → ' '{print $2}')
                    printf "  %s \033[93m→\033[0m %s \033[90m(%sx)\033[0m\n" "$from_dir" "$to_dir" "$count" >> "$temp_file"
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
        
        # Add tool usage analytics
        if [[ "$FREQ_TRACK_TOOLS" == "true" ]]; then
            echo "" >> "$temp_file"
            local current_dir="${PWD/#$HOME/~}"
            local tool_analysis=$(_freq_dirs_analyze_tools "$current_dir")
            if [[ -n "$tool_analysis" ]]; then
                echo "$tool_analysis" >> "$temp_file"
            fi
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

PATHWISE_TIPS=(
    "pathwise:Use 'wj1' through 'wj5' to jump to your most visited directories instantly"
    "pathwise:Run 'wfreq --insights' to see detailed analytics about your navigation patterns"
    "pathwise:PathWise tracks time automatically - stay in a directory 5+ seconds to record it"
    "pathwise:Use 'wfreq --config' to customize tracking settings and display preferences"
    "pathwise:Your jump shortcuts update dynamically as your habits change throughout the day"
    "pathwise:Run 'wfreq --reset' to clear all data and start fresh with new tracking"
    "pathwise:PathWise rotates data daily at midnight - yesterday becomes your fallback"
    "pathwise:Enable git tracking to see what type of work you do in each directory"
    "pathwise:Sort by 'time' to see where you spend most time, or 'visits' for frequency"
    "pathwise:PathWise learns your patterns - the more you navigate, the smarter it gets"
    "pathwise:Check 'wfreq --insights' weekly to understand your productivity patterns"
    "pathwise:Jump shortcuts persist across terminal sessions until your habits change"
    "pathwise:Use PathWise data to identify time sinks and optimize your workflow"
    "pathwise:PathWise tracks both visits and time - giving you complete navigation insights"
    "pathwise:Configure minimum time to avoid tracking quick directory traversals"
    "pathwise:Use 'wfreq --tools' to see which tools you use most in each directory"
    "pathwise:Tool tracking reveals your workflow - see if you edit, compile, or debug more in each project"
    "pathwise:Export your work patterns with 'wfreq --export' to share with teammates"
    "pathwise:Use 'wfreq --export -filter=python' to export only Python-related project data"
    "pathwise:Export current project with 'wfreq --export project.toml -filter=.' for focused reports"
    "pathwise:TOML exports show WHERE you use each tool - perfect for onboarding new developers"
    "pathwise:Share your exported TOML with teammates to demonstrate project workflows"
    "pathwise:Filter exports by directory patterns to create focused work analytics"
    "pathwise:Exported TOML files contain all your insights: time patterns, tools, and navigation flows"
    "zsh:Use 'cd -' to quickly jump back to your previous directory"
    "zsh:Press Ctrl+R to search through your command history interactively"
    "zsh:Use '!!' to repeat the last command, or 'sudo !!' to run it with sudo"
    "zsh:Tab completion works for commands, files, and even git branches"
    "zsh:Use 'cd **/<tab>' to fuzzy search for directories recursively"
    "zsh:Create permanent aliases in ~/.zshrc for your common commands"
    "zsh:Use 'which <command>' to find where a command is located"
    "zsh:Press Alt+. to insert the last argument from previous command"
    "zsh:Use 'dirs -v' to see your directory stack, 'cd ~N' to jump to entry N"
    "zsh:Enable case-insensitive completion with 'zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'"
    "zsh:Use 'bindkey' to see all keyboard shortcuts in your current shell"
    "zsh:Press Ctrl+L to clear the screen (faster than typing 'clear')"
    "zsh:Use 'fc' to edit and re-run the last command in your editor"
    "zsh:Set CDPATH to add common base directories for quick navigation"
    "zsh:Use parameter expansion: \${var:-default} for default values"
    "linux:Use 'ls -lah' to see all files with human-readable sizes"
    "linux:Press Ctrl+Z to suspend a process, 'bg' to background it, 'fg' to foreground"
    "linux:Use 'df -h' to check disk space, 'du -sh *' for directory sizes"
    "linux:The 'tree' command shows directory structure visually (install if needed)"
    "linux:Use 'grep -r \"pattern\" .' to search recursively in current directory"
    "linux:Press Ctrl+D to logout or exit (cleaner than typing 'exit')"
    "linux:Use 'ps aux | grep <name>' to find processes, 'kill -9 <pid>' to force stop"
    "linux:The 'watch' command repeats any command periodically: 'watch -n 2 ls'"
    "linux:Use 'chmod +x file' to make a file executable quickly"
    "linux:Redirect errors with '2>' or both output and errors with '&>'"
    "linux:Use 'find . -name \"*.txt\" -mtime -7' to find files modified in last 7 days"
    "linux:The 'tee' command shows output and saves it: 'ls | tee output.txt'"
    "linux:Use 'tail -f logfile' to watch a log file in real-time"
    "linux:Create multiple directories at once: 'mkdir -p parent/child/grandchild'"
    "linux:Use 'ln -s target link' to create symbolic links for easy access"
    "productivity:Organize projects in a consistent directory structure for faster navigation"
    "productivity:Use descriptive directory names - future you will thank present you"
    "productivity:Keep your home directory clean - use subdirectories for organization"
    "productivity:Create a ~/tmp directory for temporary work that you clean regularly"
    "productivity:Use version control (git) in all project directories for safety"
    "productivity:Batch similar tasks together to reduce context switching"
    "productivity:Review your PathWise insights weekly to optimize your workflow"
    "productivity:Set up project templates to standardize new project creation"
    "productivity:Use meaningful commit messages - they're documentation for future you"
    "productivity:Take breaks - productivity isn't about time spent but work accomplished"
    "productivity:Document your setup and workflows in a personal knowledge base"
    "productivity:Automate repetitive tasks with shell scripts or aliases"
    "productivity:Use virtual environments for Python projects to avoid conflicts"
    "productivity:Keep a 'notes.md' file in project roots for quick thoughts"
    "productivity:Learn keyboard shortcuts for your most-used applications"
    "git:Use 'git status' frequently to understand your repository state"
    "git:Run 'git diff --staged' to review changes before committing"
    "git:Use 'git log --oneline --graph' for a visual commit history"
    "git:Create meaningful branch names: feature/what-it-does"
    "git:Use 'git stash' to temporarily save work when switching contexts"
    "git:Run 'git commit --amend' to fix the last commit message"
    "git:Use 'git reset HEAD~1' to undo the last commit (keeping changes)"
    "git:Set up git aliases: 'git config --global alias.co checkout'"
    "git:Use 'git blame <file>' to see who changed each line and when"
    "git:Run 'git clean -fd' to remove untracked files and directories"
    "git:Use '.gitignore' to exclude files from version control"
    "git:Create atomic commits - each commit should do one thing"
    "git:Use 'git bisect' to find which commit introduced a bug"
    "git:Run 'git reflog' to recover lost commits or branches"
    "git:Tag releases: 'git tag -a v1.0.0 -m \"Version 1.0.0\"'"
    "advanced:Use process substitution: 'diff <(ls dir1) <(ls dir2)'"
    "advanced:Chain commands: '&&' for success, '||' for failure, ';' for always"
    "advanced:Use brace expansion: 'cp file.{txt,bak}' copies file.txt to file.bak"
    "advanced:Export functions in zsh: 'typeset -f -x function_name'"
    "advanced:Use 'exec' to replace the current shell with a command"
    "advanced:Create here-documents: 'cat << EOF > file.txt'"
    "advanced:Use extended globbing: 'setopt EXTENDED_GLOB' for advanced patterns"
    "advanced:Redirect stdout and stderr separately: 'cmd 1>out.txt 2>err.txt'"
    "advanced:Use coprocesses for bidirectional communication with commands"
    "advanced:Set up zsh hooks: add_zsh_hook for preexec, precmd, chpwd"
    "advanced:Use parameter expansion for string manipulation: \${var%suffix}"
    "advanced:Create associative arrays: 'typeset -A hash' in zsh"
    "advanced:Use 'zmodload' to load additional zsh modules for extra features"
    "advanced:Profile shell startup: 'zsh -x' to debug slow initialization"
    "advanced:Use 'compdef' to create custom completions for your functions"
)


# Function to get a random tip with category
_freq_dirs_get_random_tip() {
    local num_tips=${#PATHWISE_TIPS[@]}
    # Seed RANDOM with current time for better randomization  
    RANDOM=$SECONDS
    # Zsh arrays are 1-indexed
    local random_index=$((RANDOM % num_tips + 1))
    local tip_with_category="${PATHWISE_TIPS[$random_index]}"
    
    # Split category and tip
    local category="${tip_with_category%%:*}"
    local tip="${tip_with_category#*:}"
    
    # Capitalize and format category name
    case "$category" in
        pathwise) category="PathWise" ;;
        zsh) category="Zsh" ;;
        linux) category="Linux" ;;
        productivity) category="Productivity" ;;
        git) category="Git" ;;
        advanced) category="Advanced" ;;
        *) category="${(C)category}" ;;  # Capitalize first letter
    esac
    
    echo "${category} Tip: ${tip}"
}
# Main wfreq function with argument parsing
wfreq() {
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
        --tools|-t)
            echo ""
            _freq_dirs_analyze_tools_multi
            echo ""
            return
            ;;
        --export|-e)
            shift  # Move past --export
            _freq_dirs_export_toml "$@"
            return
            ;;
        --config|-c)
            echo ""
            printf "\033[36m⚙️  PathWise Configuration\033[0m\n"
            printf "\033[90m────────────────────────────────────\033[0m\n"
            echo ""
            printf "\033[93mCurrent settings:\033[0m\n"
            
            # Color code the values based on their state
            if [[ "${FREQ_AUTO_RESET}" == "true" ]]; then
                printf "  Auto-reset: \033[92menabled\033[0m\n"
            else
                printf "  Auto-reset: \033[91mdisabled\033[0m\n"
            fi
            
            printf "  Reset hour: \033[93m${FREQ_RESET_HOUR}:00\033[0m\n"
            printf "  Show count: \033[94m${FREQ_SHOW_COUNT}\033[0m directories\n"
            
            if [[ "${FREQ_TRACK_TIME}" == "true" ]]; then
                printf "  Track time: \033[92menabled\033[0m\n"
            else
                printf "  Track time: \033[91mdisabled\033[0m\n"
            fi
            
            printf "  Min time: \033[94m${FREQ_MIN_TIME}\033[0m seconds\n"
            
            if [[ "${FREQ_TRACK_GIT}" == "true" ]]; then
                printf "  Track git: \033[92menabled\033[0m\n"
            else
                printf "  Track git: \033[91mdisabled\033[0m\n"
            fi
            
            if [[ "${FREQ_TRACK_TOOLS}" == "true" ]]; then
                printf "  Track tools: \033[92menabled\033[0m\n"
            else
                printf "  Track tools: \033[91mdisabled\033[0m\n"
            fi
            
            printf "  Sort by: \033[95m${FREQ_SORT_BY}\033[0m\n"
            echo ""
            printf "\033[36mConfigure:\033[0m\n"
            
            # Auto-reset configuration
            printf "\033[96m  Enable auto-reset?\033[0m (y/n) \033[90m[${FREQ_AUTO_RESET}]\033[0m\n"
            printf "  \033[90m→ Options: y=enable daily reset, n=keep data forever, Enter=no change\033[0m\n"
            printf "  \033[96m>\033[0m "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_AUTO_RESET="true"
                else
                    FREQ_AUTO_RESET="false"
                fi
            fi
            echo ""
            
            if [[ "$FREQ_AUTO_RESET" == "true" ]]; then
                printf "\033[96m  Reset hour\033[0m (0-23) \033[90m[${FREQ_RESET_HOUR}]\033[0m\n"
                printf "  \033[90m→ Options: 0=midnight, 12=noon, 23=11pm, Enter=no change\033[0m\n"
                printf "  \033[96m>\033[0m "
                read response
                if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 0 ]] && [[ "$response" -le 23 ]]; then
                    FREQ_RESET_HOUR="$response"
                fi
                echo ""
            fi
            
            printf "\033[96m  Number of directories to show\033[0m (1-10) \033[90m[${FREQ_SHOW_COUNT}]\033[0m\n"
            printf "  \033[90m→ Options: 1-10 directories, Enter=no change\033[0m\n"
            printf "  \033[96m>\033[0m "
            read response
            if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 1 ]] && [[ "$response" -le 10 ]]; then
                FREQ_SHOW_COUNT="$response"
            fi
            echo ""
            
            printf "\033[96m  Enable time tracking?\033[0m (y/n) \033[90m[${FREQ_TRACK_TIME}]\033[0m\n"
            printf "  \033[90m→ Options: y=track time spent, n=only track visits, Enter=no change\033[0m\n"
            printf "  \033[96m>\033[0m "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_TIME="true"
                else
                    FREQ_TRACK_TIME="false"
                fi
            fi
            echo ""
            
            if [[ "$FREQ_TRACK_TIME" == "true" ]]; then
                printf "\033[96m  Minimum time to track\033[0m (seconds) \033[90m[${FREQ_MIN_TIME}]\033[0m\n"
                printf "  \033[90m→ Options: 0=track all, 5=default, 60=only 1min+, Enter=no change\033[0m\n"
                printf "  \033[96m>\033[0m "
                read response
                if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]]; then
                    FREQ_MIN_TIME="$response"
                fi
                echo ""
            fi
            
            printf "\033[96m  Enable git tracking?\033[0m (y/n) \033[90m[${FREQ_TRACK_GIT}]\033[0m\n"
            printf "  \033[90m→ Options: y=track git commits, n=disable git features, Enter=no change\033[0m\n"
            printf "  \033[96m>\033[0m "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_GIT="true"
                else
                    FREQ_TRACK_GIT="false"
                fi
            fi
            echo ""
            
            printf "\033[96m  Enable tool tracking?\033[0m (y/n) \033[90m[${FREQ_TRACK_TOOLS}]\033[0m\n"
            printf "  \033[90m→ Options: y=track tool usage, n=disable tool tracking, Enter=no change\033[0m\n"
            printf "  \033[96m>\033[0m "
            read response
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_TOOLS="true"
                else
                    FREQ_TRACK_TOOLS="false"
                fi
            fi
            echo ""
            
            printf "\033[96m  Sort by\033[0m (visits/time/commits) \033[90m[${FREQ_SORT_BY}]\033[0m\n"
            printf "  \033[90m→ Options: visits=most visited, time=longest time, commits=most commits, Enter=no change\033[0m\n"
            printf "  \033[96m>\033[0m "
            read response
            if [[ -n "$response" ]] && [[ "$response" == "visits" || "$response" == "time" || "$response" == "commits" ]]; then
                FREQ_SORT_BY="$response"
            fi
            echo ""
            
            _freq_dirs_save_config
            echo ""
            printf "\033[92m✅ Configuration saved!\033[0m\n"
            return
            ;;
        --help|-h)
            echo "PathWise - Be Wise About Your Paths 🗺️"
            echo ""
            echo "Usage:"
            echo "  wfreq                              Show top directories"
            echo "  wfreq --insights                   Show productivity insights"
            echo "  wfreq --tools                      Show tool usage per directory"
            echo "  wfreq --export [path] [-filter=x]  Export data to TOML"
            echo "  wfreq --reset                      Reset all frequency data"
            echo "  wfreq --config                     Configure settings"
            echo "  wfreq --help                       Show this help"
            echo ""
            echo "Export examples:"
            echo "  wfreq --export                     Export all to ./pathwise_export.toml"
            echo "  wfreq --export ~/team/             Export to ~/team/ directory"
            echo "  wfreq --export -filter=.           Export only current directory"
            echo "  wfreq --export -filter=python      Export dirs containing 'python'"
            echo ""
            echo "Jump shortcuts:"
            echo "  wj1-wj${FREQ_SHOW_COUNT}                         Jump to your top directories"
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
    echo "PathWise Directory Frequency:"
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
            git_display="[$git_count commits]"
        fi
        
        # Two-line format for better readability
        printf "  [36m[wj%d][0m %s
" "$i" "$display_dir"
        
        if [[ "$period" == "yesterday" ]]; then
            if [[ -n "$git_display" ]]; then
                printf "      ├─ [90m%d visits%s yesterday[0m [93m%s[0m
"                     "$count" "$time_display" "$git_display"
            else
                printf "      ├─ [90m%d visits%s yesterday[0m
"                     "$count" "$time_display"
            fi
        else
            # Color based on activity score (visits * time)
            local activity_score=$((count * time / 60))  # visits * minutes
            local visits_color=""
            local time_color=""
            
            # Color for visits count
            if [[ $count -gt 10 ]]; then
                visits_color="[91m"  # Bright red for very frequent
            elif [[ $count -gt 5 ]]; then
                visits_color="[33m"  # Yellow for frequent
            elif [[ $count -gt 2 ]]; then
                visits_color="[92m"  # Bright green for moderate
            else
                visits_color="[36m"  # Cyan for low
            fi
            
            # Color for time
            if [[ $time -gt 3600 ]]; then
                time_color="[31m"  # Red for > 1 hour
            elif [[ $time -gt 1800 ]]; then
                time_color="[91m"  # Bright red for > 30 min
            elif [[ $time -gt 600 ]]; then
                time_color="[93m"  # Bright yellow for > 10 min
            else
                time_color="[92m"  # Green for < 10 min
            fi
            
            if [[ -n "$git_display" ]]; then
                printf "      ├─ %s%d visits[0m · %s%s[0m today [38;5;220m%s[0m
"                     "$visits_color" "$count" "$time_color" "$(_freq_dirs_format_time $time)" "$git_display"
            else
                printf "      ├─ %s%d visits[0m · %s%s[0m today
"                     "$visits_color" "$count" "$time_color" "$(_freq_dirs_format_time $time)"
            fi
        fi
        
        # Create the jump alias dynamically
        eval "alias wj${i}='cd \"${dir/#\~/$HOME}\"'"
        
        i=$((i + 1))
    done <<< "$merged_data"
    
    echo ""
    echo "💡 Commands: wfreq | wfreq --insights | wfreq --config"
    echo ""
    
    # Display a random tip
    local tip=$(_freq_dirs_get_random_tip)
    echo "💭 $tip"
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
        eval "alias wj${i}='cd \"${dir/#\~/$HOME}\"'"
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

# Load config first to check if tool tracking is enabled
_freq_dirs_load_config

# Hook to track tool usage
if [[ "$FREQ_TRACK_TOOLS" == "true" ]]; then
    add-zsh-hook preexec _freq_dirs_track_tool
fi

# Create git alias to track commits
alias git='_freq_dirs_git_wrapper'

# Setup aliases on startup
_freq_dirs_setup_aliases

# Initialize session tracking
FREQ_SESSION_START=$(date +%s)

# Startup display is handled in .zshrc for priority visibility
