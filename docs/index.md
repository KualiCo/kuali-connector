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
Ask Claude, Copilot, or any AI assistant that supports local MCP servers to pull data, build apps, move workflows, and run reports against your Kuali instance — in plain English, right from the chat you already use.
</p>

<div class="kuali-hero-actions" markdown>

[Get started in 5 minutes :material-arrow-right:](getting-started.md){ .md-button .md-button--primary }
[Prompt library :material-lightbulb-on-outline:](guides/prompts.md){ .md-button }

<span class="kuali-hero-hint" aria-hidden="true">start here</span>

</div>

</div>

<div class="kuali-preview-stack" markdown>

<div class="kuali-chat" role="img" aria-label="Example conversation with an AI assistant using the Kuali Connector"><div class="kuali-chat__chrome" aria-hidden="true"><span class="kuali-chat__dot kuali-chat__dot--r"></span><span class="kuali-chat__dot kuali-chat__dot--y"></span><span class="kuali-chat__dot kuali-chat__dot--g"></span><span class="kuali-chat__title">Claude · Kuali Connector</span></div><div class="kuali-chat__body" aria-hidden="true"><div class="kuali-chat__turn kuali-chat__turn--user"><span class="kuali-chat__avatar">JG</span><div class="kuali-chat__bubble"><p>Which curriculum proposals are stuck waiting on the Dean's Office for more than 10 days?</p></div></div><div class="kuali-chat__turn kuali-chat__turn--ai"><span class="kuali-chat__avatar">★</span><div class="kuali-chat__bubble"><p>I found 7 proposals sitting at the Dean's review step past your 10-day threshold. The oldest — BIO 4120 Ecology revision — has been there 23 days. Want me to list the approvers for each, or draft a nudge email?</p><span class="kuali-chat__tool">kuali_documents_list · kuali_workflows_status</span></div></div></div></div>

<div class="kuali-terminal" role="img" aria-label="Example terminal session using the Kuali Connector"><div class="kuali-terminal__chrome" aria-hidden="true"><span class="kuali-terminal__dot kuali-terminal__dot--r"></span><span class="kuali-terminal__dot kuali-terminal__dot--y"></span><span class="kuali-terminal__dot kuali-terminal__dot--g"></span><span class="kuali-terminal__title">~/kuali</span></div><div class="kuali-terminal__body" aria-hidden="true"><div><span class="tk-prompt">$</span> <span class="tk-cmd">kuali setup</span></div><div><span class="tk-dim">Profile "yourschool" saved · API key validated against https://yourschool.kualihub.com ✓</span></div><div>&nbsp;</div><div><span class="tk-prompt">$</span> <span class="tk-cmd">kuali mcp setup</span> <span class="tk-flag">--profile</span> <span class="tk-string">yourschool</span></div><div><span class="tk-dim">Wrote Claude Desktop config → restart Claude to finish</span> <span class="tk-ok">✓</span></div><div>&nbsp;</div><div><span class="tk-prompt">$</span> <span class="tk-cmd">_</span><span class="tk-caret"></span></div></div></div>

</div>

</div>

<section class="kuali-pitch" aria-label="Why the Kuali Connector" markdown>
<div class="kuali-pitch__item" markdown>
## Natural-language operations { .kuali-pitch__title }
<p class="kuali-pitch__body">Ask your assistant to list stalled documents, build a new app from a PDF form, or import a spreadsheet of users — and it will.</p>
</div>
<div class="kuali-pitch__item" markdown>
## Works with every major AI client { .kuali-pitch__title }
<p class="kuali-pitch__body">Claude Desktop, Claude Code, Codex CLI, Gemini CLI, GitHub Copilot, VS Code — one command wires the Connector into whichever you use.</p>
</div>
<div class="kuali-pitch__item" markdown>
## Your data stays yours { .kuali-pitch__title }
<p class="kuali-pitch__body">API keys live in your OS keychain. The assistant calls your Kuali instance directly from your machine — nothing routes through a third-party server.</p>
</div>
</section>

## Pick your path

<div class="grid cards" markdown>

