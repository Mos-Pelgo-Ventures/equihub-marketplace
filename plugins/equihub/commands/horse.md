---
description: One-page profile of a horse — location, owners, health, care dates, feeding, insurance and notes
argument-hint: <horse name, nickname, UELN or microchip>
allowed-tools: mcp__plugin_equihub_equihub__searchHorse, mcp__plugin_equihub_equihub__getHorseByUuid, mcp__plugin_equihub_equihub__getHealthOverview, mcp__plugin_equihub_equihub__searchHealthRecord, mcp__plugin_equihub_equihub__searchNutrition, mcp__plugin_equihub_equihub__searchHorseNote
---

Give me a one-page profile of this horse in Equihub: **$ARGUMENTS**. Today is !`date +%Y-%m-%d`.

If no horse was given, ask which horse and stop.

**1. Find the horse.** Call `searchHorse` with `quickSearch` = the text above (it matches registered name, nickname, UELN and microchip). If there is no match, say so and stop. If there are several, list them (display name, registered name, birth year, gender, archived) and ask which one; do not guess.

**2. Fetch the details.** With the horse's UUID, call these in parallel:

- `getHorseByUuid` with `include` = `OWNERSHIP`, `INSURANCE`, `HOOF_CARE`, `NUTRITION`: identity, current location and box, owners, insurance, farrier.
- `getHealthOverview` with `horseUuids` = [the UUID]: overdue, today and upcoming reminders.
- `searchHealthRecord` with `horseUuids` = [the UUID], `pageSize` 10: the most recent care (newest first).
- `searchNutrition` with `horses` = [the UUID]: the feeding plan.
- `searchHorseNote` with `horseUuid` = the UUID, `pageSize` 5: recent notes (pinned ones first).

If a call fails (for example a missing HEALTH or NUTRITION permission), write one line saying that part is unavailable and continue.

**3. Present it** with names, never UUIDs, and leave out any section that has no data:

## <display name> (<registered name>)
One line: gender, age (from birthdate), colour, studbook, UELN, FEI ID. Mark it clearly if the horse is archived.

### Where
Current location, sub-location and box.

### Owners
Each owner with their share, and the account's own share.

### Health
- **Overdue** and **due today** reminders first, then the next 3 upcoming, with dates.
- **Recent care**: the last 5 records, with date, type, product or vaccine, and contact.
- **Farrier**: assigned farrier and the hoof-care requirement.

### Feeding
The feeding plan by feeding time, with products and amounts.

### Insurance
Insurer, policy number, valid until, coverage. Flag it if `validUntil` is in the past or within 30 days.

### Notes
The pinned and most recent notes, shortened to one line each.

End with one line on what needs attention for this horse, if anything. Do not change any data.
