# Troubleshooting

When something's off, start here. Two diagnostics catch most issues:

```bash
kuali doctor           # config, URL, auth, API reachability
kuali mcp verify       # MCP client config, binary path, permissions
```

Pass `--profile <name>` to scope to a specific profile. Pass `--client <name>` to `mcp verify` to inspect a specific AI client's config.

---

## The `kuali` command isn't found

Your shell can't find the binary on `PATH`.

=== "macOS / Linux"

    ```bash
    which kuali            # nothing? it's not on PATH
    ls /usr/local/bin/kuali ~/.local/bin/kuali 2>/dev/null
    ```

    If the file exists but isn't on `PATH`, add the containing directory to `PATH` in your shell config (`~/.zshrc`, `~/.bashrc`):

    ```bash
    export PATH="$HOME/.local/bin:$PATH"
    ```

    Then `source` the file or open a new terminal.

=== "Windows"

    Open a **new** PowerShell window — the one you installed in doesn't inherit the updated `PATH`. Still missing?

    ```powershell
    where.exe kuali
    Get-Item "$env:LOCALAPPDATA\Programs\kuali\kuali.exe"
    ```

    If the file exists, reopen PowerShell or sign out and back in so the new `PATH` entry takes effect.

## macOS blocks the binary

> *"kuali cannot be opened because the developer cannot be verified"*

macOS quarantines any executable downloaded from the web. Clear the flag:

```bash
xattr -d com.apple.quarantine $(which kuali)
```

Or go through the GUI: **System Settings → Privacy & Security**, scroll to Security, and click **Allow Anyway** next to the Connector entry.

## Windows SmartScreen warns me

On first launch you'll see *"Windows protected your PC"*. Click **More info**, then **Run anyway**. One-time; won't repeat.

## Authentication fails

> `Error: authentication failed (401)`

The API key is wrong, expired, or scoped to a different profile than the command is using.

```bash
kuali auth status --profile yourschool      # shows resolved URL + masked key
kuali doctor --profile yourschool           # verifies auth end-to-end
```

Common causes:

1. **Wrong profile.** `kuali auth status` without `--profile` shows the default profile. Pass `--profile` to see a specific one.
2. **Key was revoked.** Go to the Kuali web UI, **Settings → API Keys**, and check. Create a new one and re-run `kuali setup --profile yourschool --force` (or `kuali auth login --profile yourschool` if the URL is already correct).
3. **`KUALI_API_KEY` set in the environment.** A plain `KUALI_API_KEY` takes priority over every profile. Run `env | grep KUALI` to check; unset it and try again.

## Can't reach the Kuali instance

> `Error: dial tcp: ...` or `x509: certificate signed by unknown authority`

- **Typo in the URL?** `kuali config get api_url --profile yourschool` — compare to what you see when you log into the web UI.
- **VPN/firewall?** Try reaching it from a browser on the same machine. If the browser works and the Connector doesn't, check for a proxy set via `HTTPS_PROXY`.
- **Self-signed cert on a local instance?** Set `insecure: true` on the profile: `kuali config set insecure true --profile local`, or pass `-k` per command. Don't enable this against a production instance.

## MCP server fails to start in Claude / Codex / etc.

Run the diagnostic first — it'll tell you exactly which piece is wrong:

```bash
kuali mcp verify                                   # default: Claude Desktop
kuali mcp verify --client claude-code
kuali mcp verify --client codex
```

It checks five things: the client's MCP config file exists and parses, a `kuali` entry is registered, the binary path resolves and is executable (with a macOS quarantine-flag check), the API key resolves for the referenced profile, and the binary can run (`kuali version`).

Test the server outside the AI client:

```bash
kuali mcp 2>&1 | head -5
```

The process should stay running and print nothing to stdout (MCP uses stdio, so stdout is reserved for protocol messages). If it exits immediately with an error, read the stderr line — auth and config issues show up here first.

### I changed my API key and the assistant still fails

MCP clients cache the server config. Rerun setup, then restart the client:

```bash
kuali mcp setup --profile yourschool
```

For Claude Desktop, that means Cmd+Q and reopen — not just closing the window.

## The assistant says a tool doesn't exist

Check which tools are registered:

```bash
kuali mcp 2>&1 &
sleep 1
echo '{"jsonrpc":"2.0","id":1,"method":"tools/list"}' | kuali mcp
```

If expected tools are missing, you may have enabled read-only mode. `kuali mcp verify` shows the `args` array — look for `--tools read-only`.

## Multiple profiles, wrong one is used

Priority order for URL and API key resolution:

1. `--api-key` / `--profile` flag on the command
2. `KUALI_API_KEY` / `KUALI_API_URL` env vars (global — set these with care)
3. `KUALI_<PROFILE>_API_KEY` / `KUALI_<PROFILE>_API_URL` env vars
4. OS keychain (from `kuali auth login`)
5. `~/.kuali/credentials`
6. `api_key` field in `~/.kuali/config.yaml`

If a wrong profile is being chosen, it's almost always because a global `KUALI_API_KEY` or `KUALI_API_URL` is set and stomping on per-profile values. Unset it:

```bash
unset KUALI_API_KEY KUALI_API_URL
```

## Still stuck

Grab diagnostics:

```bash
kuali doctor --profile yourschool -o json > kuali-doctor.json
kuali mcp verify > kuali-mcp-verify.txt 2>&1
kuali version
```

Then [file an issue](../support.md) and attach the outputs. Redact the `api_key` field if any shows up (it shouldn't — `doctor` masks it by default).
