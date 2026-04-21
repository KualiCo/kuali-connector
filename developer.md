# Developer guide

How the Kuali Connector docs site is built, previewed, and deployed. If you're an end user looking for how to **use** the Connector, go to <https://connector.kuali.co> instead.

## Repository layout

```
kuali-connector/
├── .github/workflows/docs.yml   ← Builds and deploys the site to GitHub Pages
├── .claude/skills/start/        ← Claude Code skill: /start runs mkdocs serve
├── docs/                        ← Documentation source (Markdown + CSS)
├── overrides/                   ← MkDocs Material theme overrides
├── mkdocs.yml                   ← Site config (nav, theme, plugins)
└── readme.md                    ← The user-facing README you're not reading
```

The Connector's binary source code lives in a separate repository.

## Run the docs locally

```bash
pip install mkdocs-material mkdocs-glightbox mkdocs-git-revision-date-localized-plugin
python3 -m mkdocs serve
```

Open <http://127.0.0.1:8000>. Edits to anything under `docs/`, `overrides/`, or `mkdocs.yml` hot-reload.

If you use Claude Code, the `/start` slash command in this repo does the same thing — see [`.claude/skills/start/SKILL.md`](./.claude/skills/start/SKILL.md).

## Build locally (what CI does)

```bash
python3 -m mkdocs build --strict
```

Output lands in `site/`. `--strict` turns warnings into failures and is what the deploy workflow runs.

## Deploy

Any push to `main` that touches `docs/`, `overrides/`, or `mkdocs.yml` triggers [`.github/workflows/docs.yml`](./.github/workflows/docs.yml), which:

1. Installs the Python dependencies
2. Runs `mkdocs build --strict`
3. Uploads the `site/` directory as a GitHub Pages artifact
4. Deploys via `actions/deploy-pages@v4`

The live site is served at <https://connector.kuali.co>. The custom domain is configured via:

- `docs/CNAME` (points GitHub Pages at the hostname)
- `site_url` in `mkdocs.yml` (canonical URL + sitemap)
- DNS `CNAME` record: `connector.kuali.co → kualico.github.io.`
- Repository **Settings → Pages → Custom domain**

## Making changes

| I want to… | Edit |
|---|---|
| Add a page | Create it under `docs/`, add it to `nav:` in `mkdocs.yml` |
| Change the home page | `docs/index.md` |
| Change styling / add a component | `docs/stylesheets/extra.css` |
| Override a theme template | A file under `overrides/` |
| Update the preview banner | `overrides/main.html` |
| Update the CLI or MCP reference | `docs/reference/commands.md` and `docs/reference/mcp-tools.md` |

Verify every command or flag you reference against the Connector source — the docs promise accuracy.

## Auto-generating the command reference (planned)

`docs/reference/commands.md` is currently maintained by hand. The eventual release workflow will:

1. After a successful Connector release, a script generates Markdown from `kuali --help` output
2. That Markdown replaces the content in `docs/reference/commands.md`
3. A PR is opened against this repo; CI runs `mkdocs build --strict`; the PR can auto-merge on green

Until that exists, update the reference pages manually when commands change.

## Release binaries

Binaries are built in the Connector source repository by [`goreleaser`](https://goreleaser.com) and published as GitHub releases on this repo. The release workflow also refreshes the Homebrew formula at `kualico/homebrew-tap`. End users install via the script at `connector.kuali.co/install.sh`, Homebrew, `npx`, or a direct binary download.

## Filing issues

Bugs, feature requests, and docs issues: <https://github.com/kualico/kuali-connector/issues>. Security reports: `security@kuali.co` — please don't disclose publicly before we respond.
