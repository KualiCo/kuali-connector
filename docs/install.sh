#!/bin/sh
set -e

REPO="KualiCo/kuali-connector"
BINARY="kuali"

# --- Library functions (sourceable for tests via KUALI_INSTALL_LIB_ONLY=1) ---

# Wrap curl for GitHub API calls. Adds Bearer auth header if GITHUB_TOKEN is set,
# which lets users behind shared NAT (and our own CI) avoid the 60/hour
# anonymous rate limit on api.github.com.
github_api_curl() {
    if [ -n "${GITHUB_TOKEN:-}" ]; then
        curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" "$@"
    else
        curl -fsSL "$@"
    fi
}

detect_profile() {
    shell_name="$(basename "${SHELL:-/bin/zsh}")"
    case "$shell_name" in
        zsh)
            echo "$HOME/.zshrc"
            ;;
        bash)
            if [ "$(uname -s)" = "Darwin" ]; then
                echo "$HOME/.bash_profile"
            else
                echo "$HOME/.bashrc"
            fi
            ;;
        *)
            echo ""
            ;;
    esac
}

configure_path() {
    install_dir="$1"
    case ":$PATH:" in
        *":${install_dir}:"*)
            return 0
            ;;
    esac
    profile="$(detect_profile)"
    block_marker="# >>> kuali init >>>"
    if [ -n "$profile" ] && ! grep -qF "$block_marker" "$profile" 2>/dev/null; then
        {
            printf '\n%s\n' "$block_marker"
            # shellcheck disable=SC2016
            # $PATH must remain literal so it expands when the user's shell loads.
            printf 'export PATH="%s:$PATH"\n' "$install_dir"
            printf '# <<< kuali init <<<\n'
        } >> "$profile"
        echo ""
        echo "Added $install_dir to your PATH in $profile"
        echo ""
        echo "To use kuali in this terminal window right now, run:"
        echo "  source $profile"
        echo ""
        echo "New terminal windows will pick this up automatically."
    elif [ -n "$profile" ]; then
        echo ""
        echo "$install_dir is already configured in $profile."
        echo "To use kuali in this terminal window, run:"
        echo "  source $profile"
    else
        echo ""
        echo "Warning: $install_dir is not on your PATH and the installer could not detect your shell."
        echo "Add this line to your shell profile:"
        echo "  export PATH=\"$install_dir:\$PATH\""
    fi
}

# --- Skip the installer body when sourced for tests ---

if [ "${KUALI_INSTALL_LIB_ONLY:-0}" = "1" ]; then
    # When sourced for tests, return; when executed directly, exit.
    # shellcheck disable=SC2317
    return 0 2>/dev/null || exit 0
fi

# --- Installer ---

INSTALL_DIR="${KUALI_INSTALL_DIR:-$HOME/.local/bin}"

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
VERSION=$(github_api_curl "https://api.github.com/repos/$REPO/releases/latest" 2>/dev/null | grep '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
if [ -z "$VERSION" ]; then
    VERSION=$(github_api_curl "https://api.github.com/repos/$REPO/releases" | grep -m1 '"tag_name"' | sed 's/.*"v\(.*\)".*/\1/')
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

mkdir -p "$INSTALL_DIR"
mv "$TMPFILE" "$INSTALL_DIR/$BINARY"

echo "kuali v${VERSION} installed to $INSTALL_DIR/$BINARY"

configure_path "$INSTALL_DIR"

echo ""
echo "Next steps:"
echo "  1. Run: kuali auth login"
echo "  2. Run: kuali mcp setup --client <your-ai-tool>"
echo "  3. Restart your AI tool"
