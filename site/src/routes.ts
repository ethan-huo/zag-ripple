// IMPORTANT: do NOT `import { RenderRoute } from '@ripple-ts/vite-plugin'` here.
// `ripple.config.ts` imports this file, and the client hydrate entry imports
// ripple.config.ts in the *browser*. Pulling the vite plugin (vite/rollup/node)
// into that graph makes the browser import fail and silently breaks hydration
// (no CSS, no interactivity). Plain objects carry the exact shape the plugin
// reads (`type`/`path`/`entry`/`before`), so routing + SSR work unchanged.
type Route = { type: 'render'; path: string; entry: string; layout?: string; before: [] };

const render = (path: string, entry: string): Route => ({ type: 'render', path, entry, before: [] });

export const routes = [
	render('/', '/src/pages/home.tsrx'),

	render('/components', '/src/pages/components.tsrx'),
	render('/components/:id', '/src/pages/component.tsrx'),

	render('/magic', '/src/pages/magic.tsrx'),
	render('/magic/:id', '/src/pages/magic-component.tsrx'),

	render('/spell', '/src/pages/spell.tsrx'),
	render('/spell/:id', '/src/pages/spell-component.tsrx'),

	render('/fancy', '/src/pages/fancy.tsrx'),
	render('/fancy/:id', '/src/pages/fancy-component.tsrx'),

	render('/streamdown', '/src/pages/streamdown.tsrx'),

	// Catch-all 404 — PRODUCTION ONLY (must be last). In dev the plugin
	// registers its router as a pre-hook middleware ahead of Vite's stack, so a
	// '/**' route would match every Vite asset/HMR/module request (/@id/…,
	// /src/…, /ripple.config.ts) and return the 404 HTML — which silently breaks
	// hydration. In dev, unmatched routes fall through to Vite instead.
	...(import.meta.env.PROD ? [render('/**', '/src/pages/not-found.tsrx')] : []),
];
