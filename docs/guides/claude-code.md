# Claude Code

[Claude Code](https://www.anthropic.com/claude-code) is Anthropic's terminal-based coding agent. Wire the Kuali Connector into it and every Claude Code session can pull data from, and (if you choose) make changes to, your Kuali instance.

## Set it up

With a profile already configured:

```bash
kuali mcp setup --profile myschool --client claude-code
```

Claude Code picks up MCP servers from its configuration automatically — no restart needed for new sessions.

## Verify

```bash
claude mcp list
```

You should see a `kuali` entry. In an active Claude Code session, type `/mcp` to see the available tools.

## Ask it something

From within a Claude Code session:

> "List the apps on our Kuali instance and note which ones haven't been published yet."

> "Pull the schema for app `abcd1234` and add validation for the budget field."

Claude Code is good at multi-step operations — asking it to pull a form schema, propose an edit, and then call `kuali_forms_update` is a natural flow. Just make sure you've got sandbox-not-production set as the active profile when you're experimenting.

## Read-only mode

For production instances:

```bash
kuali mcp setup --profile prod --client claude-code --tools read-only
```

See [Read-only mode](read-only-mode.md) for what's gated and what's still available.

## Multiple profiles

Like Claude Desktop, only one `kuali` entry lives in the config at a time by default. You can add additional entries manually by editing `~/.claude.json` (look under `mcpServers`), giving each a unique name like `kuali-sandbox` and `kuali-prod`.

## Troubleshooting

- `kuali mcp verify --client claude-code` — diagnoses the setup.
- `claude mcp list --verbose` — shows the raw server command and args.
- More help: [Troubleshooting](troubleshooting.md).
