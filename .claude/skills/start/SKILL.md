---
name: start
description: Start the local MkDocs preview server for the Kuali Connector documentation site so the user can see edits live at http://127.0.0.1:8000/. Use when the user says "/start", asks to start, launch, or preview the docs server, or asks to see the docs live.
---

# Start the docs preview server

Runs `mkdocs serve` in the background so the user can preview the Kuali Connector docs at **http://127.0.0.1:8000/** with live reload.

## What to do

1. **Stop any existing mkdocs server first.** Stale servers hold the port and their file-watchers may be stuck, which is the main reason live reload stops working. Kill them before starting a fresh one:

   ```bash
   pkill -f "mkdocs serve" 2>/dev/null; sleep 1
   lsof -iTCP:8000 -sTCP:LISTEN -n -P 2>/dev/null | awk 'NR>1 {print $2}' | xargs -r kill 2>/dev/null
   sleep 1
   ```

   If `lsof` still shows a process on 8000, tell the user and ask before killing anything that isn't mkdocs.

2. **Start the server** in the background from the repo root. Three settings matter here — together they're what makes live reload reliable on macOS:

   ```bash
   MKDOCS_LIVERELOAD=poll \
     python3 -m mkdocs serve \
       --dev-addr 127.0.0.1:8000 \
       --watch overrides \
       --watch docs/stylesheets
   ```

   - `MKDOCS_LIVERELOAD=poll` — forces watchdog into polling mode. The default fsevents-backed observer on macOS silently drops file-change events under load (especially when the `git-revision-date-localized` plugin fans out file reads on startup). Polling is 1–2s slower to detect changes but never misses them.
   - `--watch overrides` — mkdocs only auto-watches `docs/` and `mkdocs.yml`. The `overrides/` directory (theme template overrides) needs to be added explicitly.
   - `--watch docs/stylesheets` — mkdocs ignores asset subdirectories of `docs/` for live reload even though it serves them. Without this, CSS edits require a manual restart.
   - Do **not** use `--dirty`. It makes CSS/template edits unreliable: mkdocs treats only the originally-changed markdown page as needing rebuild, so the served stylesheet goes stale until a full rebuild is triggered.

   Use the `Bash` tool's `run_in_background: true` option. Don't wait for it.

3. **Report the URL back to the user:**

   > Serving at http://127.0.0.1:8000/ — live reload is on (polling mode, also watching overrides/).

   Do not poll in a sleep loop. Trust that mkdocs is up unless the build fails.

4. If the user asks to stop the server later, use `pkill -f "mkdocs serve"` or kill by PID.

## Options the user may ask for

- **Different port:** change `--dev-addr 127.0.0.1:<port>`.
- **Strict mode:** add `--strict` so warnings become failures. Useful when hunting a broken link.
- **Faster reload (at the cost of reliability):** drop `MKDOCS_LIVERELOAD=poll` and use the default fsevents observer.

## Failure modes

- `mkdocs: command not found` — use `python3 -m mkdocs` (the Python module is installed but the wrapper script isn't on PATH). The command above already does this.
- `ERROR - Config value 'plugins'` — a plugin is missing. Install with:
  ```bash
  pip install mkdocs-material mkdocs-glightbox mkdocs-git-revision-date-localized-plugin
  ```
- **Port 8000 still in use after `pkill`** — something other than mkdocs is listening. Run the `lsof` check from step 1, tell the user what process owns it, and ask how to proceed.
- **Live reload not firing on file changes** — usually a leftover stale server from a previous session. Step 1's `pkill` handles it. If it persists, the user should close and reopen the terminal (Python runtime occasionally gets wedged) and retry.
