# Other AI clients

The Connector works with any client that supports **local MCP servers** — ones launched as a subprocess and spoken to over stdio. `kuali mcp setup` knows how to configure six of them out of the box.

!!! note "ChatGPT isn't one of them"
    ChatGPT (chatgpt.com, the ChatGPT desktop app) only supports **hosted** MCP servers reachable at a public HTTPS URL — it can't launch a local binary. The Kuali Connector is a local MCP server. Use **OpenAI Codex CLI** instead if you want an OpenAI model driving Kuali today, or see the [FAQ](../faq.md#does-it-work-with-chatgpt).

## OpenAI Codex CLI

```bash
kuali mcp setup --profile myschool --client codex
```

Writes `~/.codex/config.toml`. Existing entries are preserved.

Test it from within a Codex session with a prompt like *"list the first five apps in Kuali."*

## Google Gemini CLI

```bash
kuali mcp setup --profile myschool --client gemini-cli
```

Writes `~/.gemini/settings.json`.

## GitHub Copilot CLI

```bash
kuali mcp setup --profile myschool --client copilot-cli
```

Writes `~/.copilot/mcp-config.json`.

## VS Code (with Copilot Chat)

```bash
kuali mcp setup --profile myschool --client vscode
```

Writes `.vscode/mcp.json` **in the current directory** — this one is project-local rather than user-global, so you can scope the Connector to the repo you're working in. Open VS Code in that folder and Copilot Chat will pick it up.

## Any other local-MCP client (manual config)

The Connector runs as a local MCP server over stdio. For a client that doesn't have a built-in helper but *does* support launching a local stdio MCP server, add an entry like this to the client's server list:

```json
{
  "mcpServers": {
    "kuali": {
      "command": "/usr/local/bin/kuali",
      "args": ["mcp", "--profile", "myschool"]
    }
  }
}
```

Adjust `command` to the absolute path of your `kuali` binary (`which kuali` on macOS/Linux, `where kuali` on Windows). `args` accepts the same flags as the standalone `kuali mcp` command:

| Flag | What it does |
|---|---|
| `--profile <name>` | Which configured profile to use. |
| `--tools read-only` | Register only read tools — create/update/delete are hidden. |
| `--insecure` | Skip TLS verification. Local/dev instances only. |
| `--timeout <seconds>` | Per-command timeout. Default 30. |

!!! warning "Don't pass credentials as env vars in the MCP config"
    Setting `KUALI_API_KEY` or `KUALI_API_URL` in the MCP server's environment overrides profile resolution entirely, which defeats named profiles and per-profile read-only setups. Store keys with `kuali setup` (or `kuali auth login --profile <name>` if the profile already exists) instead — the Connector looks them up at start.

## Verify any of these

```bash
kuali mcp verify --client codex
kuali mcp verify --client gemini-cli
kuali mcp verify --client copilot-cli
kuali mcp verify --client vscode
```

Each variant reads the right config file for the client and reports on the entry it finds.
