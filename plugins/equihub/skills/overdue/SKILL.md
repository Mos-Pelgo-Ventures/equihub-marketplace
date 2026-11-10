---
name: overdue
description: "List everything overdue in Equihub: late health care and tasks still open. Use when the user asks what is overdue, late, behind or still open at the stable."
allowed-tools: mcp__plugin_equihub_equihub__getHealthOverview, mcp__plugin_equihub_equihub__searchPlannedTask, mcp__plugin_equihub_equihub__searchPlannedGeneralTask
---

List everything that is overdue in Equihub. Use today's date and weekday. Look up overdue tasks over the last 30 days: from 30 days before today to yesterday.

Call these Equihub MCP tools in parallel:

1. **Health** — `getHealthOverview` with no filters. Use only its `overdue` list (it covers the past month).
2. **Horse tasks** — `searchPlannedTask` with `from` = 30 days ago and `to` = yesterday (yyyy-MM-dd), `pageSize` 100. There is no status filter: keep only horses whose status is OPEN.
3. **General tasks** — `searchPlannedGeneralTask` with the same `from` and `to`, `status` = `OPEN`, `pageSize` 100.

If a call fails (for example a missing HEALTH permission), say so in one line under that section and continue with the others.

Present the result with horse names (never UUIDs), oldest first:

## Overdue — <weekday> <date>

### Health care
Group by care type (vaccination, deworming, hoof care, dental care, other). For each: horses, the date it was due, how many days late, and the contact when there is one.

### Horse tasks
Each task with its date, how many days late, and the horses still open for it.

### General tasks
Each task with its due date, how many days late, and its assignees.

When a section has nothing, write "Nothing overdue." End with one line naming the most urgent item: the longest-overdue health care first, then anything more than a week late. Do not change any data. $ARGUMENTS
