# Prompt library

Copy-paste these into Claude Desktop, Claude Code, Codex, or any other [wired-up client](index.md#ai-assistant-guides). Each prompt names the MCP tools the assistant is likely to call so you can tell what's happening under the hood — and spot anything that would be blocked by [read-only mode](read-only-mode.md).

!!! tip "Pick the right profile first"
    Most of these prompts describe real operations. If you've wired multiple Kuali environments into your AI client, tell the assistant which one to use: _"Using the kuali-sandbox tools, …"_

---

## Build apps

Build is Kuali's no-code app platform — anything not tied to a specific product.

### Create a Build app from a PDF form

> Build a Kuali app from the attached PDF or described form. Create the app and design the form to preserve the source's section structure with appropriate field types (dates for dates, currency for money, dropdowns or radios for multi-choice, multi-line for prose, and conditional visibility where the source implies it), dropping signature and date lines that would be handled as workflow steps rather than form fields. Before making any mutating calls, show me the proposed app name, icon, and color; the full field list grouped by section with types, required flags, and conditional-visibility rules; any fields from the source you're dropping or merging and why; and behaviors that will require the web UI rather than the CLI (formulas, currency formatting, file-upload constraints, and similar). Wait for "go" before proceeding. After building, give me a checklist with the app ID, form ID, and any other relevant IDs or URLs, followed by follow-ups I need to handle in the web UI grouped by priority, plus any validator or renderer quirks you worked around.

_Tools used:_ `kuali_apps_icons`, `kuali_apps_create`, `kuali_forms_schema`, `kuali_forms_update`, `kuali_apps_add_workflow_step`, `kuali_apps_publish`.

### Update an existing Build app's form

> Open app `<app-id>` and add a required "Cost Center" dropdown in the Budget section. Populate it with these options: 10100, 10200, 10300, 40500. Keep everything else intact and show me the diff of the form template before submitting.

_Tools used:_ `kuali_forms_get`, `kuali_forms_schema`, `kuali_forms_update` _(with `--skip-validation` off — the Connector validates Section > Column > field nesting before sending)._

### Add or adjust a workflow step

> For the Travel Authorization app, insert an extra approval step **before** Finance that routes to group `travel-compliance`. Use "Travel compliance review" as the step name and give approvers 5 business days before escalating.

_Tools used:_ `kuali_apps_get`, `kuali_groups_list`, `kuali_apps_add_workflow_step`.

---

## Curriculum Management

### List in-flight proposals

> Show me all curriculum **course** proposals still in workflow — give me the course code, proposer, current step, and how long it's been there. Sort by longest-waiting first.

_Tools used:_ `kuali_products_get` (cm), `kuali_documents_list`, `kuali_workflows_status`. Works with the `cm` alias or the full `curriculum` name.

### Find stuck proposals

> Which curriculum program proposals have been sitting at the same workflow step for more than 14 days? Include the step name and the approvers assigned. Don't take any action — just the list.

### Analyze a program review cycle

> Using the curriculum product, pull every program-review submission from the last academic year. Group by college and show average cycle time from submission to final approval. Call out the three longest cycles with commentary on what step held them up.

_Tools used:_ `kuali_documents_list` (with filter), `kuali_workflows_status`, `kuali_export_csv`.

### Build a course-inventory snapshot

> Export the curriculum `courses` dataset as CSV into `~/Downloads/courses-snapshot-2026-04-21.csv`. Include only courses with status `active`. Then tell me how many credit hours are represented in total.

---

## Sponsored Programs / Compliance / Research

### Proposal pipeline overview

> Give me a status breakdown of sponsored-programs **proposals** created in the last 90 days: how many in draft, routing, approved, awarded, declined. For each routing proposal, list the PI and the step that's currently holding it.

_Tools used:_ `kuali_documents_list` (sp `proposals`), `kuali_workflows_status`.

### Expiring awards

> Find sponsored-programs **awards** whose end date is within the next 60 days and no renewal proposal has been linked yet. Draft a spreadsheet (columns: award number, PI, sponsor, end date, amount remaining) and save it as `~/Downloads/expiring-awards.csv`.

### Human Ethics reviewer load

> For the Human Ethics product (`human-ethics`), show me each active reviewer's current submission load — how many assigned, how many overdue, average turnaround this quarter. Flag anyone whose average exceeds 14 days.

_Tools used:_ `kuali_products_get` (human-ethics), `kuali_documents_list` (`submissions`, `reviews`), `kuali_users_list`, `kuali_workflows_actions`.

### IACUC meeting prep

> Pull every animal-ethics submission tagged for the next IACUC meeting (date `<meeting-date>`). Produce a one-page summary per submission with title, PI, species, proposed dates, and outstanding reviewer comments. Bundle them as a PDF.

_Tools used:_ `kuali_documents_list` (animal-ethics), `kuali_export_pdf`.

### Conflict Management disclosures

> Using the conflict-management product, list active disclosures whose management plan is past due for review. Include discloser name, plan ID, last review date, assigned reviewer.

---

## CSV imports (with column-mapping dialog)

The Connector can import a CSV into any dataset. Column-to-field mapping is interactive — when there's ambiguity, the assistant should walk you through it.

### Import a CSV into an app and submit every row

> Import the attached CSV into the Kuali `<App Name>` app, submitting every row through workflow — always pass `--submit` to `kuali import csv`. Drafts don't appear in `documents list` or the dataset view, so an import without `--submit` looks like failure even when it succeeded.
>
> Resolve the target with `kuali_apps_list --search "<App Name>"` and confirm CSV headers match field labels via `kuali_forms_list --app <id>`. If mapping is clean, skip the dry-run; if anything is ambiguous, dry-run one chunk first.
>
> The Kuali CLI runs on the user's machine, not your sandbox. Call `Filesystem:list_allowed_directories` to find a writable path, then use `Filesystem:write_file` to stage chunks there — don't try `/mnt/user-data/uploads/` first.
>
> Chunk at **10 rows per file**, header included in each. The MCP tool-call timeout kills longer imports; 10 rows runs in ~2s. For CSVs >100 rows, pause every 5 chunks to verify progress.
>
> Import each chunk with `kuali import csv --app <id> --file <chunk> --submit`, reporting one line per chunk ("Chunk N/M: 10/10 ✓"). Only dump JSON on failure — then show the failing row and ask whether to continue, retry, or stop. After the last chunk, verify totals with `documents list --app <id> --limit 1`.
>
> When done, offer to delete the staged chunks. Final summary: app name + ID, rows imported, any failures. Nothing more unless asked.

_Tools used:_ `kuali_apps_list`, `kuali_forms_list`, `kuali_import_csv` (with `--submit`), `kuali_documents_list`, plus the client's filesystem MCP for staging chunks.

### Import documents with mapping review

> Import `travel-requests-q4.csv` into app `<app-id>`. Before running, run `kuali import csv` in `--dry-run` mode and show me the auto-detected column mapping. If any column is left unmapped, ask me what to do with it. Only when I've approved, re-run without `--dry-run`.

_Tools used:_ `kuali_import_csv` (with `--dry-run` and `--mapping`), `kuali_forms_schema`.

### Import group memberships

> Using `biology-faculty-members.csv` (columns `User Email, Role`), add everyone to the Biology Faculty group. Skip users who aren't in the Kuali directory and list them for me at the end so I can invite them separately.

_Tools used:_ `kuali_groups_list`, `kuali_users_list`, `kuali_groups_import_members`.

### Re-run with a saved mapping

> Use the mapping from last week's import (`~/kuali-imports/travel-mapping.json`) to import `travel-requests-q1.csv` into the Travel Authorization app, and submit each one as it's created.

_Tools used:_ `kuali_import_csv` with `--mapping` + `--submit`.

---

## Workflow analysis & improvement

### Audit a single app's workflow

> Inspect the workflow on app `<app-id>`. Walk through every step: who can act, SLA, current load, 90-day completion rate. Point out any step that's a clear bottleneck. Suggest concrete improvements — splitting, reassigning, adding parallel review — and explain the trade-offs.

_Tools used:_ `kuali_apps_get`, `kuali_workflows_get`, `kuali_workflows_list`, `kuali_workflows_executions`, `kuali_documents_list`.

### Find cross-app patterns

> Across all Build apps in this instance, which workflow steps most frequently cause sendbacks? Group by the approver group receiving the sendback. I want a ranked list with examples.

### Recommend where to add automation

> Look at the approval history for the last quarter across all curriculum workflows. Identify steps where the approver **always** approves without comment within 24 hours — those are candidates for auto-approval or removal. Show me the candidates and a risk note for each.

---

## Reports with charts or graphs

Claude Desktop and Claude Code can render Markdown + Mermaid, and most can produce images or HTML artifacts. Ask for the _shape_ of the answer and they'll pick the right format.

### Submission volume chart

> Pull the count of **human-ethics submissions** per month for the last 12 months. Render it as a bar chart (Mermaid is fine) and highlight the month with the highest volume.

_Tools used:_ `kuali_documents_list` (human-ethics), local charting by the assistant.

### Cycle-time report

> Build a report on Travel Authorization cycle time. For every approved doc in the last 90 days, compute hours between submit and final approval. Produce: a summary table (median, p90, p99), a histogram, and the three outliers that took longest with a one-line note on why.

### Department dashboard

> I need a one-page markdown dashboard for the College of Engineering covering curriculum and sponsored-programs activity: in-flight proposals, approved this month, average approval time, top 5 approvers by load. Include a small chart for each metric.

### Export for a BI tool

> Export the Travel Authorization documents as CSV into `~/dashboards/travel.csv`, then write me a two-paragraph readme explaining the columns so my Tableau team can import it cleanly.

_Tools used:_ `kuali_export_csv`.

---

## Operations & admin

### Instance health check

> Use the Kuali tools to run `doctor` against the prod profile, then summarize: what's healthy, what warnings there are, and any remediation I should take in the next week.

_Tools used:_ `kuali_doctor`, `kuali_summary`, `kuali_integrations_failures`.

### Failing integrations

> List any integrations that have failed more than twice in the last 7 days. For each, pull the most recent error, the integration definition, and suggest a likely cause.

### Audit trail summary

> Show me the audit log for the last 48 hours. Group by actor and by action type. Flag anything unusual — first-time actions from an account, bulk deletes, permission grants.

_Tools used:_ `kuali_audit_list`, `kuali_audit_users`.

### Bulk user operations

> I need to deactivate 37 users whose email domain is `@former.example.edu`. List them first, let me confirm, then deactivate in order. Stop immediately if any one fails.

_Tools used:_ `kuali_users_list`, `kuali_users_deactivate`.

### Expunge old documents from an app

> In app `<app-id>`, find every document created more than **`<N>` years** ago and delete them. Work in three phases and stop for confirmation between each:
>
> 1. **Plan.** List the matching documents with `kuali_documents_list` (use the creation-date field on the records — confirm the field name from the first page before filtering). Show me the total count, the date cutoff you used, and a sample of 10 (ID, title, creator, created date, current status). Do **not** delete anything yet.
> 2. **Confirm.** Wait for me to say "go." If the count is over 100, also tell me how long this will take and offer to proceed in batches of 50 with a progress line per batch.
> 3. **Delete.** Call `kuali_documents_delete` one ID at a time, reporting one line per doc (`deleted <id> — <title>`). On the first failure, stop and show me the error — don't keep going.
>
> Final summary: cutoff date used, count deleted, count skipped (with reasons), any failures. This is destructive and irreversible, so prefer caution over speed.

_Tools used:_ `kuali_documents_list`, `kuali_documents_delete` (**destructive**).

---

## Tips for getting better answers

- **Name the product or app explicitly.** "The curriculum product," "app `abcd1234`," or "the Travel Authorization app" beats "the thing."
- **Ask for a preview step.** Most destructive prompts above include "show me the plan first" — that lets you spot a wrong filter before it touches data.
- **Use the right scope.** If you only need read access, set the profile up in [read-only mode](read-only-mode.md) and the assistant will literally not be able to change anything.
- **Reference the CLI if you want a command.** "Give me the raw `kuali` command so I can put this in a cron job" turns a prompt into a script.
- **Let the assistant improve your prompt.** If it's struggling or spinning on a task, ask it to help you rewrite the prompt. A sharper prompt usually finishes faster and more reliably than a longer conversation.
- **Escape the turn-limit loop.** If the assistant keeps stopping and asking you to "continue," stop and ask it to give you the equivalent `kuali` CLI command or short script to run in your terminal instead. The CLI runs to completion in one shot — no turns, no babysitting.
