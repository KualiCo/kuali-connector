#!/bin/sh
# Unit tests for the library-mode functions in docs/install.sh.
#
# Sources install.sh with KUALI_INSTALL_LIB_ONLY=1 so the installer body
# is skipped and we can exercise detect_profile / configure_path directly.
#
# Run from repo root or any directory: tests/install_sh_test.sh

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SH="$REPO_ROOT/docs/install.sh"

if [ ! -f "$INSTALL_SH" ]; then
    echo "ERROR: $INSTALL_SH not found" >&2
    exit 1
fi

# shellcheck disable=SC2034
KUALI_INSTALL_LIB_ONLY=1
export KUALI_INSTALL_LIB_ONLY
# shellcheck source=docs/install.sh disable=SC1091
. "$INSTALL_SH"

PASS=0
FAIL=0
CURRENT_TEST=""

start_test() {
    CURRENT_TEST="$1"
}

assert_eq() {
    actual="$1"
    expected="$2"
    desc="$3"
    if [ "$actual" = "$expected" ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        printf 'FAIL [%s] %s\n  expected: %s\n  actual:   %s\n' \
            "$CURRENT_TEST" "$desc" "$expected" "$actual" >&2
    fi
}

assert_contains() {
    haystack="$1"
    needle="$2"
    desc="$3"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        printf 'FAIL [%s] %s\n  expected to find: %s\n  in:\n%s\n' \
            "$CURRENT_TEST" "$desc" "$needle" "$haystack" >&2
    fi
}

assert_not_contains() {
    haystack="$1"
    needle="$2"
    desc="$3"
    if printf '%s' "$haystack" | grep -qF -- "$needle"; then
        FAIL=$((FAIL + 1))
        printf 'FAIL [%s] %s\n  did not expect: %s\n  in:\n%s\n' \
            "$CURRENT_TEST" "$desc" "$needle" "$haystack" >&2
    else
        PASS=$((PASS + 1))
    fi
}

setup_test_env() {
    TEST_HOME="$(mktemp -d)"
    HOME="$TEST_HOME"
    export HOME
    PATH="/usr/bin:/bin"
    export PATH
}

teardown_test_env() {
    if [ -n "${TEST_HOME:-}" ] && [ -d "$TEST_HOME" ]; then
        rm -rf "$TEST_HOME"
    fi
    unset -f uname 2>/dev/null || true
}

# === detect_profile ===

# Mocked uname functions are invoked by detect_profile (sourced from install.sh).
# shellcheck disable=SC2317
test_detect_profile_zsh_macos() {
    start_test "detect_profile_zsh_macos"
    setup_test_env
    SHELL=/bin/zsh
    uname() { echo "Darwin"; }
    assert_eq "$(detect_profile)" "$HOME/.zshrc" "zsh on macOS -> ~/.zshrc"
    teardown_test_env
}

# shellcheck disable=SC2317
test_detect_profile_zsh_linux() {
    start_test "detect_profile_zsh_linux"
    setup_test_env
    SHELL=/usr/bin/zsh
    uname() { echo "Linux"; }
    assert_eq "$(detect_profile)" "$HOME/.zshrc" "zsh on Linux -> ~/.zshrc"
    teardown_test_env
}

# shellcheck disable=SC2317
test_detect_profile_bash_macos() {
    start_test "detect_profile_bash_macos"
    setup_test_env
    SHELL=/bin/bash
    uname() { echo "Darwin"; }
    assert_eq "$(detect_profile)" "$HOME/.bash_profile" "bash on macOS -> ~/.bash_profile"
    teardown_test_env
}

# shellcheck disable=SC2317
test_detect_profile_bash_linux() {
    start_test "detect_profile_bash_linux"
    setup_test_env
    SHELL=/bin/bash
    uname() { echo "Linux"; }
    assert_eq "$(detect_profile)" "$HOME/.bashrc" "bash on Linux -> ~/.bashrc"
    teardown_test_env
}

test_detect_profile_unknown_shell() {
    start_test "detect_profile_unknown_shell"
    setup_test_env
    SHELL=/usr/local/bin/fish
    assert_eq "$(detect_profile)" "" "fish (unknown) -> empty"
    teardown_test_env
}

# shellcheck disable=SC2317
test_detect_profile_empty_shell() {
    start_test "detect_profile_empty_shell"
    setup_test_env
    SHELL=""
    uname() { echo "Darwin"; }
    # Empty SHELL falls back to /bin/zsh per the function default.
    assert_eq "$(detect_profile)" "$HOME/.zshrc" "empty SHELL falls back to zsh"
    teardown_test_env
}

# === configure_path ===

test_configure_path_appends_marker_block() {
    start_test "configure_path_appends_marker_block"
    setup_test_env
    SHELL=/bin/zsh
    output="$(configure_path "$HOME/.local/bin" 2>&1)"
    profile_content="$(cat "$HOME/.zshrc" 2>/dev/null || printf '')"
    assert_contains "$profile_content" "# >>> kuali init >>>" "start marker present"
    assert_contains "$profile_content" "export PATH=\"$HOME/.local/bin:\$PATH\"" "PATH export present"
    assert_contains "$profile_content" "# <<< kuali init <<<" "end marker present"
    assert_contains "$output" "Added $HOME/.local/bin to your PATH in $HOME/.zshrc" "informs user of edit"
    assert_contains "$output" "source $HOME/.zshrc" "tells user to source profile"
    assert_contains "$output" "New terminal windows will pick this up automatically." "tells user new terminals work"
    teardown_test_env
}

test_configure_path_idempotent_re_run() {
    start_test "configure_path_idempotent_re_run"
    setup_test_env
    SHELL=/bin/zsh
    configure_path "$HOME/.local/bin" >/dev/null 2>&1
    first_content="$(cat "$HOME/.zshrc")"
    configure_path "$HOME/.local/bin" >/dev/null 2>&1
    second_content="$(cat "$HOME/.zshrc")"
    assert_eq "$second_content" "$first_content" "profile unchanged on re-run"
    marker_count="$(grep -c '# >>> kuali init >>>' "$HOME/.zshrc" || true)"
    assert_eq "$marker_count" "1" "exactly one marker after re-run"
    teardown_test_env
}

test_configure_path_already_on_path() {
    start_test "configure_path_already_on_path"
    setup_test_env
    SHELL=/bin/zsh
    PATH="$HOME/.local/bin:/usr/bin:/bin"
    export PATH
    output="$(configure_path "$HOME/.local/bin" 2>&1)"
    assert_eq "$output" "" "no output when already on PATH"
    if [ -e "$HOME/.zshrc" ]; then
        FAIL=$((FAIL + 1))
        printf 'FAIL [%s] no profile created when already on PATH\n' \
            "$CURRENT_TEST" >&2
    else
        PASS=$((PASS + 1))
    fi
    teardown_test_env
}

test_configure_path_no_shell_detected() {
    start_test "configure_path_no_shell_detected"
    setup_test_env
    SHELL=/usr/local/bin/fish
    output="$(configure_path "$HOME/.local/bin" 2>&1)"
    assert_contains "$output" "could not detect your shell" "warns user"
    assert_contains "$output" "export PATH=\"$HOME/.local/bin:\$PATH\"" "shows manual export"
    if [ -e "$HOME/.zshrc" ] || [ -e "$HOME/.bashrc" ] || [ -e "$HOME/.bash_profile" ]; then
        FAIL=$((FAIL + 1))
        printf 'FAIL [%s] no profile should be created for unknown shell\n' \
            "$CURRENT_TEST" >&2
    else
        PASS=$((PASS + 1))
    fi
    teardown_test_env
}

# === github_api_curl ===

# shellcheck disable=SC2317
test_github_api_curl_no_token_omits_auth_header() {
    start_test "github_api_curl_no_token_omits_auth_header"
    setup_test_env
    unset GITHUB_TOKEN
    # Override curl to echo its args; github_api_curl should NOT include -H Authorization.
    curl() { echo "$@"; }
    output="$(github_api_curl "https://api.github.com/test")"
    assert_not_contains "$output" "Authorization" "no auth header when GITHUB_TOKEN unset"
    assert_contains "$output" "https://api.github.com/test" "URL passed through"
    unset -f curl
    teardown_test_env
}

# shellcheck disable=SC2317
test_github_api_curl_with_token_adds_auth_header() {
    start_test "github_api_curl_with_token_adds_auth_header"
    setup_test_env
    GITHUB_TOKEN="fake-test-token"
    export GITHUB_TOKEN
    curl() { echo "$@"; }
    output="$(github_api_curl "https://api.github.com/test")"
    assert_contains "$output" "Authorization: Bearer fake-test-token" "auth header added when GITHUB_TOKEN set"
    assert_contains "$output" "https://api.github.com/test" "URL passed through"
    unset -f curl
    unset GITHUB_TOKEN
    teardown_test_env
}

# shellcheck disable=SC2317
test_github_api_curl_with_empty_token_omits_auth() {
    start_test "github_api_curl_with_empty_token_omits_auth"
    setup_test_env
    GITHUB_TOKEN=""
    export GITHUB_TOKEN
    curl() { echo "$@"; }
    output="$(github_api_curl "https://api.github.com/test")"
    assert_not_contains "$output" "Authorization" "no auth header when GITHUB_TOKEN empty"
    unset -f curl
    unset GITHUB_TOKEN
    teardown_test_env
}

# === resolve_version ===

# shellcheck disable=SC2317
test_resolve_version_env_var_pins_exact() {
    start_test "resolve_version_env_var_pins_exact"
    setup_test_env
    KUALI_VERSION="1.0.0-rc14"
    export KUALI_VERSION
    assert_eq "$(resolve_version)" "1.0.0-rc14" "KUALI_VERSION pinned exactly"
    unset KUALI_VERSION
    teardown_test_env
}

# shellcheck disable=SC2317
test_resolve_version_env_var_strips_v_prefix() {
    start_test "resolve_version_env_var_strips_v_prefix"
    setup_test_env
    KUALI_VERSION="v1.0.0-rc14"
    export KUALI_VERSION
    assert_eq "$(resolve_version)" "1.0.0-rc14" "leading v is stripped"
    unset KUALI_VERSION
    teardown_test_env
}

# shellcheck disable=SC2317
test_resolve_version_empty_env_var_falls_through_to_api() {
    start_test "resolve_version_empty_env_var_falls_through_to_api"
    setup_test_env
    KUALI_VERSION=""
    export KUALI_VERSION
    # Mock github_api_curl to return a stable release tag.
    github_api_curl() { echo '"tag_name": "v9.9.9"'; }
    assert_eq "$(resolve_version)" "9.9.9" "empty KUALI_VERSION uses API path"
    unset -f github_api_curl
    unset KUALI_VERSION
    teardown_test_env
}

# shellcheck disable=SC2317
test_resolve_version_unset_uses_api_stable() {
    start_test "resolve_version_unset_uses_api_stable"
    setup_test_env
    unset KUALI_VERSION
    github_api_curl() { echo '"tag_name": "v1.2.3"'; }
    assert_eq "$(resolve_version)" "1.2.3" "stable tag parsed from API"
    unset -f github_api_curl
    teardown_test_env
}

# shellcheck disable=SC2317
test_resolve_version_unset_falls_back_to_releases_list() {
    start_test "resolve_version_unset_falls_back_to_releases_list"
    setup_test_env
    unset KUALI_VERSION
    # First call (releases/latest) returns nothing; second (releases) returns RC.
    github_api_curl() {
        case "$1" in
            *releases/latest) return 0 ;;  # empty stdout
            *releases)        echo '"tag_name": "v1.0.0-rc14"' ;;
        esac
    }
    assert_eq "$(resolve_version)" "1.0.0-rc14" "falls back to first release in list"
    unset -f github_api_curl
    teardown_test_env
}

