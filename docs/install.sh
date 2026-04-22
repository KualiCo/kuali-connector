#!/bin/sh
set -e

REPO="KualiCo/kuali-connector"
INSTALL_DIR="/usr/local/bin"
BINARY="kuali"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
    darwin) OS="darwin" ;;
    linux)  OS="linux" ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

ARCH=$(uname -m)
case "$ARCH" in
    x86_64|amd64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)             echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

# Prefer the latest stable release; fall back to the most recent published
# release (including prereleases) so installs work during the RC phase.
VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
if [ -z "$VERSION" ]; then
    VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases" | grep -m1 '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
fi
if [ -z "$VERSION" ]; then
    echo "Failed to determine latest version"
    exit 1
fi

URL="https://github.com/$REPO/releases/download/v${VERSION}/${BINARY}-${OS}-${ARCH}"
echo "Downloading kuali v${VERSION} for ${OS}/${ARCH}..."
TMPFILE=$(mktemp)
curl -fsSL -o "$TMPFILE" "$URL"
chmod +x "$TMPFILE"

if [ -w "$INSTALL_DIR" ]; then
    mv "$TMPFILE" "$INSTALL_DIR/$BINARY"
else
    echo "No write permission to $INSTALL_DIR, trying with sudo..."
    sudo mv "$TMPFILE" "$INSTALL_DIR/$BINARY"
fi

echo "kuali v${VERSION} installed to $INSTALL_DIR/$BINARY"
echo ""
echo "Next steps:"
echo "  1. Run: kuali auth login"
echo "  2. Run: kuali mcp setup --client <your-ai-tool>"
echo "  3. Restart your AI tool"
