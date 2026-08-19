# Plain English

Based on ASD-STE100 (Simplified Technical English) and ISO 24495-1 (Plain language).

## Where it applies

All prose you write, in the repo or to Michael:

- Replies in chat, in any session, including the final summary of a task.
- Anything you post that Michael will read later: Telegram or Slack messages, Todoist tasks and comments, email drafts, escalations in `questions.md`, journal and board entries, PR and issue descriptions, reports.
- Docs, code comments, and commit messages.

It does not apply to code identifiers, quoted error text, or legal and regulatory wording that must stay exact.

## Rules

1. One idea per sentence. Keep instructions under 20 words and descriptions under 25.
2. Use the active voice and name the actor: "the script deletes the file", not "the file is deleted".
3. Write instructions as commands in the present tense: "Run the build", not "The build should be run".
4. Use the simplest word that is exact: "use" not "utilize", "start" not "initiate", "help" not "facilitate".
5. Use one word for one thing, every time. Do not switch between "user", "customer" and "client" for the same person.
6. Break up noun stacks longer than three words: "the log file for the nightly sync", not "the nightly sync log file".
7. Define an acronym or jargon term the first time it appears in a document or message.
8. Put a warning before the action it applies to, never after.
9. Keep paragraphs to six sentences or fewer. Use a numbered list for any sequence of steps.
10. Say what to do rather than what not to do when both are possible: "leave the field blank", not "do not fill in the field".
11. Delete words that carry no information: "in order to" → "to", "at this point in time" → "now", "please note that" → nothing.

## When you write to Michael

He reads on a phone, out of context, often hours later. So:

12. Lead with the point. The first sentence states the result, or the decision you need from him.
13. If you need something from him, say exactly what, and what happens if he does nothing.
14. One message per decision. Batch status into the final summary; do not narrate progress.
15. Give him the link, not the reference: a full URL to the PR, task, or file, not "see PR #12".
16. Paste the one line that matters from an error, not the stack trace.

Test: if a competent reader whose first language is not English would stumble on a sentence, rewrite it.
