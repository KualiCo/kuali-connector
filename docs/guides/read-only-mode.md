# Read-only mode

By default the Connector exposes all 91 resource tools (plus 3 connection-management tools, for 94 total) — that includes tools that create, update, submit, approve, and delete data. When you first connect an AI assistant to a production Kuali instance you may want to dial that down until you trust the flow.

Read-only mode registers **only tools that read data**. Anything that writes, changes, or deletes is hidden from the assistant entirely, not just marked as "destructive."

## Turn it on

Pass `--tools read-only` when you set up the client:

```bash
kuali mcp setup --profile prod --tools read-only
kuali mcp setup --profile prod --client claude-code --tools read-only
kuali mcp setup --profile prod --client codex --tools read-only
```

Or, if you wrote the MCP config by hand, add `--tools` to the args:

```json
{
  "mcpServers": {
    "kuali-prod": {
      "command": "/usr/local/bin/kuali",
      "args": ["mcp", "--profile", "prod", "--tools", "read-only"]
    }
  }
}
```

Restart the AI client (or reload tools) and the destructive tools vanish.

## What's available in read-only mode

Across every resource group, the read operations stay:

- **Apps:** `kuali_apps_list`, `kuali_apps_get`, `kuali_apps_icons`
- **Forms:** `kuali_forms_list`, `kuali_forms_get`, `kuali_forms_schema`, `kuali_forms_options`, `kuali_forms_outline`
- **Documents:** `kuali_documents_list`, `kuali_documents_get`
- **Users & Groups:** `kuali_users_list`, `kuali_users_get`, `kuali_users_list_api_keys`, `kuali_groups_list`, `kuali_groups_get`, `kuali_groups_members`
- **Workflows:** `kuali_workflows_status`, `kuali_workflows_actions`, `kuali_workflows_get`, `kuali_workflows_list`, `kuali_workflows_executions`
- **Products:** all read tools (`kuali_products_list`, `_get`, `_datasets`, `_aliases`, `_summary`, `_rules_get`)
- **Integrations:** `kuali_integrations_list`, `kuali_integrations_get`, `kuali_integrations_failures`
- **Categories, Permissions, Audit:** all read tools
- **Export:** `kuali_export_csv`, `kuali_export_pdf`, `kuali_export_xlsx` — exports are reads
- **Utilities:** `kuali_summary`, `kuali_doctor`
- **Connection management:** `kuali_connect`, `kuali_switch`, `kuali_connections`

## What's hidden in read-only mode

Everything that changes the instance:

- Any `_create`, `_update`, `_delete`, `_activate`, `_deactivate`
- Document lifecycle: `submit`, `approve`, `sendback`, `duplicate`
- Workflow administration: `bypass`, `sendback`, `retry`, `skip`, `reassign`, `trigger`, `toggle`
- Imports: `kuali_import_csv`, `kuali_users_import`, `kuali_groups_import_members`
- Integration invocation (`kuali_integrations_invoke`, `_run`, `_test` — these can have side effects)
- File uploads, API key creation/revocation
- Form template updates, tile updates, workflow step edits
- Permission grants, rule sets
- `kuali_run` — the arbitrary-command escape hatch (can call any CLI action) is hidden in read-only mode

If the assistant tries to call one of these, it will simply not see it in the tool list. No partial execution, no prompts.

## Mixing modes across profiles

A common pattern is **sandbox full-access, production read-only**. Set each profile up differently — the same Connector binary, two config entries:

```bash
kuali mcp setup --profile sandbox                         # full tools
kuali mcp setup --profile prod --tools read-only           # read-only
```

For Claude Desktop and similar clients that only keep one `kuali` entry at a time, register each profile as its own MCP server with a distinct name (`kuali-sandbox`, `kuali-prod`) by editing the config file — see [Claude Desktop → Multiple profiles](claude-desktop.md#multiple-profiles-in-claude-desktop).

## What read-only does **not** protect

- Your API key still has whatever permissions its owner has. If the key could read something you'd rather it couldn't, create a separate Kuali user with narrower permissions and issue a key for that user.
- The assistant can still *describe* an action it would take (draft a new document's JSON, for example). It just can't *execute* it. For truly sensitive environments, pair read-only mode with a dedicated low-privilege API key.
