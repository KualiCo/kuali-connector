# Get started in 5 minutes

By the end of this page you'll have the Kuali Connector installed, connected to your Kuali instance, and wired into an AI assistant so you can ask questions in plain English.

!!! tip "What you'll need"
    - A Kuali instance URL (for example, `https://yourschool.kualihub.com`)
    - A Kuali API key — **Settings → API Keys** in the Kuali web UI. The key inherits your permissions, so **the Connector will only see what you can see**. If you're an admin, it sees admin things; if you're a reviewer, it sees what a reviewer sees.
    - An AI client you already use: [Claude Desktop](https://claude.ai/download), [Claude Code](https://www.anthropic.com/claude-code), Codex CLI, Gemini CLI, GitHub Copilot CLI, or VS Code with Copilot

---

## 1. Install the Connector

Pick whichever matches your setup. Full per-OS instructions are on the [install](installation/index.md) page.

=== "macOS / Linux"

    ```bash
    curl -fsSL https://connector.kuali.co/install.sh | sh
    ```

=== "Homebrew"

    ```bash
    brew install kualico/tap/kuali
    ```

=== "npx (no install)"

    ```bash
    npx @kualico/kuali-connector@latest --help
    ```

=== "Windows"

    Download `kuali-windows-amd64.exe` from the [latest release](https://github.com/kualico/kuali-connector/releases/latest), rename it to `kuali.exe`, and place it somewhere on your `PATH`.

Verify the binary is on your path:

```bash
kuali version
```

## 2. Connect your Kuali instance

Tell the Connector where your instance lives and sign in. The API key is written to your OS keychain (macOS Keychain, Windows Credential Manager, or libsecret on Linux) — it never lands in a plaintext file.

```bash
kuali config set api_url https://yourschool.kualihub.com --profile myschool
kuali auth login --profile myschool
```

`myschool` is just a label. If you only have one Kuali instance, you can omit `--profile` and the default profile is used. You can add more later by repeating both commands with a different `--profile` name (for example `sandbox`, `prod`, `staging`).

Check that everything is talking:

```bash
kuali doctor --profile myschool
```

You should see green ticks for URL, auth, and API reachability. If anything fails, jump to [troubleshooting](guides/troubleshooting.md).

## 3. Wire it into your AI assistant

One command reads your saved profile, finds your AI client's config file, and writes the Connector entry for you.

=== "Claude Desktop"

    ```bash
    kuali mcp setup --profile myschool
    ```

    Then fully quit and relaunch Claude Desktop.

=== "Claude Code"

    ```bash
    kuali mcp setup --profile myschool --client claude-code
    ```

=== "Codex / Gemini / Copilot / VS Code"

    ```bash
    kuali mcp setup --profile myschool --client codex
    kuali mcp setup --profile myschool --client gemini-cli
    kuali mcp setup --profile myschool --client copilot-cli
    kuali mcp setup --profile myschool --client vscode
    ```

!!! note "Want the assistant to look but not change anything?"
    Add `--tools read-only` to the setup command. Only read tools (list, get, export, search, status) are registered — create, update, submit, approve, and delete are hidden. See [Read-only mode](guides/read-only-mode.md).

Confirm the setup landed correctly:

```bash
kuali mcp verify
```

## 4. Ask your assistant something

Open Claude Desktop (or your chosen client) and try one of these:

> "List the first ten apps in our Kuali instance."

> "Which documents in the Travel Request app are awaiting my approval?"

> "Summarize how many submissions each Human Ethics reviewer has completed this quarter."

The assistant will call the appropriate MCP tools (`kuali_apps_list`, `kuali_workflows_actions`, `kuali_documents_list`, …) and surface the answer right in the conversation.

The [prompt library](guides/prompts.md) has dozens more — including prompts for building apps from PDFs, importing CSVs with column-mapping dialogs, analyzing workflows, and generating chart reports.

---

## Where to next

<div class="grid cards" markdown>

-   :material-lightbulb-on-outline:{ .lg .middle } **Prompt library**

    ---

    Ready-to-use prompts for curriculum, research, build apps, imports, workflow analysis, and reporting.

    [:octicons-arrow-right-24: Prompts](guides/prompts.md)

-   :material-robot-outline:{ .lg .middle } **Client-specific guides**

    ---

    Tips for Claude Desktop, Claude Code, Codex, Gemini, Copilot, and VS Code.

    [:octicons-arrow-right-24: AI assistants](guides/index.md)

-   :material-console:{ .lg .middle } **Use it as a CLI**

    ---

    Skip the chat — every capability is also a plain `kuali` command, ready for scripts and CI.

    [:octicons-arrow-right-24: Command reference](reference/commands.md)

</div>
