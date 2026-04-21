---
hide:
  - navigation
  - toc
---

<div class="kuali-hero" markdown>

<div class="kuali-hero-copy" markdown>

<span class="kuali-eyebrow">Kuali Connector · Preview</span>

# Move data between your computer and <span class="kuali-hero-mark">Kuali</span>, from the terminal.

<p class="kuali-hero-lede">
A small command-line tool that downloads and reconciles transactions, pulls reports, and automates approvals — without logging into the web app every time.
</p>

<div class="kuali-hero-actions" markdown>

[Get started in 5 minutes :material-arrow-right:](getting-started.md){ .md-button .md-button--primary }
[Download latest :material-download:](https://github.com/kualico/kuali-connector/releases/latest){ .md-button }

<span class="kuali-hero-hint" aria-hidden="true">start here</span>

</div>

</div>

<aside class="kuali-terminal" aria-label="Example terminal session using the Kuali Connector"><div class="kuali-terminal__chrome" aria-hidden="true"><span class="kuali-terminal__dot kuali-terminal__dot--r"></span><span class="kuali-terminal__dot kuali-terminal__dot--y"></span><span class="kuali-terminal__dot kuali-terminal__dot--g"></span><span class="kuali-terminal__title">~/kuali</span></div><div class="kuali-terminal__body"><div><span class="tk-prompt">$</span><span class="tk-cmd">kuali login</span></div><div><span class="tk-dim">Opening your browser… signed in as j.garcia@example.edu ✓</span></div><div>&nbsp;</div><div><span class="tk-prompt">$</span><span class="tk-cmd">kuali reports export</span> <span class="tk-flag">--id</span> <span class="tk-string">"Q1-grants"</span> <span class="tk-flag">--out</span> <span class="tk-string">./out.csv</span></div><div><span class="tk-dim">Exporting 1,248 rows…</span></div><div><span class="tk-ok">done</span> <span class="tk-dim">→ out.csv (312 KB) in 4.2s</span></div><div>&nbsp;</div><div><span class="tk-prompt">$</span><span class="tk-cmd">_</span><span class="tk-caret" aria-hidden="true"></span></div></div></aside>

</div>

<section class="kuali-pitch" aria-label="What the Connector is for">
<div class="kuali-pitch__item">
<p class="kuali-pitch__title">Routine work, one command</p>
<p class="kuali-pitch__body">Exports, reports, reconciliations — the tasks you run every week, done in seconds instead of clicks.</p>
</div>
<div class="kuali-pitch__item">
<p class="kuali-pitch__title">Built for non-developers</p>
<p class="kuali-pitch__body">If you can paste a line into Terminal or PowerShell, you're ready. No install experience required.</p>
</div>
<div class="kuali-pitch__item">
<p class="kuali-pitch__title">Safe by default</p>
<p class="kuali-pitch__body">Uses your campus single sign-on. Your password never touches the Connector — ever.</p>
</div>
</section>

## Pick your path

<div class="grid cards" markdown>

-   :material-rocket-launch-outline:{ .lg .middle } **Getting started**

    ---

    Install the Connector, sign in to your Kuali account, and run your first command.

    [:octicons-arrow-right-24: Quick start](getting-started.md)

-   :material-download-outline:{ .lg .middle } **Installation**

    ---

    Step-by-step install guides for macOS, Windows, and Linux. No terminal experience required.

    [:octicons-arrow-right-24: Install](installation/index.md)

-   :material-book-open-variant:{ .lg .middle } **Guides**

    ---

    How to connect, run common tasks, and troubleshoot when things don't work.

    [:octicons-arrow-right-24: Guides](guides/index.md)

-   :material-console:{ .lg .middle } **Command reference**

    ---

    Every command and option the Connector supports, with examples.

    [:octicons-arrow-right-24: Reference](reference/commands.md)

-   :material-help-circle-outline:{ .lg .middle } **FAQ**

    ---

    Answers to the questions we hear most often from faculty and staff.

    [:octicons-arrow-right-24: FAQ](faq.md)

-   :material-lifebuoy:{ .lg .middle } **Get help**

    ---

    Stuck? Here's how to reach our team and your campus Kuali administrator.

    [:octicons-arrow-right-24: Support](support.md)

</div>

## What is the Connector?

The **Kuali Connector** is a small program you run on your own computer. It talks to your institution's Kuali system on your behalf — so routine tasks that used to take several minutes of clicking can happen with a single command.

You don't need to be a developer to use it. If you can copy and paste a line into Terminal or PowerShell, you can use the Connector.

<div class="kuali-callout" role="note" markdown>
<p class="kuali-callout__title">Not sure if this is for you?</p>

If you regularly export data from Kuali, run the same reports on a schedule, or move information between Kuali and another system (Excel, your SIS, a shared drive), the Connector will save you time.

If you only log into Kuali occasionally, you probably don't need it — the web app is fine.

</div>
