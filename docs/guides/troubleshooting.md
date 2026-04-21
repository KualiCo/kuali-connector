# Troubleshooting

When the Connector isn't working, start here. If nothing below helps, [contact us](../support.md) with the output of `kuali doctor`.

## `command not found: kuali`

Your shell can't find the Connector. The binary either isn't installed, or it isn't on your PATH.

=== "macOS / Linux"

    Check whether it's installed:

    ```bash
    ls -la /usr/local/bin/kuali
    ```

    If the file exists but the command still isn't found, your PATH doesn't include `/usr/local/bin`. Add this to `~/.zshrc` (macOS) or `~/.bashrc` (Linux):

    ```bash
    export PATH="/usr/local/bin:$PATH"
    ```

    Then restart your terminal.

=== "Windows"

    Open PowerShell and run:

    ```powershell
    Get-Command kuali
    ```

    If that fails, the install location isn't on your PATH. Review the [Windows install guide](../installation/windows.md) and confirm you added the Connector's folder to your user PATH.

## "Apple cannot verify this developer" on macOS

See the [macOS install guide](../installation/macos.md#apple-cannot-verify-this-developer-warning). Short version: **System Settings → Privacy & Security → Open Anyway**.

## "Windows protected your PC" warning

See the [Windows install guide](../installation/windows.md#smartscreen-warning). Click **More info** → **Run anyway**.

## `kuali login` opens the browser but nothing happens after I sign in

The Connector is waiting for your browser to hand back an authentication code. Usually this works automatically, but sometimes a firewall or browser extension blocks it.

Try:

1. Close the browser tab that was opened, return to the terminal, press ++ctrl+c++ to cancel
2. Run `kuali login --no-browser` instead — it will print a code for you to paste into the browser manually

If that still fails, a campus firewall may be blocking the Connector from listening on the callback port. Contact your IT department with this error.

## "Authentication expired" or 401 errors

Your saved token has expired. Sign in again:

```bash
kuali login
```

## "Could not connect to Kuali"

The Connector can't reach your institution's Kuali instance.

1. Confirm the URL is correct:

    ```bash
    kuali whoami
    ```

2. Try loading the Kuali web app in your browser. If it works in the browser but not the Connector, the issue is almost certainly a campus firewall or VPN requirement.
3. If you're off-campus, check whether your institution requires a VPN to reach Kuali. Connect to the VPN and try again.

## The Connector hangs or runs very slowly

Run with verbose logging to see what it's doing:

```bash
kuali --verbose <your command>
```

This will print each network request. If everything is stuck on a single request, your network is the likely culprit.

## I'm still stuck

Run the built-in diagnostics:

```bash
kuali doctor
```

This checks:

- Connector version
- Configuration location and permissions
- Network connectivity to your Kuali instance
- Authentication token status

Copy the output and include it when you [contact support](../support.md). It saves a lot of back-and-forth.

## Filing a bug report

If you think you've found a bug, open an issue at [github.com/kualico/kuali-connector/issues](https://github.com/kualico/kuali-connector/issues). Include:

- Your operating system and version
- The output of `kuali --version`
- The exact command you ran
- The full output, including any error message
