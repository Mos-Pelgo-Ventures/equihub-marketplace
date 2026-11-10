---
description: Mark planned tasks as done in Equihub
argument-hint: <task, and optionally horses, e.g. "feeding Bella and Max" or "all lunging">
allowed-tools: mcp__plugin_equihub_equihub__searchPlannedTask, mcp__plugin_equihub_equihub__searchPlannedGeneralTask, mcp__plugin_equihub_equihub__getRecord, mcp__plugin_equihub_equihub__updatePlannedTaskStatus, mcp__plugin_equihub_equihub__updatePlannedGeneralTask
---

Mark tasks as done in Equihub: **$ARGUMENTS**. Today is !`date +%Y-%m-%d`.

If nothing was given, list today's open tasks (step 1) and ask which ones are done.

**1. Find today's open tasks.** Call in parallel:

- `searchPlannedTask` with `from` and `to` = today, `pageSize` 100. Keep the horses whose status is OPEN.
- `searchPlannedGeneralTask` with `from` and `to` = today, `status` = `OPEN`, `pageSize` 100.

If the user named another day ("yesterday", a date), use that day instead.

**2. Match the request** to those tasks by task name (or abbreviation) and horse names (display name or registered name, case-insensitive).

- "all <task>" or a task without horses means every horse still open on that task.
- If a name matches more than one task or horse, or matches nothing, ask; do not guess.
- Tasks or horses that are already done: mention them, but do not change them.

**3. Confirm before writing.** Show the exact list that will be marked done:

> Mark as done on <date>:
> - Feeding — Bella, Max
> - Clean tack room (general task)

and ask the user to confirm. Do not write anything until they say yes.

**4. Write the changes** once confirmed:

- **Horse tasks:** one `updatePlannedTaskStatus` call per planned task, with `uuid` = the planned task UUID, `occurrenceDate` = the task's date (yyyy-MM-dd), and `statuses` = a map of each horse UUID to `CLOSED`. Only include the horses being marked done; leave the others out.
- **General tasks that do not repeat:** fetch the full task with `getRecord` (type `PLANNED_GENERAL_TASK`), then call `updatePlannedGeneralTask` with its `uuid` and all its current fields (`name`, `dueDate`, `users`, `teams`, `notes`), changing only `status` to `CLOSED`.
- **General tasks that repeat** (they have a `repeat` block): do not update them. This update applies to the whole series, so it would close every future occurrence too. Tell the user to tick this one off in the Equihub app.

**5. Report** what was marked done, what was skipped and why, and how many tasks are still open today.

To reopen something, the user can run this command with "reopen …": do the same steps, setting the status to `OPEN` instead.
