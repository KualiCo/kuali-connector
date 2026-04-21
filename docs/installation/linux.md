# Install on Linux

The Connector supports any **modern 64-bit Linux distribution** (Ubuntu, Debian, Fedora, RHEL, Arch, etc.) on x86_64 or arm64.

## Option 1: Install script (recommended)

```bash
curl -fsSL https://kualico.github.io/kuali-connector/install.sh | sh
```

The installer detects your architecture, downloads the correct binary, and installs it to `/usr/local/bin/kuali` (you may be prompted for your password).

Verify:

```bash
kuali --version
```

## Option 2: Manual download

1. Go to the [latest release](https://github.com/kualico/kuali-connector/releases/latest).
2. Download the file matching your system:

    - `-linux-amd64.tar.gz` — most Intel/AMD systems
    - `-linux-arm64.tar.gz` — ARM systems (Raspberry Pi 4+, some cloud VMs)

    Not sure? Run `uname -m`. `x86_64` means amd64; `aarch64` means arm64.

3. Extract and install:

    ```bash
    tar -xzf kuali-connector-*-linux-*.tar.gz
    sudo mv kuali /usr/local/bin/kuali
    sudo chmod +x /usr/local/bin/kuali
    ```

## Install without sudo

If you don't have root access, install to your home directory:

```bash
mkdir -p ~/.local/bin
tar -xzf kuali-connector-*-linux-*.tar.gz -C ~/.local/bin
chmod +x ~/.local/bin/kuali
```

Make sure `~/.local/bin` is on your PATH. Add this to `~/.bashrc` or `~/.zshrc` if needed:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Uninstall

```bash
sudo rm /usr/local/bin/kuali    # or ~/.local/bin/kuali
rm -rf ~/.config/kuali          # saved credentials and config
```
