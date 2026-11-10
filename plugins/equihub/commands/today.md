---
description: Show what is planned in Equihub today — calendar, tasks and health
allowed-tools: mcp__plugin_equihub_equihub__searchCalendar, mcp__plugin_equihub_equihub__searchPlannedTask, mcp__plugin_equihub_equihub__searchPlannedGeneralTask, mcp__plugin_equihub_equihub__getHealthOverview
---

Give me an overview of everything planned in Equihub for today. Today is !`date +%Y-%m-%d` (!`date +%A`).

Call these Equihub MCP tools in parallel, all scoped to today's date:

1. **Calendar** — `searchCalendar` with `startDate` = today at `T00:00:00`, `endDate` = today at `T23:59:59` and `categories` = `["EVENT", "BREEDING_ACTIVITY"]` (health comes from step 4).
2. **Horse tasks** — `searchPlannedTask` with `from` and `to` = today (yyyy-MM-dd).
3. **General tasks** — `searchPlannedGeneralTask` with `from` and `to` = today.
4. **Health** — `getHealthOverview` with no filters. Use its `today` list, and its `overdue` list for the overdue section.

If a call fails (for example a missing HEALTH or BREEDING permission), say so in one line under that section and continue with the others.

Present the result in this order, with times where available and horse names (never UUIDs):

## Today — <weekday> <date>

### Calendar
Events and appointments sorted by start time: time, title, type, location, horses. All-day items first.

### Tasks
Horse tasks grouped by task name, listing the horses for each and marking those already CLOSED as done. Then general tasks with their assignees. Show how many are open versus done.

### Health
Health reminders due today: type, horses, contact. Then a short **Overdue** list if `overdue` is not empty.

When a section has nothing, write "Nothing planned." End with one line that calls out what most needs attention (overdue care, a busy time slot, open tasks). $ARGUMENTS
