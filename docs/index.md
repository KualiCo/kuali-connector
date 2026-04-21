---
hide:
  - navigation
  - toc
---

<div class="kuali-hero" markdown>

<div class="kuali-hero-copy" markdown>

<span class="kuali-eyebrow">Kuali Connector <span class="kuali-eyebrow__pill">Preview</span></span>

# Connect <span class="kuali-hero-mark">Kuali</span> to your AI assistant.

<p class="kuali-hero-lede">
Ask Claude, Copilot, or any MCP-compatible assistant to pull data, build apps, move workflows, and run reports against your Kuali instance — in plain English, right from the chat you already use.
</p>

<div class="kuali-hero-actions" markdown>

[Get started in 5 minutes :material-arrow-right:](getting-started.md){ .md-button .md-button--primary }
[Prompt library :material-lightbulb-on-outline:](guides/prompts.md){ .md-button }

<span class="kuali-hero-hint" aria-hidden="true">start here</span>

</div>

</div>

<div class="kuali-preview-stack" markdown>

<aside class="kuali-chat" aria-label="Example conversation with an AI assistant using the Kuali Connector"><div class="kuali-chat__chrome" aria-hidden="true"><span class="kuali-chat__dot kuali-chat__dot--r"></span><span class="kuali-chat__dot kuali-chat__dot--y"></span><span class="kuali-chat__dot kuali-chat__dot--g"></span><span class="kuali-chat__title">Claude · Kuali Connector</span></div><div class="kuali-chat__body"><div class="kuali-chat__turn kuali-chat__turn--user"><span class="kuali-chat__avatar" aria-hidden="true">JG</span><div class="kuali-chat__bubble"><p>Which curriculum proposals are stuck waiting on the Dean's Office for more than 10 days?</p></div></div><div class="kuali-chat__turn kuali-chat__turn--ai"><span class="kuali-chat__avatar" aria-hidden="true">★</span><div class="kuali-chat__bubble"><p>I found 7 proposals sitting at the Dean's review step past your 10-day threshold. The oldest — BIO 4120 Ecology revision — has been there 23 days. Want me to list the approvers for each, or draft a nudge email?</p><span class="kuali-chat__tool">kuali_documents_list · kuali_workflows_status</span></div></div></div></aside>

<aside class="kuali-terminal" aria-label="Example terminal session using the Kuali Connector"><div class="kuali-terminal__chrome" aria-hidden="true"><span class="kuali-terminal__dot kuali-terminal__dot--r"></span><span class="kuali-terminal__dot kuali-terminal__dot--y"></span><span class="kuali-terminal__dot kuali-terminal__dot--g"></span><span class="kuali-terminal__title">~/kuali</span></div><div class="kuali-terminal__body"><div><span class="tk-prompt">$</span> <span class="tk-cmd">kuali auth login</span> <span class="tk-flag">--profile</span> <span class="tk-string">myschool</span></div><div><span class="tk-dim">API key saved to keychain for profile "myschool" ✓</span></div><div>&nbsp;</div><div><span class="tk-prompt">$</span> <span class="tk-cmd">kuali mcp setup</span> <span class="tk-flag">--profile</span> <span class="tk-string">myschool</span></div><div><span class="tk-dim">Wrote Claude Desktop config → restart Claude to finish</span> <span class="tk-ok">✓</span></div><div>&nbsp;</div><div><span class="tk-prompt">$</span> <span class="tk-cmd">_</span><span class="tk-caret" aria-hidden="true"></span></div></div></aside>

</div>

</div>

<section class="kuali-pitch" aria-label="Why the Kuali Connector">
<div class="kuali-pitch__item">
<p class="kuali-pitch__title">Natural-language operations</p>
<p class="kuali-pitch__body">Ask your assistant to list stalled documents, build a new app from a PDF form, or import a spreadsheet of users — and it will.</p>
</div>
<div class="kuali-pitch__item">
<p class="kuali-pitch__title">Works with every major AI client</p>
<p class="kuali-pitch__body">Claude Desktop, Claude Code, Codex CLI, Gemini CLI, GitHub Copilot, VS Code — one command wires the Connector into whichever you use.</p>
</div>
<div class="kuali-pitch__item">
<p class="kuali-pitch__title">Your data stays yours</p>
<p class="kuali-pitch__body">API keys live in your OS keychain. The assistant calls your Kuali instance directly from your machine — nothing routes through a third-party server.</p>
</div>
</section>

## Pick your path

<div class="grid cards" markdown>

-   :material-rocket-launch-outline:{ .lg .middle } **Getting started**

    ---

    Install the Connector, connect your Kuali instance, and wire up your first AI assistant in five minutes.

    [:octicons-arrow-right-24: Quick start](getting-started.md)

-   :material-lightbulb-on-outline:{ .lg .middle } **Prompt library**

    ---

    Copy-paste prompts for build apps, Curriculum Management, Sponsored Programs, CSV imports, workflow analysis, and chart reports.

    [:octicons-arrow-right-24: Prompts](guides/prompts.md)

-   :material-download-outline:{ .lg .middle } **Installation**

    ---

    Install via Homebrew, `npx`, a one-line installer, or a direct binary download. macOS, Windows, and Linux supported.

    [:octicons-arrow-right-24: Install](installation/index.md)

-   :material-robot-outline:{ .lg .middle } **AI assistants**

    ---

    Set up Claude Desktop, Claude Code, Codex, Gemini, Copilot, or VS Code. Pick read-only mode if you only want the assistant to look.

    [:octicons-arrow-right-24: Guides](guides/index.md)

-   :material-console:{ .lg .middle } **Command reference**

    ---

    The complete `kuali` CLI — every resource, subcommand, and flag, with examples for both humans and scripts.

    [:octicons-arrow-right-24: Reference](reference/commands.md)

-   :material-tools:{ .lg .middle } **MCP tool reference**

    ---

    All 94 MCP tools your AI assistant can call, grouped by resource, with read-only and destructive markings.

    [:octicons-arrow-right-24: MCP tools](reference/mcp-tools.md)

</div>

<div class="kuali-split" markdown>

<div class="kuali-split__main" markdown>

## What is the Kuali Connector?

The **Kuali Connector** is a small program that runs on your computer and lets your AI assistant talk to your Kuali instance on your behalf. It speaks the [Model Context Protocol](https://modelcontextprotocol.io) (MCP), which is the open standard that tools like Claude Desktop, Claude Code, Codex, Gemini CLI, and GitHub Copilot use to plug in external capabilities.

Once installed, you can ask your assistant things like *"create a Travel Authorization app with a PDF I just uploaded,"* *"import these 2,400 rows into the Human Ethics submissions dataset,"* or *"find proposals that haven't moved in two weeks and draft a nudge."* The assistant will call the Connector's tools, run the right GraphQL and REST calls against your Kuali instance, and stream the results back into the conversation.

The same binary also works as a full-featured CLI (`kuali apps list`, `kuali documents create`, `kuali export csv`, …) — handy for scripts, CI pipelines, or the moments when you'd rather just type a command.

</div>

<div class="kuali-callout" role="note" markdown>
<p class="kuali-callout__title">Is this a good fit?</p>

The Connector is for people who already interact with Kuali regularly — curriculum coordinators, research administrators, sponsored-programs officers, build-app owners, and platform admins — and who want their AI assistant to do the routine work for them. If your team uses Claude, Copilot, Gemini, or any other MCP-capable tool, you can put Kuali in front of it with one command.

If you only log into Kuali occasionally, the web app is probably still the fastest path.

</div>

</div>
