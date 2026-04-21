# Prompt library

Copy-paste these into Claude Desktop, Claude Code, Codex, or any other [wired-up client](index.md#ai-assistant-guides). Each prompt names the MCP tools the assistant is likely to call so you can tell what's happening under the hood — and spot anything that would be blocked by [read-only mode](read-only-mode.md).

!!! tip "Pick the right profile first"
    Most of these prompts describe real operations. If you've wired multiple Kuali environments into your AI client, tell the assistant which one to use: *"Using the kuali-sandbox tools, …"*

---

## Build apps

Build is Kuali's no-code app platform — anything not tied to a specific product.

### Create a Build app from a PDF form

> I'm attaching a PDF of our current **Travel Authorization** paper form. Build a matching Kuali app: create the app, design a form with the same fields and sections, set reasonable field types (dates for dates, currency for amounts, dropdowns for multi-choice), then add a simple two-step approval workflow (supervisor → finance). Show me the field list before you create anything.

*Tools used:* `kuali_apps_icons`, `kuali_apps_create`, `kuali_forms_schema`, `kuali_forms_update`, `kuali_apps_add_workflow_step`, `kuali_apps_publish`.

### Update an existing Build app's form

> Open app `<app-id>` and add a required "Cost Center" dropdown in the Budget section. Populate it with these options: 10100, 10200, 10300, 40500. Keep everything else intact and show me the diff of the form template before submitting.

*Tools used:* `kuali_forms_get`, `kuali_forms_schema`, `kuali_forms_update` *(with `--skip-validation` off — the Connector validates Section > Column > field nesting before sending).*

### Add or adjust a workflow step

> For the Travel Authorization app, insert an extra approval step **before** Finance that routes to group `travel-compliance`. Use "Travel compliance review" as the step name and give approvers 5 business days before escalating.

*Tools used:* `kuali_apps_get`, `kuali_groups_list`, `kuali_apps_add_workflow_step`.

---

## Curriculum Management

### List in-flight proposals

> Show me all curriculum **course** proposals still in workflow — give me the course code, proposer, current step, and how long it's been there. Sort by longest-waiting first.

*Tools used:* `kuali_products_get` (cm), `kuali_documents_list`, `kuali_workflows_status`. Works with the `cm` alias or the full `curriculum` name.

### Find stuck proposals

> Which curriculum program proposals have been sitting at the same workflow step for more than 14 days? Include the step name and the approvers assigned. Don't take any action — just the list.

### Analyze a program review cycle

> Using the curriculum product, pull every program-review submission from the last academic year. Group by college and show average cycle time from submission to final approval. Call out the three longest cycles with commentary on what step held them up.

*Tools used:* `kuali_documents_list` (with filter), `kuali_workflows_status`, `kuali_export_csv`.

### Build a course-inventory snapshot

> Export the curriculum `courses` dataset as CSV into `~/Downloads/courses-snapshot-2026-04-21.csv`. Include only courses with status `active`. Then tell me how many credit hours are represented in total.

---

## Sponsored Programs / Research

### Proposal pipeline overview

> Give me a status breakdown of sponsored-programs **proposals** created in the last 90 days: how many in draft, routing, approved, awarded, declined. For each routing proposal, list the PI and the step that's currently holding it.

*Tools used:* `kuali_documents_list` (sp `proposals`), `kuali_workflows_status`.

### Expiring awards

> Find sponsored-programs **awards** whose end date is within the next 60 days and no renewal proposal has been linked yet. Draft a spreadsheet (columns: award number, PI, sponsor, end date, amount remaining) and save it as `~/Downloads/expiring-awards.csv`.

### Human Ethics reviewer load

> For the Human Ethics product (`human-ethics`), show me each active reviewer's current submission load — how many assigned, how many overdue, average turnaround this quarter. Flag anyone whose average exceeds 14 days.

*Tools used:* `kuali_products_get` (human-ethics), `kuali_documents_list` (`submissions`, `reviews`), `kuali_users_list`, `kuali_workflows_actions`.

### IACUC meeting prep

> Pull every animal-ethics submission tagged for the next IACUC meeting (date `<meeting-date>`). Produce a one-page summary per submission with title, PI, species, proposed dates, and outstanding reviewer comments. Bundle them as a PDF.

*Tools used:* `kuali_documents_list` (animal-ethics), `kuali_export_pdf`.

### Conflict Management disclosures

> Using the conflict-management product, list active disclosures whose management plan is past due for review. Include discloser name, plan ID, last review date, assigned reviewer.

---

## CSV imports (with column-mapping dialog)

The Connector can import a CSV into any dataset. Column-to-field mapping is interactive — when there's ambiguity, the assistant should walk you through it.

### Import users from a spreadsheet

> I'm attaching `new-students-fall-2026.csv` with columns `Preferred Name, Campus Email, Role, Advisor Email, Cohort`. Import these as Kuali users. Preview the mapping first: show me which CSV column maps to which Kuali field, and pause if anything is ambiguous — I'll confirm before any accounts are created.

*Tools used:* `kuali_users_import`, `kuali_forms_schema` (to fetch target fields).

### Import documents with mapping review

> Import `travel-requests-q4.csv` into app `<app-id>`. Before running, run `kuali import csv` in `--dry-run` mode and show me the auto-detected column mapping. If any column is left unmapped, ask me what to do with it. Only when I've approved, re-run without `--dry-run`.

*Tools used:* `kuali_import_csv` (with `--dry-run` and `--mapping`), `kuali_forms_schema`.

### Import group memberships

> Using `biology-faculty-members.csv` (columns `User Email, Role`), add everyone to the Biology Faculty group. Skip users who aren't in the Kuali directory and list them for me at the end so I can invite them separately.

*Tools used:* `kuali_groups_list`, `kuali_users_list`, `kuali_groups_import_members`.

### Re-run with a saved mapping

> Use the mapping from last week's import (`~/kuali-imports/travel-mapping.json`) to import `travel-requests-q1.csv` into the Travel Authorization app, and submit each one as it's created.

*Tools used:* `kuali_import_csv` with `--mapping` + `--submit`.

---

## Workflow analysis & improvement

### Audit a single app's workflow

> Inspect the workflow on app `<app-id>`. Walk through every step: who can act, SLA, current load, 90-day completion rate. Point out any step that's a clear bottleneck. Suggest concrete improvements — splitting, reassigning, adding parallel review — and explain the trade-offs.

*Tools used:* `kuali_apps_get`, `kuali_workflows_get`, `kuali_workflows_list`, `kuali_workflows_executions`, `kuali_documents_list`.

### Find cross-app patterns

> Across all Build apps in this instance, which workflow steps most frequently cause sendbacks? Group by the approver group receiving the sendback. I want a ranked list with examples.

### Recommend where to add automation

> Look at the approval history for the last quarter across all curriculum workflows. Identify steps where the approver **always** approves without comment within 24 hours — those are candidates for auto-approval or removal. Show me the candidates and a risk note for each.

---

## Reports with charts or graphs

Claude Desktop and Claude Code can render Markdown + Mermaid, and most can produce images or HTML artifacts. Ask for the *shape* of the answer and they'll pick the right format.

### Submission volume chart

> Pull the count of **human-ethics submissions** per month for the last 12 months. Render it as a bar chart (Mermaid is fine) and highlight the month with the highest volume.

*Tools used:* `kuali_documents_list` (human-ethics), local charting by the assistant.

### Cycle-time report

> Build a report on Travel Authorization cycle time. For every approved doc in the last 90 days, compute hours between submit and final approval. Produce: a summary table (median, p90, p99), a histogram, and the three outliers that took longest with a one-line note on why.

### Department dashboard

> I need a one-page markdown dashboard for the College of Engineering covering curriculum and sponsored-programs activity: in-flight proposals, approved this month, average approval time, top 5 approvers by load. Include a small chart for each metric.

### Export for a BI tool

> Export the Travel Authorization documents as CSV into `~/dashboards/travel.csv`, then write me a two-paragraph readme explaining the columns so my Tableau team can import it cleanly.

*Tools used:* `kuali_export_csv`.

---

## Operations & admin

### Instance health check

> Use the Kuali tools to run `doctor` against the prod profile, then summarize: what's healthy, what warnings there are, and any remediation I should take in the next week.

*Tools used:* `kuali_doctor`, `kuali_summary`, `kuali_integrations_failures`.

### Failing integrations

> List any integrations that have failed more than twice in the last 7 days. For each, pull the most recent error, the integration definition, and suggest a likely cause.

### Audit trail summary

> Show me the audit log for the last 48 hours. Group by actor and by action type. Flag anything unusual — first-time actions from an account, bulk deletes, permission grants.

*Tools used:* `kuali_audit_list`, `kuali_audit_users`.

### Bulk user operations

> I need to deactivate 37 users whose email domain is `@former.example.edu`. List them first, let me confirm, then deactivate in order. Stop immediately if any one fails.

*Tools used:* `kuali_users_list`, `kuali_users_deactivate`.

---

## Tips for getting better answers

- **Name the product or app explicitly.** "The curriculum product," "app `abcd1234`," or "the Travel Authorization app" beats "the thing."
- **Ask for a preview step.** Most destructive prompts above include "show me the plan first" — that lets you spot a wrong filter before it touches data.
- **Use the right scope.** If you only need read access, set the profile up in [read-only mode](read-only-mode.md) and the assistant will literally not be able to change anything.
- **Reference the CLI if you want a command.** "Give me the raw `kuali` command so I can put this in a cron job" turns a prompt into a script.
