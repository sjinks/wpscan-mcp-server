import { z } from 'zod';

export const pluginLookupSchema = z.object({
    slug: z.string().min(1),
    version: z.string().min(1).optional(),
});

export const themeLookupSchema = z.object({
    slug: z.string().min(1),
    version: z.string().min(1).optional(),
});

export const coreLookupSchema = z.object({
    version: z.number(),
});

export const vulnLookupSchema = z.object({
    wpvdbId: z.string().min(1),
});

export const genericRequestSchema = z.object({
    path: z.string().min(1),
    method: z.literal('GET').default('GET'),
    query: z.record(z.string(), z.string()).optional(),
});
