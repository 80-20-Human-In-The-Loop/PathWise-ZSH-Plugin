# Issue #03: Cumulative Frequency Sorting for More Intuitive Directory Rankings

## Problem Statement: Current Sorting Prioritizes Recency Over Frequency

### Overview

The current PathWise frequency sorting algorithm heavily favors directories visited TODAY, causing counterintuitive behavior where a directory visited once today appears at the top of the list, displacing directories that were heavily used yesterday. This creates an unstable and unpredictable experience where users lose quick access to their most frequently used directories simply because a new day has started. The issue becomes particularly problematic on Monday mornings when Friday's heavily-used work directories disappear from quick access, replaced by the first directory visited that day. This behavior contradicts the core purpose of frequency-based navigation, which should provide stable, predictable access to genuinely frequently-used directories based on accumulated usage patterns, not just the most recent activity.

### Current Behavior Analysis

The existing implementation uses a priority-weight system that always places today's directories above yesterday's, regardless of actual usage frequency. When sorting the merged data, today's entries receive a weight of 2 while yesterday's receive a weight of 1, causing the sort to first group by day, then by frequency within each day. This means a directory with 1 visit today ranks higher than a directory with 100 visits yesterday. The problem is compounded by the display limit, where showing only the top 5-10 directories means yesterday's heavily-used directories may not appear at all if the user has visited that many directories today, even briefly. This approach fails to recognize that directory usage patterns are often consistent across days, and users expect their muscle memory shortcuts (wj1, wj2, etc.) to remain relatively stable.

### User Feedback

Based on user discussions, the current behavior is confusing and reduces productivity:
- "Rather than over-riding with today's data, it should add up yesterday's and today's data, and sort it by the sum rather than just today"
- "You need to go to a dir 5 times or so to get it to be at the top of the list" - this would provide more stability
- "I think you just need to be a little more strict on when you reorder" - highlighting the need for less volatile rankings
- Users expect frequently-used directories to maintain their positions unless genuinely overtaken by more frequent usage

## Proposed Solution: Cumulative Frequency Calculation

### Implementation Strategy

The solution involves modifying the `_freq_dirs_get_merged_data` function to combine metrics from today and yesterday into cumulative totals before sorting. Instead of maintaining separate entries for today and yesterday with priority weights, the system will:

1. **Aggregate Data**: Sum the visit counts, time spent, and git commits for directories that appear in both today's and yesterday's data
2. **Unified Sorting**: Sort the combined data by total metrics (visits, time, or commits based on configuration)
3. **Stability Threshold**: Require a minimum number of visits or time spent before a directory can displace existing top entries
4. **Decay Factor** (Optional): Apply a slight decay to yesterday's data (e.g., 0.8x weight) to give some preference to recent activity without completely overriding historical patterns

### Technical Implementation Details

The merge algorithm will be restructured to:
```bash
# Pseudocode for new merging approach
for each directory in (today + yesterday):
    cumulative_visits = today_visits + yesterday_visits
    cumulative_time = today_time + yesterday_time
    cumulative_commits = today_commits + yesterday_commits
    
    # Optional: Apply decay factor to yesterday's data
    if FREQ_DECAY_FACTOR is set:
        cumulative_visits += yesterday_visits * FREQ_DECAY_FACTOR
        cumulative_time += yesterday_time * FREQ_DECAY_FACTOR
    
    # Store with period indicator for display
    if directory exists in both:
        period = "combined"
    elif directory exists in today only:
        period = "today"
    else:
        period = "yesterday"
```

### Configuration Options

New configuration variables will be introduced:
- `FREQ_COMBINE_DAYS`: Boolean to enable/disable cumulative sorting (default: true)
- `FREQ_DECAY_FACTOR`: Float between 0-1 for yesterday's weight (default: 1.0 for equal weight)
- `FREQ_MIN_VISITS_FOR_TOP`: Minimum visits required to appear in top 3 (default: 3)
- `FREQ_STABILITY_MODE`: When enabled, requires 2x the visits to displace an existing entry

## Shell Script Examples

