# Claude Desktop

[Claude Desktop](https://claude.ai/download) is the visual desktop app for Claude (macOS and Windows). Once the Kuali Connector is wired in, every conversation has access to your Kuali instance as a set of tools Claude can call.

## Set it up

With a profile already configured (see [first connection](first-connection.md)):

```bash
kuali mcp setup --profile myschool
```

That reads your saved URL and keychain-stored API key, finds the Claude Desktop config file for your operating system, and merges in a `kuali` MCP server entry. Existing servers in the config are preserved.

Then **fully quit Claude Desktop and reopen it**. On macOS, "quit" means Cmd+Q — closing the window isn't enough.

### Verify

```bash
kuali mcp verify
```

This checks the config file path, the registered `kuali` server entry, the binary path and executable bit, the macOS quarantine flag, whether the API key resolves for your profile, and whether the binary can actually run (`kuali version`).

Inside Claude, a slider icon in the composer shows that tools are available. Click it to see the list of `kuali_*` tools.

## Ask it something

Try any of these to confirm the tools are reachable:

> "Use the Kuali tools to list the first five apps."

> "What's the workflow status of document `<paste-a-doc-id>`?"

> "Which products does this Kuali instance have configured?"

The first time Claude uses a tool in a conversation, it may ask you to approve the call. You can approve per-call or allow all calls from the Connector for that session.

## Multiple profiles in Claude Desktop

Claude Desktop's config has one `kuali` entry at a time. If you work across sandbox and production, two patterns work:

### A. Rerun `mcp setup` when you switch

```bash
kuali mcp setup --profile sandbox
# restart Claude Desktop
```

### B. Register each profile as its own MCP server

Edit the Claude Desktop config directly to add multiple entries:

```json
{
  "mcpServers": {
    "kuali-sandbox": {
      "command": "/usr/local/bin/kuali",
      "args": ["mcp", "--profile", "sandbox"]
    },
    "kuali-prod": {
      "command": "/usr/local/bin/kuali",
      "args": ["mcp", "--profile", "prod"]
    }
  }
}
```

Now each profile shows up as its own tool namespace. You can tell Claude "use the kuali-sandbox tools" or "use the kuali-prod tools" to scope the conversation.

Config file location:

| OS | Path |
|---|---|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |

## Keep production safe

For anything you're not ready to let the assistant change, set up the profile in read-only mode:

```bash
kuali mcp setup --profile prod --tools read-only
```

Only read tools (list, get, status, export, summary) are registered. Write tools (create, update, submit, approve, delete) are hidden from Claude entirely. Full details: [Read-only mode](read-only-mode.md).

## Troubleshooting

| Symptom | Fix |
|---|---|
| Claude says the server failed to start | Run `kuali mcp verify` — it diagnoses binary path, permissions, and the macOS quarantine flag. |
| "command not found" in Claude's error log | The absolute path in the config doesn't resolve. Rerun `kuali mcp setup` so the path is written fresh. |
| Tools are missing after install | Make sure you fully quit Claude Desktop (Cmd+Q on Mac) before relaunching. |
| macOS blocks the binary when Claude starts it | `xattr -d com.apple.quarantine $(which kuali)` |

More help: [Troubleshooting](troubleshooting.md).
