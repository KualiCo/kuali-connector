# Install on macOS

The Connector supports **macOS 12 (Monterey) or later**, on both Intel and Apple Silicon (M1/M2/M3/M4) Macs.

## Option 1: Install script (recommended)

This is the fastest way. Open **Terminal** (press ++cmd+space++, type `Terminal`, press ++enter++) and paste:

```bash
curl -fsSL https://kualico.github.io/kuali-connector/install.sh | sh
```

The installer will:

1. Detect whether your Mac is Intel or Apple Silicon
2. Download the correct binary from the [latest release](https://github.com/kualico/kuali-connector/releases/latest)
3. Place it at `/usr/local/bin/kuali` (you'll be asked for your Mac password)
4. Print a confirmation message when it's done

Verify:

```bash
kuali --version
```

## Option 2: Homebrew

If you use [Homebrew](https://brew.sh):

```bash
brew install kualico/tap/kuali-connector
```

## Option 3: Manual download

1. Go to the [latest release](https://github.com/kualico/kuali-connector/releases/latest).
2. Download the file ending in `-darwin-arm64.tar.gz` (Apple Silicon) or `-darwin-amd64.tar.gz` (Intel).

    !!! question "Not sure which Mac you have?"
        Click the Apple menu :fontawesome-brands-apple: in the top-left corner, then **About This Mac**. Under "Chip" or "Processor," look for "Apple M1/M2/M3/M4" (Apple Silicon) or "Intel" (Intel).

3. Double-click the `.tar.gz` to extract it.
4. Move the extracted `kuali` file to a folder on your PATH, for example:

    ```bash
    sudo mv ~/Downloads/kuali /usr/local/bin/kuali
    sudo chmod +x /usr/local/bin/kuali
    ```

## "Apple cannot verify this developer" warning

The first time you run `kuali`, macOS may block it because the binary isn't notarized yet. If that happens:

1. Open **System Settings** → **Privacy & Security**
2. Scroll to the **Security** section
3. Click **Open Anyway** next to the message about `kuali`
4. Re-run your command in Terminal

Your campus IT department may have a policy that prevents this. If so, contact them and ask about getting the Kuali Connector approved.

## Uninstall

```bash
sudo rm /usr/local/bin/kuali
rm -rf ~/.config/kuali   # removes saved credentials and config
```
