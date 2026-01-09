# wpscan-mcp

An MCP server (TypeScript) that exposes a few tools for the **WPScan (wpscan.com) API v3**.

## Requirements

- Node.js >= 18
- A WPScan API token

## Setup

### Node.js

```bash
npm install
```

Set your token:

```bash
export WPSCAN_API_TOKEN="..."
```

Build & run:

```bash
npm run build
node dist/index.js
```

### Bun

Install dependencies and compile:

```bash
bun install
bun run compile
```

Set your token:

```bash
export WPSCAN_API_TOKEN="..."
```

Run:

```bash
./wpscan-mcp
```

If, for some reason, compilation does not work:

```bash
bun install
bun run build
export WPSCAN_API_TOKEN="..."
bun run dist/index.js
```

## Type generation (optional)

This project can generate TypeScript types directly from the WPScan OpenAPI spec:

```bash
# Node.js:
npm run generate-types

# Bun:
bun run generate-types
```

Notes:
- The OpenAPI spec is fetched from `https://wpscan.com/docs/api/v3/v3.yml/`.

## MCP tools

- `wpscan_plugin_lookup`
  - Args: `{ slug: string, version?: string }`
- `wpscan_theme_lookup`
  - Args: `{ slug: string, version?: string }`
- `wpscan_core_lookup`
  - Args: `{ version: number }`
  - Note: WPScan expects the WordPress version with dots removed (e.g. `6.4.2` → `642`).
- `wpscan_lookup_vuln`
  - Args: `{ wpvdbId: string }` (e.g. `WPVDB-ID-12345`)

## Usage with an MCP client

This server uses stdio transport.

### Example: Claude Desktop config

Add a server entry to your Claude Desktop MCP config (path varies by OS). Example:

```json
{
  "mcpServers": {
    "wpscan": {
      "command": "node",
      "args": ["/path/to/wpscan-mcp/dist/index.js"],
      "env": {
        "WPSCAN_API_TOKEN": "YOUR_TOKEN_HERE"
      }
    }
  }
}
```

Then restart the client so it picks up the new MCP server.

### Example: VSCode

#### Bun

Create `.vscode/mcp.json`:

```json
{
  "servers": {
    "wpscan": {
      "type": "stdio",
      "command": "${workspaceFolder}/wpscan-mcp",
      "args": [],
      "env": {
        "WPSCAN_API_TOKEN": "YOUR_TOKEN_HERE"
      }
    }
  }
}
```

#### Node.js

```json
{
  "servers": {
    "wpscan": {
      "type": "stdio",
      "command": "node",
      "args": ["${workspaceFolder}/dist/index.js"],
      "env": {
        "WPSCAN_API_TOKEN": "YOUR_TOKEN_HERE"
      }
    }
  }
}
```

## Tool call examples

- Plugin lookup:

```json
{ "slug": "woocommerce" }
```

- Theme lookup (specific version):

```json
{ "slug": "astra", "version": "4.6.3" }
```

- Core lookup (WordPress 6.4.2 → 642):

```json
{ "version": 642 }
```

- Vulnerability lookup:

```json
{ "wpvdbId": "WPVDB-ID-12345" }
```
