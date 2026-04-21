# Your first connection

After installing, the Connector needs to know **which Kuali instance to talk to** and **who you are**. This only has to be done once per computer.

## Before you start

You'll need:

- [x] The Connector installed and working (`kuali --version` returns a version)
- [x] The URL of your institution's Kuali instance (example: `https://myschool.kuali.co`) — ask your administrator if unsure
- [x] Your normal campus Kuali login

## 1. Point the Connector at your campus

```bash
kuali connect https://myschool.kuali.co
```

Replace `myschool.kuali.co` with your institution's actual Kuali URL. The Connector saves this so you don't have to type it again.

## 2. Sign in

```bash
kuali login
```

Your browser will open to your campus sign-in page. Sign in the same way you do for the Kuali web app. When you see "You can close this window," return to the terminal.

The Connector now has a secure token saved on your computer. You won't have to sign in again for several weeks, depending on your institution's policy.

## 3. Confirm it worked

```bash
kuali whoami
```

You should see your name, email, and the Kuali instance you're connected to.

## Working with multiple Kuali instances

If you work with more than one Kuali instance (for example, a sandbox and production), you can save each as a **named profile**:

```bash
kuali connect --profile sandbox https://sandbox.myschool.kuali.co
kuali connect --profile prod https://myschool.kuali.co
```

Switch between them with:

```bash
kuali use prod
```

Or pass `--profile` to any command:

```bash
kuali apps list --profile sandbox
```

## Where is my configuration saved?

| Platform | Location |
|---|---|
| macOS / Linux | `~/.config/kuali/` |
| Windows | `%USERPROFILE%\.config\kuali\` |

This folder contains your saved instance URLs and authentication tokens. It's protected so only your user account can read it. If you're reinstalling on a new machine, you can copy this folder to avoid re-authenticating — though signing in fresh is usually simpler.

## Signing out

```bash
kuali logout
```

This revokes your current token. Run `kuali login` again when you want to come back.
