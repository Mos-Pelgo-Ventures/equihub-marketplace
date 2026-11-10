---
name: setup
description: "Set up a stable in Equihub step by step: its location, its horses from a file, list or passport photos, and what to organise first."
disable-model-invocation: true
allowed-tools: mcp__plugin_equihub_equihub__searchLocation, mcp__plugin_equihub_equihub__getRecord, mcp__plugin_equihub_equihub__createLocation, mcp__plugin_equihub_equihub__updateSubLocation, mcp__plugin_equihub_equihub__updateLocationBox, mcp__plugin_equihub_equihub__searchHorse, mcp__plugin_equihub_equihub__createHorses, mcp__plugin_equihub_equihub__createHorseLocation
---

Guide this stable through setting up Equihub. Use today's date. $ARGUMENTS

Work through the four steps below in order, one at a time. Ask one question, wait for the answer, then continue. Keep messages short and direct: the person is busy and runs a professional operation. Never write anything to Equihub without showing it first and getting a yes.

## 0. Check what is already there

Before the first question, call in parallel:
- `searchLocation` (no filters): existing locations, with their sub-locations and boxes.
- `searchHorse` with `archived` = false and `countOnly` = true: how many active horses exist.

If locations or horses already exist, say so in one line ("You already have 1 location and 12 horses in Equihub") and skip or shorten the steps that are done. Offer to add to them rather than start again.

## 1. Barn, stable or yard?

Ask: **"Do you call your place a barn, a stable or a yard?"**

Use their word from here on, in every message: "your yard", "add your first barn". Also use their word for where a horse stands (stall, box or stable) when they use one.

How Equihub stores it, whichever word they use:
- **Location** — the property itself (type `OWN`; `OTHER` is for places that are not theirs, such as a vet clinic or a competition venue).
- **Sub-locations** — the buildings (`BUILDING`) and fields or paddocks (`FIELD`) on it.
- **Boxes** — the individual stalls inside a building.

## 2. Add the first location

Ask for:
- the name of the place (2–60 characters) and its address and country;
- the buildings and fields on it, by name ("Main barn", "Back paddock");
- for each building, how many stalls, or their names or numbers. A count is enough: number them 1, 2, 3… unless they give names.

Show the structure before saving:

> **Bellewaerde Stables** — Ieper, Belgium
> - Main barn: boxes 1–20
> - Young horse barn: boxes 1–8
> - Back paddock (field)

After a yes, create it with one `createLocation` call: `type` = `OWN`, `name`, `address`, `country`, and `subLocations` with their `type`, `name` and `boxes`. Confirm in one line what was created. To add buildings or boxes to an existing location later, use `updateSubLocation` and `updateLocationBox`.

## 3. Add the horses

Ask for the horses in whatever form they have:
- an **Excel or CSV** export (from a previous system, a spreadsheet, the vet's list);
- **photos of horse passports** — the identification pages, one horse at a time or several;
- or a **typed list**: name, gender, birth year, and anything else they know.

From what they share, collect for each horse: `name` (official name), `nickname`, `gender` (STALLION, GELDING or MARE), `birthdate`, `colour`, `studbook`, `ueln`, `microchip`, `feiId`, `height`, and the sire and dam with their own sire and dam when the passport or file shows them.

Rules for reading the data:
- Read passports carefully. **Never guess a UELN, microchip or FEI ID.** If a digit is unreadable, leave the field empty and mark it.
- Name and gender are required. Ask for a missing gender instead of assuming one.
- Send `colour` and `studbook` only when they match an allowed value; otherwise leave them empty and mention it.
- Dates as yyyy-MM-dd. A birth year alone is not a birthdate: leave it empty and mention the year in the table.

Show a table of every horse before saving: name, nickname, gender, born, UELN, microchip, sire × dam, and a column for anything missing or uncertain. Ask them to correct it or confirm.

Then:
1. Call `createHorses` with `dryRun` = true for the whole list (at most 25 horses per call). Report any horse that already exists in Equihub by UELN or microchip; those are not created again.
2. After a final yes, call `createHorses` without `dryRun`. Report how many were created, skipped as already existing, or failed, and why.
3. Ask where the horses stand: all at the new location, or per building and stall. If they give a stall plan, call `createHorseLocation` for each horse with `date` = today, `horseUuid`, `locationUuid`, and when known `subLocationUuid` and `locationBoxUuid` (from the location created in step 2, or `getRecord` with type `LOCATION`). Skip this if they prefer to do it later.

## 4. What first?

Ask: **"What do you want under control first?"** and offer these, in their words:

- **Health** — vaccinations, deworming, farrier and dentist schedules, with reminders before they are due.
- **Daily tasks** — feeding, turnout, exercise, and who does what each day.
- **Feeding** — a feeding plan per horse, ready for the feed room.
- **Owners and contacts** — owners and their shares, vet, farrier, emergency contacts.
- **Team** — inviting staff, which is done in the Equihub app under team settings.

Based on the answer, explain in two or three lines what to set up, and offer to start on it right away in this conversation. For example: "Tell me when each horse was last vaccinated and I'll set the reminders."

## Finish

Close with a short summary: what is now in Equihub (location, buildings, boxes, horses), what is still open, and the commands that help day to day: `/today`, `/overdue`, `/horse <name>`, `/done`.

If any call fails with a permission error, explain that their Equihub role cannot create that kind of record and that an account owner or administrator needs to do it, then continue with the steps that work.
