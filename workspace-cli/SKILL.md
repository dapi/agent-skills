---
name: workspace-cli
description: >
  Use workspace-mcp in direct CLI mode (`workspace-mcp --cli`) for Google Workspace
  tasks (Drive, Docs, Sheets). Trigger on requests to search/read/create/edit/share
  Google files and spreadsheets. Do not use MCP transport endpoints for this skill.
---

# Workspace CLI

Use Google Workspace through direct CLI mode only:

```bash
uvx workspace-mcp --cli <tool_name> --args '<json>'
```

Do not use `/mcp/...`, `claude mcp add`, or any MCP transport setup in this skill.

## Prerequisites

- `uvx` is installed
- `workspace-mcp` is available via `uvx workspace-mcp`
- OAuth env vars are set:
  - `GOOGLE_OAUTH_CLIENT_ID`
  - `GOOGLE_OAUTH_CLIENT_SECRET`
- User email is known (pass as `user_google_email`)

Auth bootstrap:

```bash
uvx workspace-mcp --cli start_google_auth --args '{"service_name":"drive","user_google_email":"user@example.com"}'
```

## Workflow

Follow this order unless user asks otherwise:

1. Discover target files
2. Read current content
3. Apply minimal change
4. Verify result
5. Share/export if requested

Always show a short summary of what changed.

## Common Commands

List tools:

```bash
uvx workspace-mcp --cli
```

Search in Drive:

```bash
uvx workspace-mcp --cli search_drive_files --args '{"user_google_email":"user@example.com","query":"quarterly report","page_size":10}'
```

Get doc as markdown (preferred for reading):

```bash
uvx workspace-mcp --cli get_doc_as_markdown --args '{"user_google_email":"user@example.com","document_id":"DOC_ID"}'
```

Create doc:

```bash
uvx workspace-mcp --cli create_doc --args '{"user_google_email":"user@example.com","title":"Draft","content":"Initial text"}'
```

Find and replace in doc:

```bash
uvx workspace-mcp --cli find_and_replace_doc --args '{"user_google_email":"user@example.com","document_id":"DOC_ID","find_text":"old","replace_text":"new"}'
```

Read sheet values:

```bash
uvx workspace-mcp --cli read_sheet_values --args '{"user_google_email":"user@example.com","spreadsheet_id":"SHEET_ID","range_name":"Sheet1!A1:D20"}'
```

Write sheet values:

```bash
uvx workspace-mcp --cli modify_sheet_values --args '{"user_google_email":"user@example.com","spreadsheet_id":"SHEET_ID","range_name":"Sheet1!A1","values":[["a","b"],["c","d"]]}'
```

Set link permissions:

```bash
uvx workspace-mcp --cli set_drive_file_permissions --args '{"user_google_email":"user@example.com","file_id":"FILE_ID","link_sharing":"reader"}'
```

Get shareable link:

```bash
uvx workspace-mcp --cli get_drive_shareable_link --args '{"user_google_email":"user@example.com","file_id":"FILE_ID"}'
```

Export doc to PDF:

```bash
uvx workspace-mcp --cli export_doc_to_pdf --args '{"user_google_email":"user@example.com","document_id":"DOC_ID"}'
```

## Agent Rules

- Prefer `get_doc_as_markdown` over plain text readers.
- Ask for missing IDs only after trying search/list commands.
- For complex payloads, build JSON in a variable, then pass with `--args`.
- If auth fails, run `start_google_auth` first and retry the same command.
