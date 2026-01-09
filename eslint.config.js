import * as wpvip from '@automattic/eslint-plugin-wpvip';

const { configs } = wpvip.default;

const config = [
    {
        ignores: ['dist/**'],
    },
    ...configs.recommended,
    ...configs.typescript,
    {
        rules: {},
        linterOptions: {
            reportUnusedDisableDirectives: 'warn',
        },
    },
];

export default config;
