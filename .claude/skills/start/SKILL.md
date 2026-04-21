---
name: start
description: Start the local MkDocs preview server for the Kuali Connector documentation site so the user can see edits live at http://127.0.0.1:8000. Use when the user says "/start", asks to start, launch, or preview the docs server, or asks to see the docs live.
---

# Start the docs preview server

Runs `mkdocs serve` in the background so the user can preview the Kuali Connector docs at **http://127.0.0.1:8000** with live reload on file changes.

## What to do

1. Check whether a server is already running on the default port:

   ```bash
   lsof -iTCP:8000 -sTCP:LISTEN -n -P 2>/dev/null | tail -n +2
   ```

   If something is already listening on 8000, tell the user and ask whether to stop it, pick a different port, or leave it alone. Don't kill processes without confirmation.

2. Start the server in the background from the repo root:

   ```bash
   python3 -m mkdocs serve --dev-addr 127.0.0.1:8000
   ```

   Use the `Bash` tool's `run_in_background: true` option. The server stays up until it's killed; you don't wait for it.

3. Give it a moment to bind, then report the URL back to the user (e.g. "Serving at http://127.0.0.1:8000 — live reload is on."). Do not poll in a sleep loop — trust that mkdocs is up unless the build fails.

4. If the user asks to stop or restart the server later, use the `KillShell` tool (or `Bash` to find and kill the PID by port).

## Options the user may ask for

- **Different port:** pass `--dev-addr 127.0.0.1:<port>`.
- **Strict mode:** add `--strict` so warnings become failures. Useful when the user is hunting a broken link.
- **Clean rebuild:** run `python3 -m mkdocs build` once first, then `serve`.

## Failure modes

- `mkdocs: command not found` — use `python3 -m mkdocs` instead (the Python module is installed but the wrapper script isn't on PATH).
- `ERROR - Config value 'plugins'` — a plugin is missing. Ask the user to install it (`pip install mkdocs-material mkdocs-glightbox mkdocs-git-revision-date-localized-plugin`).
- Port in use — back to step 1.
