---
name: create-issue
description: Create a new Linear issue using the Linear MCP
---

# Create Linear Issue

This command creates a new Linear issue using the Linear MCP (Model Context Protocol) integration.

## Prerequisites

Ensure the Linear MCP is properly configured and available. The MCP tool should be accessible as `mcp_linear_create_issue` or similar.

## Configuration

You can set default values for team, labels, and status as needed when calling the MCP tool.

## Usage

Use the Linear MCP tool to create issues directly. The tool accepts the following parameters:

- `title` (required): The issue title
- `description` (optional): Detailed description of the issue
- `teamId` or `teamName` (optional): The team to assign the issue to
- `labelIds` or `labelNames` (optional): Array of labels to apply
- `stateId` or `stateName` (optional): The workflow state/status
- `priority` (optional): Priority level (0=None, 1=Urgent, 2=High, 3=Normal, 4=Low)
- `assigneeId` (optional): User ID to assign the issue to

### Example MCP Tool Call

```
mcp_linear_create_issue({
  "title": "Fix authentication bug",
  "description": "Users are unable to login with SSO when using Firefox",
  "teamName": "Engineering",
  "labelNames": ["bug", "authentication"],
  "stateName": "Backlog",
  "priority": 2
})
```

## Examples

### Basic Issue
```
mcp_linear_create_issue({
  "title": "Fix authentication bug"
})
```

### Issue with Description
```
mcp_linear_create_issue({
  "title": "Fix authentication bug",
  "description": "Users unable to login with SSO in Firefox browser"
})
```

### Issue with Team and Status
```
mcp_linear_create_issue({
  "title": "Update API documentation",
  "description": "Add new endpoints for v2 API",
  "teamName": "Documentation",
  "stateName": "In Progress"
})
```

### Issue with Labels and Priority
```
mcp_linear_create_issue({
  "title": "Database migration",
  "description": "Upgrade to PostgreSQL 15",
  "teamName": "Backend",
  "labelNames": ["database", "migration", "high-priority"],
  "stateName": "Todo",
  "priority": 2
})
```

## Requirements

- Linear MCP must be installed and configured
- Valid Linear API access token
- Team and label names must match exactly as they appear in Linear

## Tips

- Use the Linear MCP query tools to:
  - List available teams: `mcp_linear_list_teams()`
  - List available labels: `mcp_linear_list_labels()`
  - List workflow states: `mcp_linear_list_states()`
- Consider creating wrapper functions for frequently used issue templates
- The MCP handles authentication automatically once configured
