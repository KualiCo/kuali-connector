# Get help

## Start with diagnostics

Two commands catch most setup issues:

```bash
kuali doctor              # config, URL, auth, API reachability
kuali mcp verify          # MCP client config, binary path, permissions
```

Pass `--profile <name>` to scope to a specific profile, or `--client <name>` to inspect an AI client's MCP configuration. The [troubleshooting guide](guides/troubleshooting.md) has a runbook for the usual failure modes.

## Your campus Kuali administrator

For questions about what data you should access, which apps you have permission for, or how your institution configures Kuali, your **campus Kuali administrator** is almost always the fastest path — they know your local setup. Ask your department contact or IT help desk if you're not sure who that is.

## File a bug, ask a question, or request a feature

Open an issue in the [kuali-connector repository](https://github.com/kualico/kuali-connector/issues).

Include with the issue:

- Output of `kuali version`
- Output of `kuali doctor --profile <name> -o json` (redact the masked key if it's still shown — it shouldn't be)
- For MCP issues: `kuali mcp verify --client <claude-desktop|claude-code|…>`
- OS and version
- The exact command you ran or the prompt you gave your AI assistant
- What you expected to happen and what actually happened

## Security

Email `security@kuali.co` for anything that might be a vulnerability. Please don't disclose publicly until we've had a chance to respond.

## Community

If you'd like to compare notes with other Kuali users, the Kuali Community forum (accessible via your institution's Kuali admin) is a good place for workflows, prompts, and automation recipes.
