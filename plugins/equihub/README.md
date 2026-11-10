# Equihub for Claude

Your stable's records, available in Claude. Ask about a horse, check what is due, or tick off the day's tasks — Claude answers from your Equihub account, with the same data and permissions you have in the app.

Every detail. Accounted for.

## Connect your account

1. Open the Equihub plugin in Claude and select **Connect**.
2. Your browser opens the Equihub sign-in page. Sign in with your Equihub account and approve access for Claude.
3. Return to Claude. Equihub is connected and stays connected until you sign out or remove the plugin.

Claude sees only what your Equihub role allows. If your role has no access to health or feeding records, Claude cannot see them either.

## Commands

Type `/` in a conversation to see the commands. You don't always need them: ask what is due today, what is overdue, or about a specific horse, and Claude uses `/today`, `/overdue` or `/horse` by itself. `/setup` and `/done` change your data, so they only run when you type them.

### `/setup`
New to Equihub? Start here. Claude sets up your stable with you, step by step: your yard and its buildings, fields and stalls, then your horses — from an Excel or CSV file, a typed list or photos of their passports. It closes by asking what you want under control first, and starts on it with you.

Nothing is saved until you have seen it and confirmed.

### `/today`
What is planned today: calendar, horse tasks, general tasks and health reminders due, with anything overdue.

### `/overdue`
Everything that is late: health reminders from the past month, and horse and general tasks still open from the last 30 days. Sorted by how long it has been waiting.

### `/horse <name>`
One page on one horse: where it stands, owners, upcoming and overdue care, recent treatments, farrier, feeding, insurance and notes.

```
/horse Bella
/horse 528003201812345
```

Search by name, nickname, UELN or microchip number. If more than one horse matches, Claude asks which one you mean.

### `/done <task>`
Marks today's tasks as done.

```
/done feeding Bella and Max
/done all lunging
/done clean tack room
/done reopen feeding Max
```

Claude shows exactly what it will change and waits for your confirmation before anything is saved. Repeating general tasks are not closed from Claude — tick those off in the Equihub app, so the rest of the series stays open.

## Ask in your own words

Commands cover the daily routine. For everything else, ask:

- "Which horses are due for vaccination this month?"
- "When was Max last seen by the farrier, and who did it?"
- "Who owns Bella, and what is our share?"
- "Which insurance policies expire before the end of the year?"
- "Plan the farrier for Bella and Max next Tuesday at 9:00."

When a request changes your data — a new note, a reminder, an appointment — Claude shows the change and asks for approval before saving it.

## If something does not work

| What you see | What to do |
|---|---|
| Equihub shows **Connect** again | Your sign-in has expired. Select **Connect** and sign in again. |
| "Missing permission" for health, breeding or feeding | Your Equihub role does not include that area. Ask your stable manager to update your role. |
| A horse is not found | Check the spelling, or search by UELN or microchip. Archived horses are included. |
| Something else | Contact Equihub support and mention the command or question you used. |
