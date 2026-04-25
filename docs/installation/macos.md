# Install on macOS

The Connector supports **macOS 12 (Monterey) or later** on both Intel and Apple Silicon Macs. Choose whichever method feels most natural.

## Option 1: Install script

One line, auto-detects your architecture, installs to `/usr/local/bin/kuali` (prompts for your password if needed):

```bash
curl -fsSL https://connector.kuali.co/install.sh | sh
```

## Option 2: Homebrew

If you already use [Homebrew](https://brew.sh):

```bash
brew update && brew install kualico/tap/kuali
```

Upgrade later with `brew upgrade kuali`, or let the Connector update itself with `kuali update install`.

## Option 3: Direct download

1. Open the [latest release](https://github.com/kualico/kuali-connector/releases/latest).
2. Download `kuali-darwin-arm64` for Apple Silicon (M1/M2/M3/M4) or `kuali-darwin-amd64` for Intel Macs. Not sure which you have? Apple menu → **About This Mac** → look at the "Chip" line.
3. In Terminal:

    ```bash
    chmod +x ~/Downloads/kuali-darwin-*
    sudo mv ~/Downloads/kuali-darwin-* /usr/local/bin/kuali
    ```

## First-launch approval

macOS may block the binary the first time you run it because it wasn't downloaded through the App Store.

!!! warning "If you see *"kuali cannot be opened because the developer cannot be verified"*"
    Open **System Settings → Privacy & Security**, scroll to the Security section, and click **Allow Anyway** next to the Connector entry. Then run `kuali version` again and click **Open** in the confirmation dialog.

    Or, from the terminal, clear the quarantine flag in one step:

    ```bash
    xattr -d com.apple.quarantine $(which kuali)
    ```

## Verify

```bash
kuali version
```

You should see something like `kuali 1.0.0-rc6 (commit …, built …)`. If not, open [Troubleshooting](../guides/troubleshooting.md).

## Uninstall

=== "Homebrew"

    ```bash
    brew uninstall kuali
    brew untap kualico/tap
    ```

=== "Script or direct download"

    ```bash
    sudo rm /usr/local/bin/kuali
    rm -rf ~/.kuali
    ```

The `~/.kuali` directory holds your config file and (if you used a plaintext credentials file) saved profiles. If you stored your API key in the keychain, also remove it with `security delete-generic-password -s kuali-cli` (repeat for each profile name).
