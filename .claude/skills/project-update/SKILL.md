---
name: project-update
description: Generate Linear project updates with weekly progress, next steps, and risks
---

# Project Update Skill

Generate concise project status updates for Linear projects. Updates summarize recent progress, upcoming work, and blockers/risks in a consistent format suitable for stakeholder communication.

## Invocation

```
/project-update <linear-project-url-or-name>
```

## Workflow

1. **Fetch project context** using Linear MCP:
   - Get project details (`mcp__linear__get_project`)
   - List recent issues updated in the last 7 days (`mcp__linear__list_issues` with `updatedAt: -P7D`)

2. **Analyze project state**:
   - Identify completed work (issues moved to Done)
   - Identify in-progress work
   - Check project milestones and target dates
   - Note any blocked or canceled items

3. **Generate update** following the template below

## Template

```markdown
<quick blurb - 1-2 sentences summarizing current state and momentum>

**This Week**
- <bullet list of what was accomplished>
- <reference specific issues/PRs where relevant>

**Next Week**
- <bullet list of planned focus areas>
- <reference specific issues where relevant>

**Risks/Asks**
- <bullet list of blockers, dependencies, timeline concerns>
- <requests for help or decisions needed>
```

## Style Guidelines

- **Tone**: Professional, direct. Write for engineering leadership and stakeholders.
- **Length**: Brief. 5-10 bullets total across all sections.
- **Quick blurb**: One sentence on what phase/state the project is in. One sentence on momentum or key highlight.
- **This Week**: Focus on outcomes, not activity. "Completed X" not "Worked on X".
- **Next Week**: Be specific about deliverables. Reference issue IDs when helpful.
- **Risks/Asks**: Be honest about timeline slips, blockers, and what you need.

## Section Guidelines

### Quick Blurb

Provide immediate context:
- What phase is the project in? (Discovery, Implementation, Testing, Launch)
- Is it on track, ahead, or behind?
- What's the one thing someone should know?

Examples:
> Wrapping up Phase 1 (MMP) foundation work. Core UI scaffolding complete; now connecting frontend to live agent execution.

> Project unblocked and ready to pick up. This is the write-path companion to Agent in the Loop.

### This Week

Focus on completed deliverables:
- What shipped or merged?
- What milestones were hit?
- What decisions were made?

Reference PRs and issues when they add context:
> - Completed Assistant panel scoping: only shows on Business pages, threads tied to business context
> - Started integration work to trigger address researcher (2 PRs open: app#4711, op#152)

### Next Week

Be specific and actionable:
- What issues will be worked on?
- What milestone are you targeting?
- What's the definition of done for the week?

Example:
> - Complete EGX-1599: Trigger agent from status indicator (Demo Ready milestone)
> - Begin artifact cards with evidence quality badges (EGX-1602)
> - Target internal demo by end of week

### Risks/Asks

Be direct about problems:
- Timeline slips: "Phase 1 target was Jan 2; slipping ~1 week due to holiday timing"
- Blockers: "Blocked on API changes from Platform team"
- Dependencies: "Need design review before proceeding with UI work"
- Decisions needed: "Open question: show all parallel tool calls or summarize?"
- Requests: "Need 30min with [person] to align on [topic]"

## Examples

### Active Development Update

```markdown
Wrapping up Phase 1 (MMP) foundation work. Core UI scaffolding complete; now connecting frontend to live agent execution.

**This Week**
- Completed Assistant panel scoping: only shows on Business pages, threads tied to business context
- Added Agent status indicator to Insights section
- Implemented feature flag controls for Composer/Nav visibility
- Started integration work to trigger address researcher (2 PRs open: app#4711, op#152)

**Next Week**
- Complete EGX-1599: Trigger agent from status indicator (Demo Ready milestone)
- EGX-1601: Display address research results in sidepanel with real-time progress
- Begin artifact cards with evidence quality badges (EGX-1602)
- Target internal demo by end of week

**Risks/Asks**
- Phase 1 target was Jan 2; slipping ~1 week due to holiday timing
- Need to validate SSE reconnection behavior under poor network conditions before pilot
- Open question: granularity of tool call visibility in UI (show all parallel searches or summarize?)
```

### Ready to Start Update

```markdown
Actions workstream is unblocked and ready to pick up. This is the write-path companion to Agent in the Loop.

**This Week**
- Project scoped and moved to Ready status
- EGX-1581 spike on sourcing attributes from agents is in progress
- Figma explorations available for reference/iteration

**Next Week**
- Continue EGX-1581 spike: define API surface for agent actions
- Design human approval/rejection flow for agent-suggested changes
- Coordinate with Agent in the Loop on artifact card integration (EGX-1603)

**Risks/Asks**
- Target date is Jan 9; tight timeline given holiday ramp-up
- Dependency on Agent in the Loop frontend work for surfacing actions
- Need to align on whether actions use existing GraphQL mutations or new endpoints
```

### Blocked/Paused Update

```markdown
Project paused pending resolution of upstream dependency. No active development this sprint.

**This Week**
- Identified blocker: API schema changes required from Platform team
- Documented requirements and shared with Platform lead
- Moved in-progress issues back to backlog

**Next Week**
- Await Platform team's schema changes (ETA: Jan 15)
- Use time to refine technical spec and test plan
- Can resume development once API is available

**Risks/Asks**
- Blocked on ENG-1234 from Platform team
- Timeline at risk if Platform work slips past Jan 15
- Ask: Can we get priority bump on ENG-1234?
```
