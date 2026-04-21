# Command reference

Every CLI capability the Connector exposes. Same binary that powers the [local MCP server](mcp-tools.md) — every tool your AI assistant can call has a direct CLI counterpart.

!!! warning "You're limited to what your Kuali user can see"
    Every command authenticates with an API key that inherits the permissions of the Kuali user who created it. The server enforces those permissions — the Connector doesn't relax or bypass them. **If you can't see an app, document, or user in the Kuali web UI, the CLI can't see it either.** Admin-only actions (user management, audit, workflow bypass) require an admin's key. When a command returns "not found" or "forbidden," that's usually a permissions issue, not a CLI bug — confirm by signing in to the web UI as the same user.

The general shape:

```
kuali [global flags] <resource> <action> [flags] [arguments]
```

Run any parent without a subcommand to see its help, e.g. `kuali apps`.

## Global flags

Available on every command:

| Flag | Description |
|---|---|
| `--profile <name>` | Named connection profile (default: `default`) |
| `--output, -o <fmt>` | `json`, `table`, `yaml`, or `csv` (auto-detected: table for TTY, JSON for pipes) |
| `--quiet, -q` | Suppress informational messages |
| `--debug` | Enable HTTP debug logging to stderr |
| `--config <path>` | Config file path (default: `~/.kuali/config.yaml`) |
| `--tenant <id>` | Tenant / school identifier |
| `--dry-run` | Preview the action without executing |
| `--insecure, -k` | Skip TLS verification (dev/self-signed only) |
| `--fields <dotted>` | Return only selected fields (`id,name,data.firstName`) |
| `--limit <n>` | Pagination limit (default: 25) |
| `--skip <n>` | Pagination offset |
| `--all` | Auto-paginate and fetch every page |

## Authentication

```bash
kuali auth login   [--api-key <key>] [--profile <name>]
kuali auth logout  [--profile <name>]
kuali auth status  [--profile <name>]
```

API keys are stored in the OS keychain. See [first connection](../guides/first-connection.md).

## Configuration

```bash
kuali config set <key> <value> [--profile <name>]
kuali config get <key>         [--profile <name>]
kuali config list              [--profile <name>]
```

Common keys: `api_url`, `tenant`, `output`, `graphql_path`, `insecure`.

## Apps

```bash
kuali apps list            [--search <term>] [--limit N] [--skip N]
kuali apps get             <app-id>
kuali apps create          --name <name> [--icon <icon>] [--color <#RRGGBB>]
kuali apps publish         <app-id>
kuali apps delete          <app-id>
kuali apps update-tile     <app-id> [--icon <icon>] [--color <color>]
kuali apps icons
kuali apps add-workflow-step <app-id> \
  --step-name <name> --assignee <id> [--assignee-type user|group] \
  [--type approval|task|acknowledge|notification] \
  [--subject <subj>] [--body <body>]
```

## Documents

```bash
kuali documents list       --app <app-id> [--product <alias>] [--status <s>] \
                           [--workflow-status <s>] [--filter <json>] \
                           [--sort <field:dir>]
kuali documents get        <doc-id>
kuali documents create     --form <app-id> --data <json|@file> \
                           [--submit] [--page <page-id>] [--action <action-id>]
kuali documents update     <doc-id> --data <json|@file> [--comment <txt>]
kuali documents submit     <doc-id> [--action <action-id>] [--data <json>] \
                           [--status <status>] [--comment <txt>] [--timezone <tz>]
kuali documents approve    <doc-id> [--action <action-id>] [--data <json>] \
                           [--comment <txt>] [--timezone <tz>]
kuali documents sendback   <doc-id> [--action <action-id>] [--step <step-id>] \
                           [--comment <txt>]
kuali documents duplicate  <doc-id> [--timezone <tz>]
kuali documents delete     <doc-id>
```

`--status` values on `submit`: `completed` (default), `approved`, `rejected`, `task completed`, `acknowledged`, `sendback`. Default `--timezone` is `America/Denver` on `submit`/`approve`/`create`, and `America/New_York` on `duplicate`.

When `--action` and `--data` are omitted on `submit`/`approve`/`sendback`, they are auto-discovered from the document.

## Forms

