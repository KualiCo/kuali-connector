# MCP tool reference

The Connector runs as a **local MCP server** (stdio transport) and exposes **91 resource tools**, the `kuali_run` catch-all, and **3 connection-management tools** (95 total) to any AI client that can launch one. It speaks the [Model Context Protocol](https://modelcontextprotocol.io). When you wire a client up with `kuali mcp setup`, every tool listed below becomes callable from inside a conversation.

!!! info "Local MCP servers only"
    The Connector is designed to run on your own machine and communicate with the AI client over stdio. Clients that only support **hosted** MCP servers (HTTPS endpoints) — ChatGPT (chatgpt.com), Claude.ai — can't launch it directly. See the [FAQ](../faq.md#does-it-work-with-chatgpt) for the full story.

Each tool has two annotations that AI clients use to decide how to surface them:

- **Read-only** — lists, gets, exports, status checks, summaries. Safe to call without confirmation.
- **Destructive** — deletes, deactivates, revokes, and anything that removes data. Most clients will prompt for approval before calling these.

When a tool is neither read-only nor destructive (create, update, submit, approve, import), it's a **mutation** — it changes state but doesn't remove anything.

!!! tip "Filtering the tool list"
    Run the Connector with `--tools read-only` to register **only** the read-only tools. Mutations and destructive tools are hidden from the client entirely. See [Read-only mode](../guides/read-only-mode.md).

!!! warning "Tools see only what your Kuali user sees"
    Every tool runs as the Kuali user who owns the API key. The server enforces that user's permissions — tools don't escalate, and the Connector doesn't cache or bypass anything. **If you can't see an app, document, or user in the Kuali web UI, the assistant can't see them via these tools either.** Admin-only operations (user management, audit log, workflow bypass) require an admin's key. To scope the assistant down further, create a low-privilege Kuali user and issue an API key for that user — the AI assistant will only ever see what that user would see.

---

## Connection management

Always registered, regardless of `--tools` mode.

| Tool | Purpose |
|---|---|
| `kuali_connect` | Connect to a Kuali instance and save it as a profile. Read-only. |
| `kuali_switch` | Switch the active connection for the current session. Read-only. |
| `kuali_connections` | List configured Kuali connections. Read-only. |

---

## Apps

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_apps_list` | List applications, with optional search/pagination. | read-only |
| `kuali_apps_get` | Get full details of one app. | read-only |
| `kuali_apps_icons` | List available tile icons. | read-only |
| `kuali_apps_create` | Create a new app with name, icon, color. | mutation |
| `kuali_apps_update_tile` | Change icon or color on an existing app. | mutation |
| `kuali_apps_publish` | Publish an app so documents can be submitted against it. | mutation |
| `kuali_apps_add_workflow_step` | Append an approval / task / notification step to an app's workflow. | mutation |
| `kuali_apps_delete` | Delete an app **and every document in it**. | **destructive** |

## Forms

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_forms_list` | List form field definitions for an app. | read-only |
| `kuali_forms_get` | Get the full form template. | read-only |
| `kuali_forms_schema` | Get field schema with types and validations. | read-only |
| `kuali_forms_options` | Get option values for a dropdown / radio field. | read-only |
| `kuali_forms_outline` | Render the form as a text outline (good for assistant consumption). | read-only |
| `kuali_forms_update` | Update the form template (validated before send). | mutation |

## Documents

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_documents_list` | List documents with filters, sorting, pagination. | read-only |
| `kuali_documents_get` | Get a single document by ID. | read-only |
| `kuali_documents_create` | Create a draft document; optional immediate submit. | mutation |
| `kuali_documents_update` | Update document data. | mutation |
| `kuali_documents_submit` | Submit a draft into its workflow. | mutation |
| `kuali_documents_approve` | Approve at the current workflow step. | mutation |
| `kuali_documents_sendback` | Send back to a previous step. | mutation |
| `kuali_documents_duplicate` | Duplicate as a new draft. | mutation |
| `kuali_documents_delete` | Delete a document. | **destructive** |

## Users

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_users_list` | List users, with search and pagination. | read-only |
| `kuali_users_get` | Get one user. | read-only |
| `kuali_users_list_api_keys` | List a user's API keys. | read-only |
| `kuali_users_create` | Create a user account. | mutation |
| `kuali_users_activate` | Reactivate a deactivated account. | mutation |
| `kuali_users_import` | Bulk import users from CSV or JSON. | mutation |
| `kuali_users_create_api_key` | Issue an API key for a user. | mutation |
| `kuali_users_deactivate` | Deactivate a user account. | **destructive** |
| `kuali_users_revoke_api_key` | Revoke a user's API key. | **destructive** |

## Groups

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_groups_list` | List groups. | read-only |
| `kuali_groups_get` | Get one group. | read-only |
| `kuali_groups_members` | List members of a group. | read-only |
| `kuali_groups_create` | Create a group. | mutation |
| `kuali_groups_add_member` | Add a user to a group with a role. | mutation |
| `kuali_groups_import_members` | Bulk import members from CSV or JSON. | mutation |
| `kuali_groups_remove_member` | Remove a user from a group. | mutation |
| `kuali_groups_delete` | Delete a group. | **destructive** |

## Workflows

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_workflows_status` | Status for a document's workflow (step, assignees, history). | read-only |
| `kuali_workflows_actions` | Pending actions for the current user. | read-only |
| `kuali_workflows_get` | Get a workflow definition. | read-only |
| `kuali_workflows_list` | List workflows for an app. | read-only |
| `kuali_workflows_executions` | Workflow execution history. | read-only |
| `kuali_workflows_create` | Create a secondary workflow. | mutation |
| `kuali_workflows_duplicate` | Duplicate a workflow. | mutation |
| `kuali_workflows_toggle` | Enable or disable a workflow. | mutation |
| `kuali_workflows_trigger` | Manually trigger a workflow on a document. | mutation |
| `kuali_workflows_bypass` | Admin bypass of an approval step. | mutation |
| `kuali_workflows_sendback` | Admin send-back to a named step. | mutation |
| `kuali_workflows_retry` | Retry a failed step. | mutation |
| `kuali_workflows_skip` | Skip a step. | mutation |
| `kuali_workflows_reassign` | Reassign a step to a different user. | mutation |
| `kuali_workflows_delete` | Delete a workflow. | **destructive** |

## Products

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_products_list` | List every configured Kuali product (Curriculum, Sponsored Programs, …). | read-only |
| `kuali_products_get` | Get details for a product by ID or alias. | read-only |
| `kuali_products_datasets` | List datasets inside a product. | read-only |
| `kuali_products_aliases` | List all known product aliases (e.g. `cm`, `sp`, `irb`). | read-only |
| `kuali_products_summary` | Product summary with counts. | read-only |
| `kuali_products_rules_get` | Get validation rules for a product. | read-only |
| `kuali_products_rules_set` | Set validation rules for a product. | mutation |

## Categories

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_categories_list` | List categories. | read-only |
| `kuali_categories_get` | Get one category. | read-only |
| `kuali_categories_create` | Create a category. | mutation |
| `kuali_categories_update` | Update a category. | mutation |
| `kuali_categories_delete` | Delete a category. | **destructive** |

## Integrations

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_integrations_list` | List integrations. | read-only |
| `kuali_integrations_get` | Get an integration's config and flow graph. | read-only |
| `kuali_integrations_failures` | Recent integration failures. | read-only |
| `kuali_integrations_create` | Create a simple HTTP integration. | mutation |
| `kuali_integrations_create_bridge` | Create a LASSO bridge (multi-node). | mutation |
| `kuali_integrations_update_bridge` | Update a bridge's nodes. | mutation |
| `kuali_integrations_invoke` | Invoke an integration with data. | mutation |
| `kuali_integrations_run` | Run an integration against a document. | mutation |
| `kuali_integrations_test` | Test an integration endpoint. | mutation |

## Permissions

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_permissions_list` | List policy groups, identities, and allowed actions for an app. | read-only |
| `kuali_permissions_get` | Check what permissions a specific user has on an app. | read-only |
| `kuali_permissions_grant` | Grant a user permission to create and submit documents on an app. | mutation |

## Audit

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_audit_list` | List audit log entries. | read-only |
| `kuali_audit_users` | List users with audit-log activity. | read-only |

## Export

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_export_csv` | Export app documents as CSV. | read-only |
| `kuali_export_pdf` | Export a single document as PDF. | read-only |
| `kuali_export_xlsx` | Export a form outline as Excel. | read-only |

## Import

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_import_csv` | Bulk-import documents from CSV with auto-mapping. | mutation |

## Files

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_files_download` | Download a file from a document. | read-only |
| `kuali_files_upload` | Upload a file attachment. | mutation |

## Utility

| Tool | Purpose | Flags |
|---|---|---|
| `kuali_summary` | Instance overview with counts and health. | read-only |
| `kuali_doctor` | Run six diagnostic checks. | read-only |
| `kuali_smoke` | Run a 7-step end-to-end smoke test. | mutation (creates and deletes test data) |
| `kuali_run` | Escape hatch — run any `kuali` CLI command by name. Useful for flag combinations not covered by the dedicated tools. | mutation |

---

## Counts at a glance

| Category | Total | Read-only | Mutation | Destructive |
|---|---:|---:|---:|---:|
| Apps | 8 | 3 | 4 | 1 |
| Forms | 6 | 5 | 1 | 0 |
| Documents | 9 | 2 | 6 | 1 |
| Users | 9 | 3 | 4 | 2 |
| Groups | 8 | 3 | 4 | 1 |
| Workflows | 15 | 5 | 9 | 1 |
| Products | 7 | 6 | 1 | 0 |
| Categories | 5 | 2 | 2 | 1 |
| Integrations | 9 | 3 | 6 | 0 |
| Permissions | 3 | 2 | 1 | 0 |
| Audit | 2 | 2 | 0 | 0 |
| Export | 3 | 3 | 0 | 0 |
| Import | 1 | 0 | 1 | 0 |
| Files | 2 | 1 | 1 | 0 |
| Utility | 4 | 2 | 2 | 0 |
| Connection management | 3 | 3 | 0 | 0 |
| **Total** | **94** | **45** | **42** | **7** (+ `kuali_smoke`, which cleans up after itself) |

Run `kuali mcp` with `--tools read-only` and you'll see only the read-only tools.
