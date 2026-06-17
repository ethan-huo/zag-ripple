import { serve, runtime } from '@ripple-ts/adapter-vercel';
import { routes } from './src/routes.ts';

// Plain default export instead of the plugin's `defineConfig` (which is just an
// identity helper). Importing `@ripple-ts/vite-plugin` here would pull vite/node
// into the *client* hydrate graph (the hydrate entry imports this file in the
// browser) and break hydration. adapter-node + plain route objects are
// browser-safe; the plugin's loadRippleConfig reads this object and fills
// defaults. Production on Vercel: swap adapter to `@ripple-ts/adapter-vercel`.
export default {
	build: {
		outDir: 'dist',
		target: 'es2022',
		minify: false,
	},
	adapter: { serve, runtime },
	router: { routes },
	platform: { env: {} },
};
