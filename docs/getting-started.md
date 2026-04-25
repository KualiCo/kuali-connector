# Get started in 5 minutes

By the end of this page you'll have the Kuali Connector installed, connected to your Kuali instance, and wired into an AI assistant so you can ask questions in plain English.

!!! tip "What you'll need"
    - A Kuali instance URL (for example, `https://yourschool.kualihub.com`)
    - A Kuali API key — **Settings → API Keys** in the Kuali web UI. The key inherits your permissions, so **the Connector will only see what you can see**. If you're an admin, it sees admin things; if you're a reviewer, it sees what a reviewer sees.
    - An AI client you already use: [Claude Desktop](https://claude.ai/download), [Claude Code](https://www.anthropic.com/claude-code), Codex CLI, Gemini CLI, GitHub Copilot CLI, or VS Code with Copilot

---

!!! info "Every command on this page runs in a terminal"
    The steps below are typed into a terminal (also called a *command line*, *shell*, or *command prompt*) — **not** into your AI assistant's chat window or a browser address bar. If you've never opened one before:

    === "macOS"

        Press <kbd>⌘</kbd> + <kbd>Space</kbd>, type `Terminal`, and press <kbd>Return</kbd>. Or open **Finder → Applications → Utilities → Terminal**. You'll see a window with a prompt like `yourname@Mac ~ %` — that's where commands go.

    === "Linux"

        Press <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd> on most distros (GNOME, KDE, Xfce). Or look in your application menu for **Terminal**, **Console**, **Konsole**, or **GNOME Terminal**. The prompt looks like `yourname@host:~$`.

    === "Windows"

        Press <kbd>Win</kbd> + <kbd>X</kbd> and choose **Terminal** or **Windows PowerShell**. On Windows 11 the default is Windows Terminal; on Windows 10, PowerShell. The prompt looks like `PS C:\Users\yourname>`.

    Type each command exactly as shown (use the copy button in the top-right of each code block), then press <kbd>Return</kbd> / <kbd>Enter</kbd>. Do **not** type the prompt characters (`$`, `%`, `PS >`) — they're just visual cues that the terminal is ready for input.

## 1. Install the Connector

Pick whichever matches your setup. Full per-OS instructions are on the [install](installation/index.md) page.

=== "macOS / Linux"

    Run in **Terminal**:

    ```bash
    curl -fsSL https://connector.kuali.co/install.sh | sh
    ```

=== "Homebrew (macOS / Linux)"

    Run in **Terminal**:

    ```bash
    brew update && brew install kualico/tap/kuali
    ```

=== "Windows"

    Run in **PowerShell**:

    ```powershell
    irm https://connector.kuali.co/install.ps1 | iex
    ```

    Prefer to download the `.exe` yourself? See the [Windows install guide](installation/windows.md).

Verify the binary is on your path. Run in your terminal (Terminal on macOS/Linux, PowerShell on Windows):

```bash
kuali version
```

## 2. Connect your Kuali instance

Tell the Connector where your instance lives and sign in. The API key is written to your OS keychain (macOS Keychain, Windows Credential Manager, or libsecret on Linux) — it never lands in a plaintext file.

Run the guided setup in your terminal:

```bash
kuali setup
```

You'll be asked for two things:

1. **Your Kuali hostname** — for example `yourschool.kualihub.com` (paste a full URL if that's easier; `https://` and trailing paths are stripped).
2. **Your API key** — input is hidden as you type or paste.

`kuali setup` derives both the API URL (`https://` + hostname) and a profile name (the subdomain — `yourschool` in the example above) from that single hostname, validates the key against your Kuali instance, and saves the result. The first profile you create is used automatically; if you later add a second instance, `setup` will offer to switch the default.

!!! tip "Prefer non-interactive, or scripting it?"
    Pass everything as flags to skip prompts:

    ```bash
    kuali setup --hostname yourschool.kualihub.com --api-key YOUR_KEY
    ```

    Add `--profile myname` to override the auto-derived profile name, `--force` to overwrite an existing profile, or `--default=false` to avoid changing the default profile pointer.

??? note "Fallback: the two-step flow"
    `kuali setup` is the recommended path, but the original two-command flow still works if you need finer control (for example `http://` for local development):

    ```bash
    kuali config set api_url https://yourschool.kualihub.com --profile yourschool
    kuali auth login --profile yourschool
    ```

Check that everything is talking — still in the same terminal window:

```bash
kuali doctor --profile yourschool
```

You should see green ticks for URL, auth, and API reachability. If anything fails, jump to [troubleshooting](guides/troubleshooting.md).

## 3. Wire it into your AI assistant

One command reads your saved profile, finds your AI client's config file, and writes the Connector entry for you. Run it in the same terminal.

=== "Claude Desktop"

    ```bash
    kuali mcp setup --profile yourschool
    ```

    Then fully quit and relaunch Claude Desktop.

=== "Claude Code"

    ```bash
    kuali mcp setup --profile yourschool --client claude-code
    ```

=== "Codex / Gemini / Copilot / VS Code"

    Run whichever line matches the client you use:

    ```bash
    kuali mcp setup --profile yourschool --client codex
    kuali mcp setup --profile yourschool --client gemini-cli
    kuali mcp setup --profile yourschool --client copilot-cli
    kuali mcp setup --profile yourschool --client vscode
    ```

!!! note "Want the assistant to look but not change anything?"
    Add `--tools read-only` to the setup command. Only read tools (list, get, export, search, status) are registered — create, update, submit, approve, and delete are hidden. See [Read-only mode](guides/read-only-mode.md).

Confirm the setup landed correctly — again, in the terminal:

```bash
kuali mcp verify
```

## 4. Ask your assistant something

You're done with the terminal — the remaining steps happen inside your AI client. Open Claude Desktop (or your chosen client) and type one of these prompts into the **chat window**:

> "List the first ten apps in our Kuali instance."

> "Which documents in the Travel Request app are awaiting my approval?"

> "Summarize how many submissions each Human Ethics reviewer has completed this quarter."

The assistant will call the appropriate MCP tools (`kuali_apps_list`, `kuali_workflows_actions`, `kuali_documents_list`, …) and surface the answer right in the conversation.

The [prompt library](guides/prompts.md) has dozens more — including prompts for building apps from PDFs, importing CSVs with column-mapping dialogs, analyzing workflows, and generating chart reports.

---

## Where to next

<div class="grid cards" markdown>

-   <h3 class="kuali-card__title">:material-lightbulb-on-outline:{ .lg .middle } Prompt library</h3>

    ---

    Ready-to-use prompts for curriculum, research, build apps, imports, workflow analysis, and reporting.

    [:octicons-arrow-right-24: Prompts](guides/prompts.md)

-   <h3 class="kuali-card__title">:material-robot-outline:{ .lg .middle } Client-specific guides</h3>

    ---

    Tips for Claude Desktop, Claude Code, Codex, Gemini, Copilot, and VS Code.

    [:octicons-arrow-right-24: AI assistants](guides/index.md)

-   <h3 class="kuali-card__title">:material-console:{ .lg .middle } Use it as a CLI</h3>

    ---

    Skip the chat — every capability is also a plain `kuali` command, ready for scripts and CI.

    [:octicons-arrow-right-24: Command reference](reference/commands.md)

</div>