-   <h3 class="kuali-card__title">:material-rocket-launch-outline:{ .lg .middle } Getting started</h3>

    ---

    Install the Connector, connect your Kuali instance, and wire up your first AI assistant in five minutes.

    [:octicons-arrow-right-24: Quick start](getting-started.md)

-   <h3 class="kuali-card__title">:material-lightbulb-on-outline:{ .lg .middle } Prompt library</h3>

    ---

    Copy-paste prompts for build apps, Curriculum Management, Sponsored Programs, CSV imports, workflow analysis, and chart reports.

    [:octicons-arrow-right-24: Prompts](guides/prompts.md)

-   <h3 class="kuali-card__title">:material-download-outline:{ .lg .middle } Installation</h3>

    ---

    Install via Homebrew, a one-line installer, or a direct binary download. macOS, Windows, and Linux supported.

    [:octicons-arrow-right-24: Install](installation/index.md)

-   <h3 class="kuali-card__title">:material-robot-outline:{ .lg .middle } AI assistants</h3>

    ---

    Set up Claude Desktop, Claude Code, Codex, Gemini, Copilot, or VS Code. Pick read-only mode if you only want the assistant to look.

    [:octicons-arrow-right-24: Guides](guides/index.md)

-   <h3 class="kuali-card__title">:material-console:{ .lg .middle } Command reference</h3>

    ---

    The complete `kuali` CLI — every resource, subcommand, and flag, with examples for both humans and scripts.

    [:octicons-arrow-right-24: Reference](reference/commands.md)

-   <h3 class="kuali-card__title">:material-tools:{ .lg .middle } MCP tool reference</h3>

    ---

    Every MCP tool your AI assistant can call — 91 resource tools, the `kuali_run` catch-all, and 3 connection-management tools (95 total) — grouped by resource, with read-only and destructive markings.

    [:octicons-arrow-right-24: MCP tools](reference/mcp-tools.md)

</div>

<div class="kuali-split" markdown>

<div class="kuali-split__main" markdown>

## What is the Kuali Connector?

The **Kuali Connector** is a small program that runs on your computer and lets your AI assistant talk to your Kuali instance on your behalf. It's a **local MCP server** — it speaks the [Model Context Protocol](https://modelcontextprotocol.io) (MCP) over stdio from your own machine, which is how tools like Claude Desktop, Claude Code, Codex CLI, Gemini CLI, and GitHub Copilot plug in external capabilities.

Once installed, you can ask your assistant things like *"create a Travel Authorization app with a PDF I just uploaded,"* *"import these 2,400 rows into the Human Ethics submissions dataset,"* or *"find proposals that haven't moved in two weeks and draft a nudge."* The assistant will call the Connector's tools, run the right GraphQL and REST calls against your Kuali instance, and stream the results back into the conversation.

The same binary also works as a full-featured CLI (`kuali apps list`, `kuali documents create`, `kuali export csv`, …) — handy for scripts, CI pipelines, or the moments when you'd rather just type a command.

</div>

<div class="kuali-callout" role="note" markdown>
<p class="kuali-callout__title">Is this a good fit?</p>

