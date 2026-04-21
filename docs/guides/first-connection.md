# First connection

The Connector needs two pieces of information before it can do anything useful: **which Kuali instance to talk to** and **a Kuali API key that identifies you**. You only configure this once per machine.

## What you'll need

- Your Kuali instance URL — something like `https://yourschool.kualibuild.com` or `https://yourschool.kualihub.com`.
- A Kuali **API key**. Create one in the Kuali web UI under **Settings → API Keys**. The key inherits the permissions of the user that created it, so create it as the user whose access you want the Connector (and, by extension, your AI assistant) to have.

!!! info "API key, not your password"
    The Connector never handles your Kuali password. An API key is a signed token you can revoke any time from the same screen you created it on.

## 1. Save the instance URL

```bash
kuali config set api_url https://yourschool.kualibuild.com --profile myschool
```

The `--profile` flag is a label you pick. If you only ever talk to one Kuali instance, omit it — the Connector will use the default profile:

```bash
kuali config set api_url https://yourschool.kualibuild.com
```

The URL is written to `~/.kuali/config.yaml`.

## 2. Sign in

```bash
kuali auth login --profile myschool
```

You'll be prompted for the API key. The key is written to your OS keychain (macOS Keychain, Windows Credential Manager, or libsecret on Linux) — it never lands in a plaintext file you might accidentally commit or email.

## 3. Verify

```bash
kuali doctor --profile myschool
```

`doctor` runs six checks: config exists, URL is reachable, API key works, GraphQL responds, user identity resolves, and the Connector is up to date. Any failure gives you a specific remediation step.

A quick smoke test:

```bash
kuali apps list --profile myschool
```

You should see your institution's apps.

## Working with multiple environments

Most teams have at least a sandbox and a production instance. Give each one its own profile:

```bash
kuali config set api_url https://sandbox.kualibuild.com --profile sandbox
kuali auth login --profile sandbox

kuali config set api_url https://prod.kualibuild.com --profile prod
kuali auth login --profile prod
```

Then pick per command:

```bash
kuali apps list --profile sandbox
kuali apps list --profile prod
```

Set a default profile with the `KUALI_PROFILE` environment variable or:

```bash
kuali config set default_profile prod
```

### Per-profile env vars (handy for CI)

In automated environments you may not want to set up the keychain. The Connector reads API keys from profile-specific environment variables:

```bash
export KUALI_PROD_API_KEY=<key>
export KUALI_SANDBOX_API_KEY=<key>

kuali apps list --profile prod      # uses KUALI_PROD_API_KEY
kuali apps list --profile sandbox   # uses KUALI_SANDBOX_API_KEY
```

A plain `KUALI_API_KEY` still works and applies to all profiles, but it overrides the per-profile values — so avoid it when you have more than one environment.

## Where things live

| Item | Location |
|---|---|
| Config file | `~/.kuali/config.yaml` (Windows: `%USERPROFILE%\.kuali\config.yaml`) |
| API keys (primary) | OS keychain, service `kuali-cli`, account = profile name |
| API keys (fallback) | `~/.kuali/credentials`, mode 0600 |

## Sign out

```bash
kuali auth logout --profile myschool
```

Removes the stored key for that profile. The URL and other settings stay in the config file — run the command again with a new key whenever you're ready.

## Working with self-signed certificates

If you're talking to a local dev instance with a self-signed cert:

```bash
kuali config set insecure true --profile local
```

Or pass `-k` on any command. Don't turn this on for production.

## Next

- [Wire the Connector into an AI client](index.md#ai-assistant-guides)
- [See what you can ask for](prompts.md)
- [Restrict an assistant to read-only operations](read-only-mode.md)
