# Frequently asked questions

## What is the Kuali Connector, really?

A small program that runs on your computer and gives your AI assistant — or your terminal — a structured, secure way to talk to your Kuali instance. It's a **local MCP server**: it speaks the [Model Context Protocol (MCP)](https://modelcontextprotocol.io) over stdio from your machine, so any AI client that supports local MCP servers (Claude Desktop, Claude Code, OpenAI Codex CLI, Google Gemini CLI, GitHub Copilot CLI, VS Code with Copilot) can use it. The same binary also works as a full `kuali` command-line tool for scripts and CI.

## Do I need to be a developer?

No. The AI path is the whole point: you install the Connector, run one setup command per AI client, and then talk to Kuali in plain English from the chat you already use. The CLI is available if you want it, but it's never required.

## Is the Connector free?

Yes. It's free for any institution with an active Kuali subscription. No extra license is needed for the Connector itself. (You will, however, be using tokens against whichever AI client you've set up — that billing is between you and the AI vendor.)

## Does my data get sent to OpenAI / Anthropic / Google?

Only what the AI client normally sends. When you ask the assistant a question, it calls the Connector's tools locally, the Connector calls your Kuali instance directly, and the results come back to the assistant — which does send the **content of the tool responses** to its own model for reasoning. That's how AI tool-use works with any MCP server, local or hosted.

What doesn't happen:

- **Your API key never leaves your machine.** It's stored in your OS keychain and used by the local Connector binary. The AI vendor doesn't see it.
- **Nothing routes through a Kuali-operated proxy.** The Connector talks directly from your machine to your Kuali instance over HTTPS.

If you want to minimize what the assistant can see, put the profile in [read-only mode](guides/read-only-mode.md) and/or use a low-privilege API key.

## Can I stop the assistant from changing anything?

Yes. Set the profile up with `kuali mcp setup --tools read-only`. Only read tools are registered — create, update, submit, approve, delete, import tools are hidden from the assistant entirely. See [Read-only mode](guides/read-only-mode.md).

For belt-and-braces protection, issue the Connector an API key that itself has read-only permissions in Kuali.

## Does it use single sign-on?

No. The Connector authenticates with a **Kuali API key** — a signed token you create in the Kuali web UI under **Settings → API Keys**. API keys inherit the permissions of the user that created them, and can be revoked at any time from the same screen.

## Which AI clients work?

Any AI client that supports **local MCP servers** (stdio transport). `kuali mcp setup` has built-in wiring for six:

- Claude Desktop
- Claude Code
- OpenAI Codex CLI
- Google Gemini CLI
- GitHub Copilot CLI
- VS Code with Copilot Chat (project-local config)

For clients not on that list, add a `kuali` entry to the client's MCP server list manually — the [other clients guide](guides/other-clients.md) shows the shape.

## Does it work with ChatGPT?

Not yet. ChatGPT (the chatgpt.com web/desktop app) only supports **hosted** MCP servers — servers reachable at an HTTPS URL on the public internet — and the Kuali Connector is a **local** MCP server that runs on your own machine and talks to the client over stdio. The two don't meet in the middle: ChatGPT can't launch a local binary, and the Connector isn't designed to be exposed over the internet (among other things, that would put your institution's API keys on a server we don't run).

A few notes that may reduce confusion:

- **OpenAI Codex CLI works fine** — it's OpenAI's terminal product and does support local MCP servers. That's the one to use if you want to drive Kuali from an OpenAI model today.
- **ChatGPT Apps / Connectors** (OpenAI's partner program) is the hosted-MCP channel. A supported hosted offering is on our roadmap but isn't available yet; we don't have a date.
- **Claude.ai (the web app)** is in the same boat — it talks to hosted MCP servers, not local ones. Use Claude Desktop, Claude Code, or the Claude API for now.

In short: if your AI client launches a local binary over stdio, the Connector works. If it expects an HTTPS URL, it doesn't — yet.

## Which operating systems are supported?

macOS 12 or later (Intel and Apple Silicon), Windows 10 or later (amd64 and arm64), and any modern 64-bit Linux. Binaries are statically linked — no runtime dependencies.

## Does it work with Kuali Research, KFS, or other Classic Kuali products?

No. The Connector targets the **Kuali Platform** — the modern, cloud-hosted system that runs at `*.kualihub.com`, `*.kualibuild.com`, and the regional variants (`*.kualihubca.com`, `*.kualibuildca.com`).

It does **not** talk to **Classic** Kuali products. Several products exist in both editions (Curriculum, Research, Sponsored Programs, Conflict of Interest, Protocols), so the product name alone doesn't tell you which one you have — the hostname does.

If you're not sure which you're on, the URL you sign in at is the test: any `*.kuali.co` address is Classic and the Connector won't work against it. Platform tenants live on the domains listed above.

## Does it work offline?

No. The Connector is a thin client. It needs a live connection to your Kuali instance (and, if you're using an AI assistant, to your AI vendor) to function.

## I have sandbox and production instances. Is that a problem?

That's the expected setup — use [profiles](guides/first-connection.md#working-with-multiple-environments). A common configuration is sandbox in full-access mode and production in read-only mode. You can register both in the same AI client by editing its config to expose each profile as a separately-named local MCP server (e.g. `kuali-sandbox`, `kuali-prod`).

## Can I script with it, or use it in CI?

Yes. The CLI is first-class. Every mutation supports `--dry-run`. Pagination (`--limit`, `--skip`, `--all`), output formats (`-o json|csv|yaml|table`), and field filtering (`--fields`) are designed for scripting. In CI, use profile-scoped env vars:

```bash
export KUALI_PROD_API_KEY=<key>
kuali apps list --profile prod -o json
```

## Will it update itself?

It will if you ask. Run `kuali update check` to see if a newer version is out, or `kuali update install` to replace the binary in place. Homebrew users can also `brew upgrade kuali`.

## Where is configuration stored?

| Item | Location |
|---|---|
| Instance URLs, profile settings | `~/.kuali/config.yaml` |
| API keys | OS keychain (service `kuali-cli`, account = profile name) |
| Credentials fallback | `~/.kuali/credentials`, mode 0600 |
| MCP client config (Claude Desktop, macOS) | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| MCP client config (Claude Desktop, Windows) | `%APPDATA%\Claude\claude_desktop_config.json` |

## How do I report a bug or request a feature?

Open an issue on [the kuali-connector repository](https://github.com/kualico/kuali-connector/issues). For security reports, email `security@kuali.co` — please don't disclose publicly before we've had a chance to respond.

## Is the Connector's source open?

The Connector repository and release downloads are public. The underlying Kuali Platform remains proprietary.