# shellcheck disable=SC2317
test_resolve_version_no_releases_returns_failure() {
    start_test "resolve_version_no_releases_returns_failure"
    setup_test_env
    unset KUALI_VERSION
    github_api_curl() { return 0; }  # both calls return empty stdout
    if output="$(resolve_version 2>&1)"; then
        FAIL=$((FAIL + 1))
        printf 'FAIL [%s] expected non-zero exit but got success (output: %s)\n' \
            "$CURRENT_TEST" "$output" >&2
    else
        PASS=$((PASS + 1))
    fi
    unset -f github_api_curl
    teardown_test_env
}

# shellcheck disable=SC2317
test_configure_path_existing_profile_with_other_content() {
    start_test "configure_path_existing_profile_with_other_content"
    setup_test_env
    SHELL=/bin/zsh
    printf 'alias ll="ls -la"\nexport EDITOR=vim\n' > "$HOME/.zshrc"
    configure_path "$HOME/.local/bin" >/dev/null 2>&1
    profile_content="$(cat "$HOME/.zshrc")"
    assert_contains "$profile_content" 'alias ll="ls -la"' "preserves existing alias"
    assert_contains "$profile_content" 'export EDITOR=vim' "preserves existing editor export"
    assert_contains "$profile_content" "# >>> kuali init >>>" "appends marker"
    teardown_test_env
}

# === Run all tests ===

test_detect_profile_zsh_macos
test_detect_profile_zsh_linux
test_detect_profile_bash_macos
test_detect_profile_bash_linux
test_detect_profile_unknown_shell
test_detect_profile_empty_shell
test_configure_path_appends_marker_block
test_configure_path_idempotent_re_run
test_configure_path_already_on_path
test_configure_path_no_shell_detected
test_configure_path_existing_profile_with_other_content
test_github_api_curl_no_token_omits_auth_header
test_github_api_curl_with_token_adds_auth_header
test_github_api_curl_with_empty_token_omits_auth
test_resolve_version_env_var_pins_exact
test_resolve_version_env_var_strips_v_prefix
test_resolve_version_empty_env_var_falls_through_to_api
test_resolve_version_unset_uses_api_stable
test_resolve_version_unset_falls_back_to_releases_list
test_resolve_version_no_releases_returns_failure

if [ "$FAIL" -gt 0 ]; then
    printf '\n%d failed, %d passed\n' "$FAIL" "$PASS" >&2
    exit 1
fi
printf '\nAll %d tests passed\n' "$PASS"