```bash
kuali forms list     --app <app-id>
kuali forms get      --app <app-id>
kuali forms schema   --app <app-id>
kuali forms options  --app <app-id> --field <formKey>
kuali forms update   --app <app-id> --data @template.json [--skip-validation]
kuali forms outline  <app-id> [--product <alias>]
```

`forms update` validates that the template follows the required `Section > Column > field` nesting before sending. Pass `--skip-validation` only if you know what you're doing — the web UI can crash on malformed templates.

## Users

```bash
kuali users list             [--search <term>]
kuali users get              <user-id>
kuali users create           --email <email> --name <name>
kuali users activate         <user-id>
kuali users deactivate       <user-id>
kuali users import           --data @users.json
kuali users create-api-key   <user-id> --name <label>
kuali users list-api-keys    <user-id>
kuali users revoke-api-key   <user-id> --token-id <id>
```

## Groups

```bash
kuali groups list                [--limit N] [--skip N]
kuali groups get                 <group-id>
kuali groups create              --name <name> [--category <cat-id>]
kuali groups delete              <group-id>
kuali groups members             <group-id>
kuali groups add-member          <group-id> --user <user-id> --role <role>
kuali groups remove-member       <group-id> --user <user-id> --role <role>
kuali groups import-members      <group-id> --data @members.json
```

## Workflows

```bash
kuali workflows status     <doc-id>
kuali workflows actions    [--app <app-id>]
kuali workflows watch      <doc-id> [--interval 5s] [--timeout 1h]
kuali workflows bypass     <doc-id>  --comment <txt>
kuali workflows sendback   <doc-id>  --step <step-id> --from-action <action-id>
kuali workflows retry      <step-id> [--app <app-id>] [--document <doc-id>]
kuali workflows skip       <step-id> [--app <app-id>] [--document <doc-id>]
kuali workflows reassign   <step-id>  --app <app-id> --document <doc-id> --user <user-id>
kuali workflows create     --app <app-id> --form <form-id> --name <name> [--trigger onSubmit|manual] [--page <page-id>]
kuali workflows get        <workflow-id> --app <app-id>
kuali workflows list       <app-id>
kuali workflows trigger    --workflow <workflow-id> --document <doc-id> [--timezone <tz>]
kuali workflows executions <doc-id>
kuali workflows toggle     <workflow-id> --enable|--disable
kuali workflows duplicate  <workflow-id> [--name <name>]
kuali workflows delete     <workflow-id>
```

!!! note "Two flavors of sendback"
    `kuali documents sendback` auto-discovers the current action ID and target step from the document, so it works with just `<doc-id>`. `kuali workflows sendback` is the admin variant — it takes explicit `--step` and `--from-action` IDs and does not auto-discover.

`kuali workflows watch` exits `0` on approved/complete, `1` on denied/withdrawn/rejected/cancelled, `2` on timeout.

## Products

```bash
kuali products list
kuali products get         <product-id|alias>
kuali products datasets    <product-id|alias>
kuali products aliases
kuali products summary     <product-id>
kuali products rules get   <product-id>
kuali products rules set   <product-id> --data <json|@file>
```

Shortcut commands for working with product-aliased documents:

```bash
kuali list                         # all products
kuali list <product>               # datasets in product
kuali list <product> <dataset>     # documents in dataset
kuali get  <product> <dataset> <doc-id>
kuali datasets <product>           # alias for `products datasets`
```

Common aliases: `cm` → `curriculum`, `sp` → `sponsored-programs`, `irb` → `human-ethics`, `iacuc` → `animal-ethics`, `coi` / `conflict` → `conflict-management`. Full list: `kuali products aliases`.

## Categories

```bash
kuali categories list
kuali categories get     <cat-id>
kuali categories create  --name <name>
kuali categories update  <cat-id> --name <name>
kuali categories delete  <cat-id>
```

## Integrations

```bash
kuali integrations list           [--space <space-id>]
kuali integrations get            <integration-id>
kuali integrations invoke         <integration-id> [--data <json>]
kuali integrations create         --name <name> --url <url> --type <type> --space <space-id>
kuali integrations create-bridge  --name <name> --space <space-id> --nodes @nodes.json [--description <txt>]
kuali integrations update-bridge  <uuid> [--name <name>] [--nodes @nodes.json]
kuali integrations run            <integration-id> --document <doc-id>
kuali integrations test           <integration-id>
kuali integrations failures       [--limit N]
```

