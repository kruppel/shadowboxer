---
name: create-issue
description: Create a new Linear issue
---

# Create Linear Issue

This command creates a new Linear issue with configurable defaults for team, labels, and status.

## Configuration

Set these environment variables in your shell profile to customize defaults:
```bash
export LINEAR_DEFAULT_TEAM="Engineering"
export LINEAR_DEFAULT_LABELS="backend,needs-review"
export LINEAR_DEFAULT_STATUS="Backlog"
```

## Usage

```bash
#!/bin/bash

# Load defaults from environment or use fallbacks
TEAM="${LINEAR_DEFAULT_TEAM:-CTO}"
LABELS="${LINEAR_DEFAULT_LABELS:-}"
STATUS="${LINEAR_DEFAULT_STATUS:-Triage}"

# Parse command arguments
TITLE="$1"
DESCRIPTION="$2"
CUSTOM_TEAM="${3:-$TEAM}"
CUSTOM_LABELS="${4:-$LABELS}"
CUSTOM_STATUS="${5:-$STATUS}"

# Validate required fields
if [ -z "$TITLE" ]; then
    echo "Error: Title is required"
    echo "Usage: create-issue \"Title\" \"Description\" [Team] [Labels] [Status]"
    exit 1
fi

# Build Linear CLI command
LINEAR_CMD="linear issue create --title \"$TITLE\""

[ -n "$DESCRIPTION" ] && LINEAR_CMD="$LINEAR_CMD --description \"$DESCRIPTION\""
[ -n "$CUSTOM_TEAM" ] && LINEAR_CMD="$LINEAR_CMD --team \"$CUSTOM_TEAM\""
[ -n "$CUSTOM_STATUS" ] && LINEAR_CMD="$LINEAR_CMD --status \"$CUSTOM_STATUS\""

# Add labels if provided (comma-separated)
if [ -n "$CUSTOM_LABELS" ]; then
    IFS=',' read -ra LABEL_ARRAY <<< "$CUSTOM_LABELS"
    for label in "${LABEL_ARRAY[@]}"; do
        LINEAR_CMD="$LINEAR_CMD --label \"$(echo $label | xargs)\""
    done
fi

# Execute the command
echo "Creating Linear issue..."
eval $LINEAR_CMD
```

## Examples

### Basic usage with defaults
```bash
create-issue "Fix authentication bug"
```

### With description
```bash
create-issue "Fix authentication bug" "Users unable to login with SSO"
```

### Override team and status
```bash
create-issue "Update API docs" "Add new endpoints" "Documentation" "" "In Progress"
```

### With custom labels
```bash
create-issue "Database migration" "Upgrade to PostgreSQL 15" "Backend" "database,migration,high-priority" "Todo"
```

## Requirements

- Linear CLI must be installed: `npm install -g @linear/cli`
- Must be authenticated: `linear login`
- Team names must match exactly as they appear in Linear

## Tips

- View available teams: `linear team list`
- View available labels: `linear label list`
- View available statuses: `linear workflow list`
- Set up aliases in your shell for frequently used combinations