The Connector is for people who already interact with Kuali regularly — curriculum coordinators, research administrators, sponsored-programs officers, build-app owners, and platform admins — and who want their AI assistant to do the routine work for them. If your team uses Claude, Copilot, Gemini, or any other AI client that supports local MCP servers, you can put Kuali in front of it with one command. (ChatGPT isn't supported yet — see the [FAQ](faq.md#does-it-work-with-chatgpt) for why.)

If you only log into Kuali occasionally, the web app is probably still the fastest path.

</div>

</div>

## Is it secure?

Using the Connector doesn't expand what anyone can see or do in Kuali. Here's what that means in practice — one thing to read carefully, and five guarantees that hold by default.

<section class="kuali-security" aria-label="Kuali Connector security posture" markdown>

<article class="kuali-security__notice" markdown>

<header class="kuali-security__notice-head">
<span class="kuali-security__badge">Read this one</span>
<span class="kuali-security__notice-icon" aria-hidden="true"><svg viewBox="0 0 24 24" width="24" height="24"><path d="M6.5 20q-2.28 0-3.89-1.57Q1 16.85 1 14.58q0-1.95 1.17-3.48 1.18-1.53 3.08-1.95.63-2.3 2.5-3.72Q9.63 4 12 4q2.93 0 4.96 2.04Q19 8.07 19 11q1.73.2 2.86 1.5 1.14 1.28 1.14 3 0 1.88-1.31 3.19T18.5 20H13q-.82 0-1.41-.59Q11 18.83 11 18v-5.15L9.4 14.4 8 13l4-4 4 4-1.4 1.4-1.6-1.55V18h5.5q1.05 0 1.77-.73.73-.72.73-1.77t-.73-1.77Q19.55 13 18.5 13H17v-2q0-2.07-1.46-3.54Q14.08 6 12 6 9.93 6 8.46 7.46 7 8.93 7 11h-.5q-1.45 0-2.47 1.03Q3 13.05 3 14.5T4.03 17q1.02 1 2.47 1H9v2" fill="currentColor"/></svg></span>
</header>

### Data you ask about is sent to your AI provider

That's how AI tool use works: when the assistant calls a Connector tool, the result comes back to it for reasoning, and the **content of that response is sent to your AI vendor's model** (Anthropic, OpenAI, Google, GitHub, …) along with the rest of the conversation. Your API key isn't shared — but the data the tool returns becomes part of the prompt.

**Follow your institution's policy** on what may be shared with third-party AI services. If your campus restricts FERPA-covered records, HIPAA data, export-controlled research, or sponsor-confidential material, that restriction applies here. Check with your IT, compliance, or research-office contact before pointing the Connector at datasets you're unsure about — and consider [read-only mode](guides/read-only-mode.md) with a low-privilege API key to narrow what the assistant can ever pull.

</article>

<aside class="kuali-security__ledger" aria-labelledby="kuali-security-ledger-title">

### By default, always { #kuali-security-ledger-title .kuali-security__ledger-title }

<dl class="kuali-security__list">

<div class="kuali-security__row">
<dt class="kuali-security__row-term">
<span class="kuali-security__row-icon" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20"><path d="M5.8 10C5.4 8.8 4.3 8 3 8c-1.7 0-3 1.3-3 3s1.3 3 3 3c1.3 0 2.4-.8 2.8-2H7v2h2v-2h2v-2zM3 12c-.6 0-1-.4-1-1s.4-1 1-1 1 .4 1 1-.4 1-1 1m13-8c-2.2 0-4 1.8-4 4s1.8 4 4 4 4-1.8 4-4-1.8-4-4-4m0 6.1c-1.2 0-2.1-.9-2.1-2.1s.9-2.1 2.1-2.1 2.1.9 2.1 2.1-.9 2.1-2.1 2.1m0 2.9c-2.7 0-8 1.3-8 4v3h16v-3c0-2.7-5.3-4-8-4m6.1 5.1H9.9V17c0-.6 3.1-2.1 6.1-2.1s6.1 1.5 6.1 2.1z" fill="currentColor"/></svg></span>
<span class="kuali-security__row-head">You see only what your Kuali user sees</span>
</dt>
<dd class="kuali-security__row-text">Every call runs as the key's owner. If it's hidden from you in the web UI, it's hidden from the Connector and your assistant too.</dd>
</div>

<div class="kuali-security__row">
<dt class="kuali-security__row-term">
<span class="kuali-security__row-icon" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20"><path d="M21 11c0 5.55-3.84 10.74-9 12-5.16-1.26-9-6.45-9-12V5l9-4 9 4zm-9 10c3.75-1 7-5.46 7-9.78V6.3l-7-3.12L5 6.3v4.92C5 15.54 8.25 20 12 21m2.8-10V9.5C14.8 8.1 13.4 7 12 7S9.2 8.1 9.2 9.5V11c-.6 0-1.2.6-1.2 1.2v3.5c0 .7.6 1.3 1.2 1.3h5.5c.7 0 1.3-.6 1.3-1.2v-3.5c0-.7-.6-1.3-1.2-1.3m-1.3 0h-3V9.5c0-.8.7-1.3 1.5-1.3s1.5.5 1.5 1.3z" fill="currentColor"/></svg></span>
<span class="kuali-security__row-head">Your API key stays on your machine</span>
</dt>
<dd class="kuali-security__row-text">Stored in your OS keychain — macOS Keychain, Windows Credential Manager, or libsecret on Linux. Your AI vendor never sees it.</dd>
</div>

<div class="kuali-security__row">
<dt class="kuali-security__row-term">
<span class="kuali-security__row-icon" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20"><path d="M2 5.27 3.28 4 20 20.72 18.73 22l-3.08-3.08c-1.15.38-2.37.58-3.65.58-5 0-9.27-3.11-11-7.5.69-1.76 1.79-3.31 3.19-4.54zM12 9a3 3 0 0 1 3 3 3 3 0 0 1-.17 1L11 9.17A3 3 0 0 1 12 9m0-4.5c5 0 9.27 3.11 11 7.5a11.8 11.8 0 0 1-4 5.19l-1.42-1.43A9.86 9.86 0 0 0 20.82 12 9.82 9.82 0 0 0 12 6.5c-1.09 0-2.16.18-3.16.5L7.3 5.47c1.44-.62 3.03-.97 4.7-.97M3.18 12A9.82 9.82 0 0 0 12 17.5c.69 0 1.37-.07 2-.21L11.72 15A3.064 3.064 0 0 1 9 12.28L5.6 8.87c-.99.85-1.82 1.91-2.42 3.13" fill="currentColor"/></svg></span>
<span class="kuali-security__row-head">Read-only mode hides every write tool</span>
</dt>
<dd class="kuali-security__row-text"><code>kuali mcp setup --tools read-only</code> strips create / update / submit / approve / delete / import from the tool list — not flagged, hidden.</dd>
</div>

<div class="kuali-security__row">
<dt class="kuali-security__row-term">
<span class="kuali-security__row-icon" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20"><path d="M13.5 8H12v5l4.28 2.54.72-1.21-3.5-2.08zM13 3a9 9 0 0 0-9 9H1l3.96 4.03L9 12H6a7 7 0 0 1 7-7 7 7 0 0 1 7 7 7 7 0 0 1-7 7c-1.93 0-3.68-.79-4.94-2.06l-1.42 1.42A8.9 8.9 0 0 0 13 21a9 9 0 0 0 9-9 9 9 0 0 0-9-9" fill="currentColor"/></svg></span>
<span class="kuali-security__row-head">Everything lands in your audit log</span>
</dt>
<dd class="kuali-security__row-text">Same APIs as the web UI, same audit trail — tagged to the user whose API key was used.</dd>
</div>

<div class="kuali-security__row">
<dt class="kuali-security__row-term">
<span class="kuali-security__row-icon" aria-hidden="true"><svg viewBox="0 0 24 24" width="20" height="20"><path d="M14 15c0 1.11-.89 2-2 2a2 2 0 0 1-2-2c0-1.11.89-2 2-2a2 2 0 0 1 2 2m-.91 5c.12.72.37 1.39.72 2H6a2 2 0 0 1-2-2V10c0-1.11.89-2 2-2h1V6c0-2.76 2.24-5 5-5s5 2.24 5 5v2h1a2 2 0 0 1 2 2v3.09c-.33-.05-.66-.09-1-.09s-.67.04-1 .09V10H6v10zM9 8h6V6c0-1.66-1.34-3-3-3S9 4.34 9 6zm12.34 7.84-3.59 3.59-1.59-1.59L15 19l2.75 3 4.75-4.75z" fill="currentColor"/></svg></span>
<span class="kuali-security__row-head">TLS enforced and rate-limited</span>
</dt>
<dd class="kuali-security__row-text">Traffic is TLS-encrypted end-to-end. Requests from your AI assistant are rate-limited (5/sec sustained, burst of 10) so an overeager prompt can't hammer your instance.</dd>
</div>

</dl>

</aside>

</section>

For a deeper look: [Read-only mode](guides/read-only-mode.md), [how data flows through the assistant](faq.md#does-my-data-get-sent-to-openai-anthropic-google), [reporting a security issue](support.md#security).
