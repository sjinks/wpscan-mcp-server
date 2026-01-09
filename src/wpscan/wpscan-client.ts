import createClient, { type Middleware } from 'openapi-fetch/dist/index.mjs';

import type { paths, components } from './wpscan.d.ts';

export function wpscanClient(baseUrl: string, apiKey: string): ReturnType<typeof createClient<paths>> {
    const client = createClient<paths>({ baseUrl });
    const authMiddleware: Middleware = {
        onRequest({ request }) {
            request.headers.set('Authorization', `Token token=${apiKey}`);
            return request;
        },
    };

    client.use(authMiddleware);
    return client;
}

export type WpScanClient = ReturnType<typeof wpscanClient>;

export async function lookupPlugin(
    client: WpScanClient,
    slug: string,
    version?: string,
): Promise<components['schemas']['Plugins'][] | undefined> {
    const promise = version
        ? client.GET('/plugins/{slug}/{version}', { params: { path: { slug, version } } })
        : client.GET('/plugins/{slug}', { params: { path: { slug } } });

    const { data, error } = await promise;
    if (error) {
        // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
        throw new Error(`WPScan API error: ${error}`);
    }

    return data;
}

export async function lookupTheme(
    client: WpScanClient,
    slug: string,
    version?: string,
): Promise<components['schemas']['Themes'][] | undefined> {
    const promise = version
        ? client.GET('/themes/{slug}/{version}', { params: { path: { slug, version } } })
        : client.GET('/themes/{slug}', { params: { path: { slug } } });

    const { data, error } = await promise;
    if (error) {
        // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
        throw new Error(`WPScan API error: ${error}`);
    }

    return data;
}

export async function lookupCore(
    client: WpScanClient,
    version: number,
): Promise<components['schemas']['WordPress'][] | undefined> {
    const { data, error } = await client.GET('/wordpresses/{version}', { params: { path: { version } } });
    if (error) {
        // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
        throw new Error(`WPScan API error: ${error}`);
    }

    return data;
}

export async function lookupVulnerability(
    client: WpScanClient,
    id: string,
): Promise<Record<string, unknown> | undefined> {
    const { data, error } = await client.GET('/vulnerabilities/{id}', { params: { path: { id } } });
    if (error) {
        // eslint-disable-next-line @typescript-eslint/restrict-template-expressions
        throw new Error(`WPScan API error: ${error}`);
    }

    return data;
}