## Permissions

```bash
kuali permissions list    --app <app-id>
kuali permissions get     --app <app-id> --user <user-id>
kuali permissions grant   --app <app-id> --user <user-id> --label <display-label>
```

## Files

```bash
kuali files upload    <file>
kuali files download  --document <doc-id> [--field <fieldname>] --output <dir>
```

## Audit

```bash
kuali audit list   [--limit N] [--skip N]
kuali audit users
```

## Import

```bash
kuali import csv <file|-> --app <app-id> \
  [--submit] [--mapping @mapping.json] [--save-mapping <path>] \
  [--dry-run] [--limit N]
```

Column mapping is auto-detected by label (case-insensitive). `--dry-run` previews the mapping and parsed values without creating any documents. Pipe CSVs from stdin with `-` as the file argument.

Supported gadgets on import: Text, Textarea, RichText, Email, Url, PrivateData, Number, Currency, LinearScale, TimePicker, Date, DatePicker, Boolean, Checkboxes, Select, Radio, Radios, Dropdown, MultiSelect, CountryDropdown, StateDropdown, LanguagesDropdown, UserTypeahead, GroupTypeahead, UserMultiselect, GroupMultiselect, IntegrationTypeahead.

## Export

```bash
kuali export csv  --app <app-id> --file <path|->
kuali export pdf  <doc-id> [--app <app-id>] --file <path|->
kuali export xlsx <dataset-id | --app <app-id>> [--page <page-id>] [--locale <lang>] --file <path>
```

Use `-` as the file argument to write to stdout for piping.

## Local MCP server

```bash
kuali mcp        [--profile <name>] [--tools all|read-only] [--insecure] [--timeout <sec>]
kuali mcp setup  [--profile <name>] [--client claude-desktop|claude-code|codex|gemini-cli|copilot-cli|vscode]
                 [--tools read-only]
kuali mcp verify [--client <name>]
```

`kuali mcp` runs the Model Context Protocol server over stdio — this is the command your AI client calls. `setup` wires a specific AI client to it. `verify` diagnoses an existing setup.

## Diagnostics & demo

```bash
kuali                  # quick status of all profiles
kuali doctor           # full connectivity + config checks
kuali summary          # instance overview with counts
kuali smoke            # 7-step end-to-end smoke test
kuali demo             # interactive 5-phase lifecycle demo
kuali version          # version, commit, build info
```

## Self-update

```bash
kuali update check     # is a newer version out?
kuali update install   # download and replace the binary in place
```

## Shell completion

```bash
kuali completion bash > /etc/bash_completion.d/kuali
kuali completion zsh  > "${fpath[1]}/_kuali"
kuali completion fish > ~/.config/fish/completions/kuali.fish
kuali completion powershell
```

## Environment variables

| Variable | Purpose |
|---|---|
| `KUALI_PROFILE` | Default profile name |
| `KUALI_API_KEY` | API key (applies to every profile — use with care) |
| `KUALI_<PROFILE>_API_KEY` | Profile-scoped API key (e.g. `KUALI_PROD_API_KEY`) |
| `KUALI_API_URL` | Instance URL (overrides config for every profile) |
| `KUALI_<PROFILE>_API_URL` | Profile-scoped URL override |
| `KUALI_TENANT` | Tenant identifier |
| `KUALI_TIMEOUT` | Command timeout in seconds (default `30`) |

## Output & filtering

```bash
kuali apps list -o json
kuali apps list -o table
kuali apps list -o yaml
kuali apps list -o csv
kuali apps list --fields "id,name" -o json
kuali users list --all               # auto-paginates
kuali users list --limit 100
```

## Dry-run

Preview what a mutation would do without executing:

```bash
kuali documents create --form <id> --data @payload.json --dry-run
kuali users create --email jane@example.com --name "Jane Doe" --dry-run
kuali import csv data.csv --app <id> --dry-run
```

---

!!! info "Need the AI-tool equivalents?"
    Every command here is also exposed as an MCP tool. See the [MCP tool reference](mcp-tools.md) for the tool names and parameter shapes your AI assistant will see.
