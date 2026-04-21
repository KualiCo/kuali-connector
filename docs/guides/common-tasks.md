# Common tasks

The handful of things most people use the Connector for, with real examples.

!!! note "Placeholder content"

    The examples below show the shape of what documentation here should look like. Update them to match your Connector's actual commands and use cases.

## Export documents to a spreadsheet

Download every submission for an application as a CSV you can open in Excel:

```bash
kuali export --app "Travel Authorization" --format csv --output travel.csv
```

Open `travel.csv` in Excel or Numbers. Each row is one submission.

### Filter what you export

Only export submissions from this fiscal year:

```bash
kuali export --app "Travel Authorization" \
  --from 2026-07-01 \
  --to 2026-06-30 \
  --format csv \
  --output travel-fy26.csv
```

Only export submissions you own:

```bash
kuali export --app "Travel Authorization" --mine --format csv --output my-travel.csv
```

## Run a saved report

```bash
kuali reports run "Monthly Research Summary"
```

Save the output as a PDF:

```bash
kuali reports run "Monthly Research Summary" --format pdf --output report.pdf
```

## Upload a file to a Kuali document

```bash
kuali files upload \
  --document DOC-12345 \
  --field "Supporting Documents" \
  ./budget.xlsx
```

## List pending approvals

```bash
kuali approvals list
```

Shows every item waiting for your action, with document IDs.

## Approve or send back a document

```bash
kuali approvals approve DOC-12345 --comment "Looks good — approved."
kuali approvals sendback DOC-12345 --comment "Please attach the revised budget."
```

## Schedule automated exports

Combine the Connector with your operating system's scheduler to run exports automatically.

=== "macOS / Linux (cron)"

    Run `crontab -e` and add a line. This exports travel data every Monday at 6 AM:

    ```cron
    0 6 * * 1 /usr/local/bin/kuali export --app "Travel Authorization" --format csv --output ~/Exports/travel-weekly.csv
    ```

=== "Windows (Task Scheduler)"

    1. Open **Task Scheduler**
    2. Create a new task
    3. Trigger: Weekly, Monday at 6 AM
    4. Action: Start a program → `kuali.exe` with arguments:

        ```
        export --app "Travel Authorization" --format csv --output C:\Exports\travel-weekly.csv
        ```

!!! tip "Authentication for scheduled runs"

    Scheduled jobs can't open a browser to sign in. Use a **long-lived token** for automation:

    ```bash
    kuali tokens create --name "weekly-export" --expires 90d
    ```

    Save the token somewhere safe and set `KUALI_TOKEN` as an environment variable in your scheduled job.

## Need something not listed here?

Run `kuali --help` to see every command, or browse the full [command reference](../reference/commands.md).