### Example 1: Basic Cumulative Behavior
```bash
#!/bin/bash
# Day 1 (Friday) - Heavy usage
cd ~/projects/backend   # 50 visits, 2 hours
cd ~/projects/frontend  # 40 visits, 1.5 hours  
cd ~/projects/docs      # 30 visits, 1 hour
cd ~/temp               # 2 visits, 5 minutes

# Day 2 (Monday) - Light morning usage
cd ~/downloads          # 1 visit, 2 minutes
cd ~/projects/backend   # 2 visits, 10 minutes

# Current behavior (problematic):
wfreq
# [wj1] ~/downloads        (today: 1 visit)     <-- Wrong! 
# [wj2] ~/projects/backend (today: 2 visits)
# [wj3] ~/projects/frontend (yesterday: 40 visits)
# [wj4] ~/projects/docs     (yesterday: 30 visits)

# New behavior (cumulative):
wfreq
# [wj1] ~/projects/backend  (52 total visits)   <-- Correct!
# [wj2] ~/projects/frontend (40 total visits)
# [wj3] ~/projects/docs     (30 total visits)
# [wj4] ~/temp              (2 total visits)
# [wj5] ~/downloads         (1 total visit)
```

### Example 2: Stability Threshold
```bash
#!/bin/bash
# Configure minimum visits for top positions
wfreq --config
# Set FREQ_MIN_VISITS_FOR_TOP=5

# Existing top directories from accumulated usage
# ~/projects/api     (45 total visits)
# ~/projects/web     (38 total visits)
# ~/projects/mobile  (32 total visits)

# New directory visited today
cd ~/experiments  # 3 visits

wfreq
# ~/experiments doesn't appear in top 3 due to threshold
# [wj1] ~/projects/api     (45 total visits)
# [wj2] ~/projects/web     (38 total visits)  
# [wj3] ~/projects/mobile  (32 total visits)
# [wj4] ~/experiments      (3 total visits)  <-- Ranked 4th

# After more visits
cd ~/experiments  # 3 more visits (6 total)

wfreq  
# Now meets threshold and ranks by total
# [wj1] ~/projects/api     (45 total visits)
# [wj2] ~/projects/web     (38 total visits)
# [wj3] ~/projects/mobile  (32 total visits)
# [wj4] ~/experiments      (6 total visits)   <-- Still 4th but eligible
```

### Example 3: Time-Based Sorting with Cumulative
```bash
#!/bin/bash
# Configure to sort by time spent
wfreq --config
# Set FREQ_SORT_BY=time
# Set FREQ_COMBINE_DAYS=true

# Historical usage
# Yesterday:
#   ~/projects/backend  (3 hours total)
#   ~/projects/frontend (2 hours total)
#   ~/documents        (30 minutes total)

# Today:
#   ~/downloads        (5 minutes)
#   ~/projects/backend (30 minutes)

wfreq
# Sorted by cumulative time:
# [wj1] ~/projects/backend  (3.5 hours total)
# [wj2] ~/projects/frontend (2 hours total)
# [wj3] ~/documents         (30 minutes total)
# [wj4] ~/downloads         (5 minutes total)

# The ranking remains stable and predictable
```

### Example 4: Decay Factor Configuration
```bash
#!/bin/bash
# Configure decay factor for gradual transition
wfreq --config
# Set FREQ_DECAY_FACTOR=0.8

# Yesterday's heavy usage
# ~/old-project  (100 visits yesterday)

# Today's moderate usage  
# ~/new-project  (15 visits today)

# Calculation with decay:
# ~/old-project:  0 today + (100 * 0.8) yesterday = 80 effective visits
# ~/new-project:  15 today + 0 yesterday = 15 effective visits

wfreq
# [wj1] ~/old-project  (80 effective visits)
# [wj2] ~/new-project  (15 effective visits)

# After several more days without visiting ~/old-project
# it gradually decreases in rank as decay compounds
```

## Expected Behavior

- Directory rankings remain stable across day boundaries
- A directory needs sustained usage to climb the rankings
- Quick visits to random directories don't disrupt established patterns
- The top 3-5 directories remain consistent for muscle memory
- Users can predict which wj[n] alias corresponds to which directory
- Rankings evolve gradually based on genuine usage changes
- Monday morning experience matches Friday afternoon expectations

## Success Criteria

- 90% reduction in ranking volatility across day boundaries
- Muscle memory aliases (wj1-wj5) remain 80% consistent day-to-day
- Users report improved predictability and satisfaction
- Directories require at least 3-5 visits to enter top 5 rankings
- Performance impact of cumulative calculation < 10ms
- Configuration options satisfy both stability and recency preferences
- Backward compatibility maintained with option to revert to old behavior

## Migration and Compatibility

- Existing data files remain unchanged
- Default behavior changes to cumulative (more intuitive)
- Users can opt-out via FREQ_COMBINE_DAYS=false
- First run after update shows notification about new behavior
- Documentation updated to explain ranking algorithm