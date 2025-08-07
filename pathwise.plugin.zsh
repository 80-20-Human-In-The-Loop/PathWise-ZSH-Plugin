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
                if [[ -n "$prev_dir" ]]; then
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
            
            printf "  Sort by: \033[95m${FREQ_SORT_BY}\033[0m\n"
            echo ""
            printf "\033[36mConfigure:\033[0m\n"
            
            # Auto-reset configuration
            printf "\033[96m  Enable auto-reset?\033[0m (y/n) \033[90m[${FREQ_AUTO_RESET}]\033[0m: "
            read response
            printf "  \033[90m→ Options: y=enable daily reset, n=keep data forever, Enter=no change\033[0m\n"
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_AUTO_RESET="true"
                else
                    FREQ_AUTO_RESET="false"
                fi
            fi
            echo ""
            
            if [[ "$FREQ_AUTO_RESET" == "true" ]]; then
                printf "\033[96m  Reset hour\033[0m (0-23) \033[90m[${FREQ_RESET_HOUR}]\033[0m: "
                read response
                printf "  \033[90m→ Options: 0=midnight, 12=noon, 23=11pm, Enter=no change\033[0m\n"
                if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 0 ]] && [[ "$response" -le 23 ]]; then
                    FREQ_RESET_HOUR="$response"
                fi
                echo ""
            fi
            
            printf "\033[96m  Number of directories to show\033[0m (1-10) \033[90m[${FREQ_SHOW_COUNT}]\033[0m: "
            read response
            printf "  \033[90m→ Options: 1-10 directories, Enter=no change\033[0m\n"
            if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]] && [[ "$response" -ge 1 ]] && [[ "$response" -le 10 ]]; then
                FREQ_SHOW_COUNT="$response"
            fi
            echo ""
            
            printf "\033[96m  Enable time tracking?\033[0m (y/n) \033[90m[${FREQ_TRACK_TIME}]\033[0m: "
            read response
            printf "  \033[90m→ Options: y=track time spent, n=only track visits, Enter=no change\033[0m\n"
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_TIME="true"
                else
                    FREQ_TRACK_TIME="false"
                fi
            fi
            echo ""
            
            if [[ "$FREQ_TRACK_TIME" == "true" ]]; then
                printf "\033[96m  Minimum time to track\033[0m (seconds) \033[90m[${FREQ_MIN_TIME}]\033[0m: "
                read response
                printf "  \033[90m→ Options: 0=track all, 5=default, 60=only 1min+, Enter=no change\033[0m\n"
                if [[ -n "$response" ]] && [[ "$response" =~ ^[0-9]+$ ]]; then
                    FREQ_MIN_TIME="$response"
                fi
                echo ""
            fi
            
            printf "\033[96m  Enable git tracking?\033[0m (y/n) \033[90m[${FREQ_TRACK_GIT}]\033[0m: "
            read response
            printf "  \033[90m→ Options: y=track git commits, n=disable git features, Enter=no change\033[0m\n"
            if [[ -n "$response" ]]; then
                if [[ "$response" == "y" ]] || [[ "$response" == "Y" ]]; then
                    FREQ_TRACK_GIT="true"
                else
                    FREQ_TRACK_GIT="false"
                fi
            fi
            echo ""
            
            printf "\033[96m  Sort by\033[0m (visits/time/commits) \033[90m[${FREQ_SORT_BY}]\033[0m: "
            read response
            printf "  \033[90m→ Options: visits=most visited, time=longest time, commits=most commits, Enter=no change\033[0m\n"
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
                printf "  [36m[j%d][0m %-35s [90m(%d visits%s yesterday)[0m [93m%s[0m
"                     "$i" "$display_dir" "$count" "$time_display" "$git_display"
            else
                printf "  [36m[j%d][0m %-35s [90m(%d visits%s yesterday)[0m
"                     "$i" "$display_dir" "$count" "$time_display"
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
                printf "  [36m[j%d][0m %-35s (%s%d visits[0m · %s%s[0m today) [38;5;220m%s[0m
"                     "$i" "$display_dir" "$visits_color" "$count" "$time_color" "$(_freq_dirs_format_time $time)" "$git_display"
            else
                printf "  [36m[j%d][0m %-35s (%s%d visits[0m · %s%s[0m today)
"                     "$i" "$display_dir" "$visits_color" "$count" "$time_color" "$(_freq_dirs_format_time $time)"
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
