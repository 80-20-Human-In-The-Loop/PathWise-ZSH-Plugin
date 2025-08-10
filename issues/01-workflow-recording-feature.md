# Issue #01: Workflow Recording Feature

## Feature Request: Command Sequence Recording and Replay (`wrec`)

### Overview

The workflow recording feature introduces a powerful capability to PathWise that allows users to record, save, and replay complex navigation and command sequences. This feature addresses the common scenario where developers repeatedly execute the same series of directory changes and commands throughout their workday, such as starting development servers, checking logs, or navigating through project structures. By capturing these workflows once and replaying them on demand, users can eliminate repetitive typing, reduce context-switching overhead, and maintain consistency in their development environment setup. The feature will integrate seamlessly with PathWise's existing directory tracking infrastructure while adding a new dimension of command awareness and workflow automation.

### Implementation Details

The recording mechanism will leverage PathWise's existing session tracking infrastructure to capture not just directory changes but also the commands executed within each directory. When a user initiates recording with `wrec --start "workflow-name"`, PathWise will begin logging all directory navigation events and shell commands to a temporary buffer, associating each command with its execution directory and timestamp. The system will intelligently filter out sensitive commands containing passwords or tokens, and will handle both successful and failed command executions. Upon stopping the recording with `wrec --stop`, the workflow will be validated, optimized to remove redundant operations, and stored in a dedicated workflow file within the PathWise data directory, making it available for future replay operations.

### User Experience

The user interface for workflow recording prioritizes simplicity and transparency, providing clear feedback at each stage of the recording process. When recording begins, PathWise will display a subtle indicator in the prompt or status line showing that recording is active, along with the workflow name and elapsed time. During recording, users can execute their normal workflow naturally without any special syntax or modifications. The system will provide real-time feedback for each captured action, confirming what has been recorded without being intrusive. When replaying a workflow with `wrec --replay "workflow-name"`, PathWise will display each step before execution, allowing users to skip or modify steps if needed, ensuring that automated replay remains under user control.

### Integration and Compatibility

The workflow recording feature will integrate deeply with PathWise's existing features while maintaining backward compatibility and shell agnosticism. Recorded workflows will be stored in a portable JSON format that can be shared across machines and teams, enabling collaborative workflow optimization. The feature will respect PathWise's configuration settings, including time tracking and git integration preferences. Additionally, workflows will be tagged with metadata such as creation date, last used date, and execution statistics, allowing PathWise to suggest frequently used workflows and identify optimization opportunities. The system will also provide migration tools to convert existing shell scripts and aliases into PathWise workflows, making adoption seamless for users with established automation practices.

## Shell Script Examples

### Part 1: Basic Recording Operations
```bash
#!/bin/bash
# Start recording a morning routine workflow
wrec --start "morning-setup"

# Perform your typical morning setup
cd ~/projects/frontend
npm start &

cd ~/projects/backend
docker-compose up -d

cd ~/projects/logs
tail -f application.log &

# Stop recording and save the workflow
wrec --stop

# List all recorded workflows
wrec --list
# Output:
# morning-setup    (4 steps, recorded today)
# test-suite       (7 steps, recorded yesterday)
# deploy-prod      (12 steps, recorded last week)
```

### Part 2: Replay and Management
```bash
#!/bin/bash
# Replay a saved workflow
wrec --replay "morning-setup"
# Output:
# Replaying workflow 'morning-setup' (4 steps)...
# [1/4] cd ~/projects/frontend ✓
# [2/4] npm start & ✓
# [3/4] cd ~/projects/backend ✓
# [4/4] docker-compose up -d ✓
# Workflow completed successfully!

# Preview a workflow without executing
wrec --preview "morning-setup"

# Edit a workflow to modify commands
wrec --edit "morning-setup"

# Delete a workflow
wrec --delete "old-workflow"

# Export workflow for sharing
wrec --export "morning-setup" > morning-setup.json
```

### Part 3: Advanced Recording Features
```bash
#!/bin/bash
# Record with annotations and breakpoints
wrec --start "complex-deploy" --verbose

echo "[[ANNOTATION]] Starting database backup"
pg_dump production > backup.sql

echo "[[BREAKPOINT]] Confirm before proceeding"
cd ~/deploy

echo "[[ANNOTATION]] Running deployment script"
./deploy.sh --production

wrec --stop

# Replay with interactive breakpoints
wrec --replay "complex-deploy" --interactive
# Will pause at [[BREAKPOINT]] markers for user confirmation

# Record with variable substitution
wrec --start "feature-branch" --with-vars
cd ~/projects/app
git checkout -b $BRANCH_NAME  # Will prompt for BRANCH_NAME on replay
npm test
git commit -am "$COMMIT_MSG"  # Will prompt for COMMIT_MSG on replay
wrec --stop
```

### Part 4: Workflow Analytics and Optimization
```bash
#!/bin/bash
# Show workflow statistics
wrec --stats "morning-setup"
# Output:
# Workflow: morning-setup
# Times executed: 45
# Average duration: 2m 34s
# Last executed: 2 hours ago
# Success rate: 95%
# Most time spent: npm start (1m 20s average)

# Optimize a workflow by removing redundant steps
wrec --optimize "morning-setup"
# Output:
# Analyzing workflow...
# Found 2 redundant cd commands
# Merged 3 sequential git operations
# Optimized workflow saved (reduced from 12 to 8 steps)

# Create workflow from history
wrec --from-history 50
# Analyzes last 50 commands and suggests workflow patterns

# Schedule workflow execution
wrec --schedule "morning-setup" --at "09:00" --weekdays
# Automatically runs workflow at 9 AM on weekdays
```

## Expected Behavior

- Recording captures all navigation and commands in sequence
- Workflows are stored persistently and survive shell restarts  
- Replay executes commands in original directories
- Failed commands during replay can be skipped or retried
- Sensitive information is automatically redacted
- Workflows can be versioned and rolled back
- Performance impact during recording is negligible
- Integration with existing PathWise jumping shortcuts

## Success Criteria

- Users can record and replay workflows with 2 commands
- Workflows execute 10x faster than manual navigation
- 90% of daily repetitive tasks can be automated
- Workflow sharing increases team productivity by 25%
- Recording adds less than 50ms latency to commands