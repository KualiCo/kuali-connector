# Frequently asked questions

## Is the Connector free?

Yes. The Kuali Connector is free for any institution with an active Kuali subscription. You don't need an extra license.

## Do I need to be a developer or know how to program?

No. If you can copy and paste a command into Terminal or PowerShell, you can use the Connector. The [Getting started guide](getting-started.md) is written for people who've never used a command line before.

## Where does the Connector store my password?

It doesn't. The Connector uses your institution's single sign-on, same as the Kuali web app. Your password never touches the Connector — it goes directly to your campus identity provider.

After you sign in, the Connector saves a **token** (a revocable secret, not your password) on your computer in `~/.config/kuali/` (macOS/Linux) or `%USERPROFILE%\.config\kuali\` (Windows). You can revoke it any time with `kuali logout`.

## Is it safe to use on my work computer?

Yes. The Connector only talks to your institution's Kuali instance, over HTTPS, using the same authentication you already use. It doesn't phone home to Kuali, Inc. and doesn't collect telemetry.

If your campus IT department asks about approving it, point them at the [GitHub repository](https://github.com/kualico/kuali-connector) — all binaries are signed and the release process is public.

## Can I use the Connector on multiple computers?

Yes. Install it on every computer you want to use it on, and run `kuali login` on each.

## Will it work on my iPad / phone?

No. The Connector is a desktop tool — it requires a terminal. For mobile, use the Kuali web app in your browser.

## Does it work offline?

No. The Connector reads from and writes to your Kuali instance in real time. It needs an active connection.

## How do I update to a new version?

Re-run the same install command you used originally:

```bash
# macOS / Linux
curl -fsSL https://kualico.github.io/kuali-connector/install.sh | sh
```

```powershell
# Windows
iwr -useb https://kualico.github.io/kuali-connector/install.ps1 | iex
```

Or if you installed via Homebrew: `brew upgrade kuali-connector`.

## Can I script against the Connector? Automate things?

Yes — that's one of the main reasons it exists. See [Schedule automated exports](guides/common-tasks.md#schedule-automated-exports) for examples. For fully unattended automation, create a long-lived token with `kuali tokens create`.

## Is the source code open?

The **public release repository** with binaries is at [github.com/kualico/kuali-connector](https://github.com/kualico/kuali-connector). The Connector's source code is not currently open-sourced, but that may change in the future.

## I have a feature request or found a bug.

Open an issue at [github.com/kualico/kuali-connector/issues](https://github.com/kualico/kuali-connector/issues), or [contact us](support.md) directly.
