# Install on Linux

The Connector supports any **modern 64-bit Linux distribution** (Ubuntu, Debian, Fedora, RHEL, Rocky, Arch, Alpine, …) on x86_64 or arm64.

## Option 1: Install script

```bash
curl -fsSL https://connector.kuali.co/install.sh | sh
```

The script auto-detects your architecture and installs to `/usr/local/bin/kuali`. If `/usr/local/bin` isn't writable by your user, it uses `sudo`.

??? tip "Install a specific version (prereleases or older builds)"
    Set `KUALI_VERSION` to any [published release tag](https://github.com/kualico/kuali-connector/releases) — with or without the `v` prefix:

    ```bash
    curl -fsSL https://connector.kuali.co/install.sh | KUALI_VERSION=1.0.0-rc14 sh
    ```

    Without `KUALI_VERSION`, the script installs the latest stable release.

## Option 2: Homebrew on Linux

If you use [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux):

```bash
brew update && brew install kualico/tap/kuali
```

## Option 3: Direct download (no sudo)

If you'd rather install without root access:

```bash
# Detect your architecture
ARCH=$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')

# Download the latest binary
curl -fsSL \
  -o ~/.local/bin/kuali \
  "https://github.com/kualico/kuali-connector/releases/latest/download/kuali-linux-${ARCH}"
chmod +x ~/.local/bin/kuali
```

Make sure `~/.local/bin` is on your `PATH`. Add this to `~/.bashrc` or `~/.zshrc` if it isn't:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then reload your shell (`source ~/.bashrc`) or open a new terminal.

## Verify

```bash
kuali version
```

## Keychain on Linux

The Connector uses the [libsecret](https://wiki.gnome.org/Projects/Libsecret) keychain (GNOME Keyring, KeePassXC, KDE Wallet) via D-Bus. On desktop Linux this Just Works. On headless servers the keychain is often unavailable — the Connector falls back to `~/.kuali/credentials` (mode 0600), or you can supply credentials via the `KUALI_API_KEY` / `KUALI_<PROFILE>_API_KEY` environment variables.

## Uninstall

=== "Installed to /usr/local"

    ```bash
    sudo rm /usr/local/bin/kuali
    rm -rf ~/.kuali
    ```

=== "Installed to ~/.local"

    ```bash
    rm ~/.local/bin/kuali
    rm -rf ~/.kuali
    ```

=== "Homebrew"

    ```bash
    brew uninstall kuali
    brew untap kualico/tap
    ```

If you stored API keys in the keychain, you can remove them via your desktop's secret-management tool (Seahorse, KDE Wallet Manager) or with `secret-tool clear service kuali-cli account <profile>`.
