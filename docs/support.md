# Get help

## Start with your campus Kuali administrator

For most questions — especially about what data you should export, which apps you have access to, or how your institution configures Kuali — your **campus Kuali administrator** is the fastest path. They know your local setup.

Not sure who that is? Ask your department's administrative contact or IT help desk.

## Help from Kuali

If your campus administrator can't resolve the issue, or the problem looks like a Connector bug:

<div class="grid cards" markdown>

-   :material-github:{ .lg .middle } **Open an issue**

    ---

    Bug reports and feature requests live on GitHub. Include the output of `kuali doctor`.

    [github.com/kualico/kuali-connector/issues :octicons-arrow-right-24:](https://github.com/kualico/kuali-connector/issues)

-   :material-email-outline:{ .lg .middle } **Email support**

    ---

    For account issues or anything sensitive you don't want public.

    [support@kuali.co :octicons-arrow-right-24:](mailto:support@kuali.co)

-   :material-forum-outline:{ .lg .middle } **Community**

    ---

    Ask other Kuali users — often the fastest answer.

    [Kuali Community :octicons-arrow-right-24:](https://community.kuali.co)

</div>

## Before you reach out

Running `kuali doctor` and including its output saves a lot of back-and-forth:

```bash
kuali doctor
```

This prints your version, configuration location, network status, and authentication status — everything a support engineer needs to help you.

If you're reporting a bug, also include:

- [x] Your operating system and version
- [x] The exact command you ran
- [x] The full output, including any error
- [x] What you expected to happen instead

## Security issues

If you've found a **security vulnerability**, please don't post it in a public issue. Email [security@kuali.co](mailto:security@kuali.co) instead. We'll respond within one business day.
