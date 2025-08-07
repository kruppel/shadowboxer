---
name: open-pr
description: Open the current GitHub PR in browser
---

# Open PR

This command opens the current branch's pull request in your default web browser.

## Usage

```bash
gh pr view --web
```

## What it does

1. Detects the current git branch
2. Finds the associated GitHub pull request
3. Opens the PR page in your default browser

## Requirements

- GitHub CLI (gh) must be installed and authenticated
- Current directory must be a git repository
- Branch must have an associated pull request on GitHub