# Installation

Install the Kuali Connector on your computer. Pick your operating system:

<div class="grid cards" markdown>

-   :fontawesome-brands-apple:{ .lg .middle } **[macOS](macos.md)**

    macOS 12 (Monterey) or later, Intel or Apple Silicon.

-   :fontawesome-brands-windows:{ .lg .middle } **[Windows](windows.md)**

    Windows 10 or later, 64-bit.

-   :fontawesome-brands-linux:{ .lg .middle } **[Linux](linux.md)**

    Any modern 64-bit Linux distribution.

</div>

## System requirements

The Connector is a single small binary (under 20 MB). It needs:

- A 64-bit operating system
- An internet connection to talk to your Kuali instance
- Permission to run executables (your campus IT may need to approve this — see the platform-specific guides)

## Verifying your install

After installing on any platform, confirm the Connector is working:

```bash
kuali --version
```

If you see a version number, you're ready. Head to [Getting started](../getting-started.md) to sign in and run your first command.

If you see an error, see [Troubleshooting](../guides/troubleshooting.md).
