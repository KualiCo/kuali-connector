# Setup instructions

One-time setup to get the docs site live. You only do this once.

## 1. Copy these files into the `kuali-connector` repo

Drop everything from this scaffold into the root of your `kualico/kuali-connector` repository, preserving the folder structure:

```
kuali-connector/
├── .github/workflows/docs.yml    ← new
├── docs/                         ← new
├── mkdocs.yml                    ← new
└── README.md                     ← update or replace
```

Commit and push to `main`.

## 2. Enable GitHub Pages with Actions as the source

1. Go to <https://github.com/kualico/kuali-connector/settings/pages>
2. Under **Build and deployment** → **Source**, select **GitHub Actions**
3. You don't need to select a branch — the workflow handles deployment

That's it. The first push to `main` that touches `docs/` or `mkdocs.yml` will trigger `.github/workflows/docs.yml`. You can also trigger it manually from the Actions tab ("Run workflow").

## 3. (Optional) Set up a custom domain

If you want `docs.kualiconnector.com` or `connector.kuali.co` instead of `kualico.github.io/kuali-connector`:

1. Create a file `docs/CNAME` containing just your domain, for example:

    ```
    connector.kuali.co
    ```

2. At your DNS provider, add a CNAME record pointing that hostname to `kualico.github.io`
3. In repo **Settings → Pages**, enter the custom domain and check **Enforce HTTPS**
4. Also update `site_url` in `mkdocs.yml` to your new URL

## 4. Add the logo and favicon

The config references these files — add them or remove the references in `mkdocs.yml`:

- `docs/assets/logo.svg` — shown in the top-left header
- `docs/assets/favicon.png` — browser tab icon

A 32×32 or 48×48 PNG is fine for the favicon. The logo renders small, so simple shapes work best.

## 5. Preview locally before pushing

```bash
pip install mkdocs-material mkdocs-glightbox mkdocs-git-revision-date-localized-plugin
mkdocs serve
```

Open <http://127.0.0.1:8000>. Edit files in `docs/` and the browser reloads automatically.

## 6. Auto-generating the command reference (later)

When you're ready to automate `docs/reference/commands.md` from the `kuali-cli` release workflow, the shape is:

1. In `kualibuild/kuali-cli`, after a successful release, run a script that:
   - Generates markdown from `kuali --help` output (or a dedicated `kuali docs generate` subcommand)
   - Checks out `kualico/kuali-connector` using a PAT or GitHub App token
   - Writes the generated markdown between the `BEGIN GENERATED` / `END GENERATED` markers in `docs/reference/commands.md`
   - Commits and opens a PR

2. You can auto-merge these PRs if CI passes, or leave them for review.

Ask me when you're ready to wire this up and I'll draft the release-side workflow.

## What to edit first

Before you publish publicly, review and update:

- `docs/index.md` — the hero copy and the "What is the Connector?" section
- `docs/guides/common-tasks.md` — the placeholder examples. Replace with actual commands that work against your Connector
- `docs/reference/commands.md` — either fill in the real command list manually, or wait until the auto-gen workflow is ready
- `docs/support.md` — confirm the email addresses and community link are right
- `mkdocs.yml` — check the `site_url`, `repo_url`, and social links

Everything else should be close enough to ship.
