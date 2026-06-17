import { fileURLToPath } from 'node:url';
import { defineConfig } from 'vite';
import { ripple } from '@ripple-ts/vite-plugin';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
	// Ripple's SSR router runs the dev/preview server in middleware mode.
	appType: 'custom',
	plugins: [ripple(), tailwindcss()],
	server: {
		port: 3000,
	},
	// Build inputs/outputs are owned by the ripple() plugin (driven by
	// ripple.config.ts) — don't set `build` here or it clobbers the plugin's
	// per-page client inputs, SSR server build, and dist/client outDir.
	resolve: {
		// for local development
		alias: {
			'@': fileURLToPath(new URL('./src', import.meta.url)),
			// "routing-machine": "/Users/anubra266/Developer/oss/anubra266/route-machine/packages/route-machine/",
			// '@zag-js/toast': '/Users/anubra266/Developer/oss/chakra-ui/zag/packages/machines/toast',
			// 'ripple/internal/client':
			// 	'/Users/anubra266/Developer/oss/ripple/ripple/packages/ripple/src/runtime/internal/client/index.js',
			// 'ripple/internal/server':
			// 	'/Users/anubra266/Developer/oss/ripple/ripple/packages/ripple/src/runtime/internal/server/index.js',
			// ripple: '/Users/anubra266/Developer/oss/ripple/ripple/packages/ripple',
		},
	},
});
