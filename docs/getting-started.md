# Getting started

This guide walks you through installing the Connector, signing in, and running your first command. It takes about **5 minutes**.

## Before you start

You'll need:

- [x] A computer running **macOS, Windows, or Linux**
- [x] An active **Kuali account** at your institution
- [x] Permission from your campus Kuali administrator to use the Connector (ask your administrator if unsure)

## 1. Install the Connector

Pick your operating system:

=== "macOS"

    Open **Terminal** (press ++cmd+space++, type `Terminal`, press ++enter++) and paste:

    ```bash
    curl -fsSL https://kualico.github.io/kuali-connector/install.sh | sh
    ```

    [Full macOS install guide :octicons-arrow-right-24:](installation/macos.md)

=== "Windows"

    Open **PowerShell** (press ++win++, type `PowerShell`, press ++enter++) and paste:

    ```powershell
    iwr -useb https://kualico.github.io/kuali-connector/install.ps1 | iex
    ```

    [Full Windows install guide :octicons-arrow-right-24:](installation/windows.md)

=== "Linux"

    Open your terminal and paste:

    ```bash
    curl -fsSL https://kualico.github.io/kuali-connector/install.sh | sh
    ```

    [Full Linux install guide :octicons-arrow-right-24:](installation/linux.md)

Verify the install worked:

```bash
kuali --version
```

You should see a version number like `kuali 1.0.0`. If you see "command not found," see [Troubleshooting](guides/troubleshooting.md).

## 2. Sign in to Kuali

```bash
kuali login
```

This opens your browser. Sign in with your normal campus credentials (the same ones you use for the Kuali web app). When you're done, you'll see a "You can close this window" message. Return to the terminal.

!!! info "Why does it open a browser?"

    The Connector uses the same single sign-on you use everywhere else on campus. Your password never touches the Connector — it stays with your institution's identity provider.

## 3. Run your first command

Try listing the Kuali applications you have access to:

```bash
kuali apps list
```

You should see a table of the apps available to you.

## What's next?

You're set up. Here's what to try next:

<div class="grid cards" markdown>

-   :material-connection:{ .lg .middle } **[Set up a connection](guides/first-connection.md)**

    Configure the Connector for your most common workflow.

-   :material-clipboard-list-outline:{ .lg .middle } **[Common tasks](guides/common-tasks.md)**

    Export data, run reports, and automate approvals.

-   :material-console:{ .lg .middle } **[Command reference](reference/commands.md)**

    Every command the Connector supports.

</div>
