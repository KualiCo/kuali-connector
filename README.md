# Kuali Connector

A command-line tool for interacting with Kuali from your own computer.

**📖 Documentation: <https://kualico.github.io/kuali-connector/>**

**⬇️ Downloads: [Latest release](https://github.com/kualico/kuali-connector/releases/latest)**

## Quick install

```bash
# macOS / Linux
curl -fsSL https://kualico.github.io/kuali-connector/install.sh | sh
```

```powershell
# Windows
iwr -useb https://kualico.github.io/kuali-connector/install.ps1 | iex
```

Then see [Getting started](https://kualico.github.io/kuali-connector/getting-started/).

## About this repository

This public repository hosts:

- **Release binaries** of the Kuali Connector (under [Releases](https://github.com/kualico/kuali-connector/releases))
- **End-user documentation** (source in [`docs/`](./docs), published to GitHub Pages)

The Connector's source code lives in a separate private repository. If you've found a bug or have a feature request, please [open an issue](https://github.com/kualico/kuali-connector/issues).

## Contributing to the docs

Documentation is authored in Markdown in the `docs/` folder and built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

### Run locally

```bash
pip install mkdocs-material mkdocs-glightbox mkdocs-git-revision-date-localized-plugin
mkdocs serve
```

Open <http://127.0.0.1:8000>. Changes reload automatically.

### Publishing

Any push to `main` that touches `docs/` or `mkdocs.yml` triggers [`.github/workflows/docs.yml`](./.github/workflows/docs.yml), which builds the site and deploys it to GitHub Pages.

## License

See [LICENSE](./LICENSE).
