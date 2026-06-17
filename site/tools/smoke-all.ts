// Headless smoke over EVERY ported component route. Enumerates routes from the
// module component dirs, then for each: navigates, waits, and checks the page
// mounted, no vite error overlay, no console errors, and the preview box has
// rendered content. Reports failures grouped.
import { readdirSync } from 'node:fs';

const BASE = 'http://localhost:3000';
const MODULES = ['spell', 'fancy', 'magic'] as const;
const root = new URL('../src/modules', import.meta.url).pathname;

const routes: { path: string; group: string; id: string }[] = [];
for (const g of MODULES) {
	let ids: string[] = [];
	try {
		ids = readdirSync(`${root}/${g}/components`, { withFileTypes: true })
			.filter((e) => e.isDirectory())
			.map((e) => e.name);
	} catch {}
	for (const id of ids) routes.push({ path: `/${g}/${id}`, group: g, id });
}

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));
await using view = new Bun.WebView({ width: 1280, height: 800 });

let pass = 0;
const fails: { path: string; why: string }[] = [];

for (const r of routes) {
	const errs: string[] = [];
	// @ts-ignore experimental
	view.onConsoleMessage = (m: any) => {
		if ((m?.level ?? m?.type) === 'error') errs.push(String(m?.text ?? m).slice(0, 200));
	};
	await view.navigate(BASE + r.path);
	await sleep(650);
	const snap = (await view.evaluate(`(() => {
		const root = document.getElementById('root');
		const main = document.querySelector('main');
		const box = main && [...main.querySelectorAll('div')].find(d => /min-h-\\[18rem\\]/.test(d.className));
		return {
			overlay: !!document.querySelector('vite-error-overlay'),
			mounted: !!root && root.children.length > 0,
			h1: document.querySelector('h1')?.textContent || '',
			previewChildren: box ? box.children.length : -1,
			previewText: (box?.innerText || '').slice(0, 30),
		};
	})()`)) as any;

	const why: string[] = [];
	if (snap.overlay) why.push('error-overlay');
	if (!snap.mounted) why.push('not-mounted');
	if (errs.length) why.push(`console:${errs[0]}`);
	// previewChildren === 0 means the preview box rendered nothing (likely a broken preview)
	if (snap.previewChildren === 0) why.push('empty-preview');

	if (why.length === 0) {
		pass++;
	} else {
		fails.push({ path: r.path, why: why.join(' | ') });
	}
}

console.log(`\n${pass}/${routes.length} routes OK`);
if (fails.length) {
	console.log(`\n${fails.length} FAILURES:`);
	for (const f of fails) console.log(`  ✗ ${f.path.padEnd(34)} ${f.why}`);
}
process.exit(fails.length ? 1 : 0);
