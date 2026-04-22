# Installation

The Kuali Connector is a single self-contained binary, around 20 MB, with no runtime dependencies. Pick the install method that suits you — any of them leave you with a `kuali` command on your `PATH`.

<div class="grid cards" markdown>

-   :fontawesome-brands-apple:{ .lg .middle } **[macOS](macos.md)**

    macOS 12 (Monterey) or later, Intel or Apple Silicon.

-   :fontawesome-brands-windows:{ .lg .middle } **[Windows](windows.md)**

    Windows 10 or later, 64-bit (amd64 or arm64).

-   :fontawesome-brands-linux:{ .lg .middle } **[Linux](linux.md)**

    Any modern 64-bit Linux distribution.

</div>

## Install methods at a glance

| Method | Best for | Command |
|---|---|---|
| Install script | macOS and Linux users who want one command | `curl -fsSL https://connector.kuali.co/install.sh \| sh` |
| Homebrew | Mac and Linux users who already use `brew` | `brew install kualico/tap/kuali` |
| Direct download | Windows users, air-gapped environments, CI runners | Grab the binary from the [releases page](https://github.com/kualico/kuali-connector/releases/latest) |

!!! tip "Auto-updates"
    Once installed, the Connector can update itself:
    ```bash
    kuali update check      # see if a newer version is out
    kuali update install    # replace the binary in place
    ```

## System requirements

- A 64-bit operating system (amd64 or arm64)
- An internet connection to reach your Kuali instance
- Permission to run an executable your organization hasn't pre-approved (see the macOS and Windows guides for the one-time "first-launch" approval dance)
- Optional: an [AI client that supports local MCP servers](../guides/index.md) — Claude Desktop, Claude Code, Codex CLI, Gemini CLI, Copilot CLI, or VS Code. (ChatGPT and other hosted-only clients aren't supported — see the [FAQ](../faq.md#does-it-work-with-chatgpt).)

## Verify your install

After installing on any platform:

```bash
kuali version
```

If you see a version number, you're ready — continue to [Getting started](../getting-started.md) to connect your Kuali instance and wire up your AI assistant.

If the command isn't found, check [Troubleshooting → `command not found`](../guides/troubleshooting.md#the-kuali-command-isnt-found).
