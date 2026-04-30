# Get started

About 15 minutes if it's your first time. By the end, the Kuali Connector will be installed on your computer, connected to your Kuali instance, and answering questions inside your AI assistant.

> Already comfortable with terminals and APIs? Skip to [Installation](installation/index.md) for the dense version.

## Step 0: Install an AI assistant

The Connector plugs into an AI assistant you already have. If you don't have one yet, install **Claude Desktop** — it's the path with the fewest moving parts and the rest of this page assumes it.

[Download Claude Desktop](https://claude.ai/download){ .md-button .md-button--primary }

Already using Claude Code, Codex CLI, Gemini CLI, GitHub Copilot CLI, or VS Code with Copilot? You're set — keep going.

## Step 1: Get your Kuali API key

An **API key** is a long secret password that lets the Connector sign in to Kuali on your behalf. The key inherits *your* permissions — anything hidden from you in Kuali stays hidden from the Connector and your AI assistant.

1. Sign in to Kuali in your browser.
2. Go to **Settings → API Keys**.
3. Generate a new key and copy it somewhere safe for the next few minutes — you'll paste it once and then it's stored securely.

You'll also need your **Kuali address** — the part after `https://` in the URL bar when you're signed in. For example, if you sign in at `https://yourschool.kualihub.com`, your address is `yourschool.kualihub.com`.

## Step 2: Open Terminal

Every step from here happens in a small text-only window called **Terminal** (sometimes called a *command line* or *shell*). You'll paste one command at a time and press <kbd>Return</kbd>. Nothing on this page can damage your computer — but if it's your first time, take a breath.

=== "macOS"

    Press <kbd>⌘</kbd> + <kbd>Space</kbd>, type `Terminal`, and press <kbd>Return</kbd>. A window opens with a line of text waiting for input — that's where commands go.

=== "Windows"

    Press <kbd>Win</kbd> + <kbd>X</kbd> and choose **Terminal** (Windows 11) or **Windows PowerShell** (Windows 10).

=== "Linux"

    Press <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd>, or look in your application menu for **Terminal** or **Console**.

!!! tip "Use the copy button"
    Every code block on this page has a copy button in its top-right corner. Click it, switch to Terminal, paste with <kbd>⌘</kbd>+<kbd>V</kbd> (macOS), <kbd>Ctrl</kbd>+<kbd>V</kbd> (Windows), or <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd> (Linux), and press <kbd>Return</kbd>. Don't retype commands by hand — copy-paste avoids typos.

## Step 3: Install the Connector

In Terminal, paste the line for your operating system and press <kbd>Return</kbd>:

=== "macOS / Linux"

    ```bash
    curl -fsSL https://connector.kuali.co/install.sh | sh
    ```

=== "Windows"

    ```powershell
    irm https://connector.kuali.co/install.ps1 | iex
    ```

You'll see a few lines of progress, then Terminal returns to a blank prompt. Check the install worked:

```bash
kuali version
```

You should see a version number (something like `kuali 0.5.0`).

**What just happened:** a small program called `kuali` is now on your computer. It's the bridge between your AI assistant and Kuali.

??? note "Prefer Homebrew or a manual download?"
    See the [Installation guide](installation/index.md) for Homebrew, direct binary downloads, and signature verification.

## Step 4: Connect to your Kuali instance

```bash
kuali setup
```

You'll be asked two questions:

1. **Your Kuali address** — paste the address from Step 1 (e.g. `yourschool.kualihub.com`).
2. **Your API key** — paste the key you copied. The text is hidden as you paste; that's expected.

When it finishes, you'll see something like `Profile "yourschool" saved · API key validated ✓`.

**What just happened:** the Connector confirmed your key works and stored it in your computer's secure password manager (the macOS Keychain or Windows Credential Manager). The key is never written to a plain file on disk.

Now run a quick health check:

```bash
kuali doctor
```

You should see green checkmarks for URL, authentication, and API reachability. If anything fails, jump to [troubleshooting](guides/troubleshooting.md).

## Step 5: Connect the Connector to your AI assistant

One more command. Pick the tab for your assistant.

=== "Claude Desktop"

    ```bash
    kuali mcp setup
    ```

    Then **fully quit** Claude Desktop and reopen it. (Closing the window isn't enough — right-click the Claude icon and choose **Quit**, or use <kbd>⌘</kbd>+<kbd>Q</kbd> on macOS.)

=== "Claude Code"

    ```bash
    kuali mcp setup --client claude-code
    ```

??? note "Using Codex, Gemini, Copilot, or VS Code instead?"
    Run whichever line matches your client:

    ```bash
    kuali mcp setup --client codex
    kuali mcp setup --client gemini-cli
    kuali mcp setup --client copilot-cli
    kuali mcp setup --client vscode
    ```

Confirm the assistant can see the Connector:

```bash
kuali mcp verify
```

**What just happened:** your AI assistant now knows how to call the Connector. When you ask it a Kuali question, it can fetch the answer directly from your instance.

!!! tip "Want the assistant to look but never change anything?"
    Re-run setup with read-only mode:

    ```bash
    kuali mcp setup --tools read-only
    ```

    Only the *list*, *get*, *search*, and *export* tools stay registered — *create*, *update*, *submit*, *approve*, *delete*, and *import* are hidden. See [Read-only mode](guides/read-only-mode.md).

## Step 6: Ask your assistant something

You're done with Terminal. Open your AI assistant and type one of these prompts into the chat window:

> "List the first ten apps in our Kuali instance."

> "Which documents in the Travel Request app are awaiting my approval?"

> "Summarize how many submissions each Human Ethics reviewer has completed this quarter."

The assistant will fetch the answer from Kuali and reply in plain English.

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
