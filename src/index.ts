#!/usr/bin/env node

import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

import { pluginLookupSchema, themeLookupSchema, coreLookupSchema, vulnLookupSchema } from './wpscan/schemas.js';
import {
    lookupCore,
    lookupPlugin,
    lookupTheme,
    lookupVulnerability,
    type WpScanClient,
    wpscanClient,
} from './wpscan/wpscan-client.js';

import type { CallToolResult } from '@modelcontextprotocol/sdk/types.js';

const server = new McpServer(
    {
        name: 'wpscan-mcp',
        version: '0.1.0',
    },
    {
        capabilities: {
            tools: {},
        },
    },
);

let client: WpScanClient;

function parseError(err: unknown): CallToolResult {
    let message: string;

    if (err instanceof Error) {
        message = err.message;
    } else {
        message = 'Unknown error';
    }

    return {
        content: [
            {
                type: 'text',
                text: message,
            },
        ],
        isError: true,
    };
}

server.registerTool(
    'wpscan_plugin_lookup',
    {
        description: 'Lookup a WordPress plugin in the WPScan API (by slug; optionally include a version).',
        inputSchema: pluginLookupSchema,
    },
    async (input) => {
        try {
            const result = await lookupPlugin(client, input.slug, input.version);
            return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
        } catch (err) {
            return parseError(err);
        }
    },
);

server.registerTool(
    'wpscan_theme_lookup',
    {
        description: 'Lookup a WordPress theme in the WPScan API (by slug; optionally include a version).',
        inputSchema: themeLookupSchema,
    },
    async (input) => {
        try {
            const result = await lookupTheme(client, input.slug, input.version);
            return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
        } catch (err) {
            return parseError(err);
        }
    },
);

server.registerTool(
    'wpscan_core_lookup',
    {
        description: 'Lookup WordPress core vulnerabilities in the WPScan API (optionally filter by version).',
        inputSchema: coreLookupSchema,
    },
    async (input) => {
        try {
            const result = await lookupCore(client, input.version);
            return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
        } catch (err) {
            return parseError(err);
        }
    },
);

server.registerTool(
    'wpscan_lookup_vuln',
    {
        description: 'Lookup a vulnerability by its WPScan ID (e.g., WPVDB-ID-12345).',
        inputSchema: vulnLookupSchema,
    },
    async (input) => {
        try {
            const result = await lookupVulnerability(client, input.wpvdbId);
            return { content: [{ type: 'text', text: JSON.stringify(result, null, 2) }] };
        } catch (err) {
            return parseError(err);
        }
    },
);

async function main() {
    const apiToken = process.env.WPSCAN_API_TOKEN;
    if (!apiToken) {
        throw new Error('Missing WPSCAN_API_TOKEN environment variable (WPScan API token).');
    }

    client = wpscanClient('https://wpscan.com/api/v3', apiToken);

    process.on('SIGINT', () => process.exit(0));

    const transport = new StdioServerTransport();
    await server.connect(transport);
}

main().catch((err) => {
    // eslint-disable-next-line no-console
    console.error(err);
    process.exit(1);
});
