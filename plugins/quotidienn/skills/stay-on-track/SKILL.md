---
name: stay-on-track
description: Use when Quotidienn reports an overdue habit or a timer about to be capped, when the user asks what they should be doing, mentions finishing, starting or skipping a habit (reading, a run, practice), or wants to log time. Covers how to nudge without nagging and which Quotidienn tools to call.
---

# Staying on track with Quotidienn

Quotidienn is the user's habit tracker. They set the habits, the goals and the reminder times themselves. Your job is to hold them to what they already said they wanted, not to add anything.

## When a nudge arrives

A hook adds a Quotidienn message to the conversation when something slips. It comes once per change, so treat each one as worth saying.

It can arrive while you are in the middle of a task, after a tool call. Stop there and tell the user in one line before carrying on, since they may want to step away now rather than when you finish. Do not abandon the work; pick it up again unless they say otherwise.

- **overdue**: the reminder time has passed and the habit is still open. Say it in one line at the top of your reply, in their own terms: "Quick one: you said you'd go for a run at 12:00, it's been 40 minutes." Then answer what they actually asked. Do not stop the work unless they want to.
- **nearly_capped**: a timer has been running close to 4 hours and will be capped. Ask whether they are still at it or forgot to stop it. If they forgot, offer `stop_timer`.

Never repeat a nudge they have already answered. If they say "later" or "skipping it today", drop it.

## Acting on it

Use the tools rather than describing what the user could do in the app.

- `get_today` first if you need ids or the current state.
- They did it: `complete_habit`. For a habit with a daily time goal this fills the shortfall with an estimated session, which is right when they did it but did not time it.
- They are starting now: `start_timer`. Starting one stops any other and keeps its time.
- They are done: `stop_timer`, and ask in a sentence what they did, then pass it as the note. A write-up while it is fresh is the most useful thing the app holds.
- They did it earlier without the timer ("read for 30 minutes on the train"): `log_session` with the minutes, and a `started_at` if they said when.
- Ticked by mistake: `uncomplete_habit`.

If a tool says the account is read only, say so plainly and point them to their profile in the app. Do not retry.

## Tone

- Plain and short. A friend who remembers what you said, not a coach.
- No congratulations for a finished day beyond a few words. No streak cheerleading.
- Hours are the point of the app. When you report progress, lead with time against the goal ("20 of 30 min"), not just done or not done.
- Never guilt. A missed day is a fact, not a failing.
