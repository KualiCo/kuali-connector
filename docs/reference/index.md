# Reference

Everything the Kuali Connector exposes, in both shapes.

<div class="grid cards" markdown>

-   :material-console:{ .lg .middle } **[CLI commands](commands.md)**

    The complete `kuali` command — every resource, subcommand, and flag, for scripts and terminals.

-   :material-tools:{ .lg .middle } **[MCP tools](mcp-tools.md)**

    Every MCP tool your AI assistant can call — 91 resource tools plus 3 connection-management tools (94 total), grouped by resource, marked read-only or destructive.

</div>

!!! info "They mirror each other"
    Every CLI subcommand is exposed as an MCP tool with the same behavior. `kuali documents list --app X` and `kuali_documents_list({ app: "X" })` execute the same code path. If you can do it on the command line, your AI assistant can do it too.
