// Headless smoke test for the new module pages. Navigates each route, waits for
// render, and asserts: no vite error overlay, app mounted, expected heading text.
// Usage: bun site/tools/smoke.ts
const BASE = 'http://localhost:3000';

const routes: { path: string; expect: string }[] = [
	{ path: '/', expect: '' },
	{ path: '/spell', expect: 'Spell UI' },
	{ path: '/spell/highlighted-text', expect: 'Highlighted Text' },
	{ path: '/spell/gradient-wave-text', expect: 'Gradient Wave Text' },
	{ path: '/spell/badge', expect: 'Badge' },
	{ path: '/spell/tilt-card', expect: 'Tilt Card' },
	{ path: '/spell/marquee', expect: 'Marquee' },
	{ path: '/spell/bar-spinner', expect: 'Bar Spinner' },
	{ path: '/spell/kbd', expect: 'Keyboard Key' },
	{ path: '/spell/exploding-input', expect: 'Exploding Input' },
	{ path: '/spell/randomized-text', expect: 'Randomized Text' },
	{ path: '/fancy', expect: 'Fancy Components' },
	{ path: '/fancy/letter-swap', expect: 'Letter Swap' },
	{ path: '/fancy/scramble-hover', expect: 'Scramble Hover' },
	{ path: '/fancy/scramble-in', expect: 'Scramble In' },
	{ path: '/fancy/vertical-cut-reveal', expect: 'Vertical Cut Reveal' },
	{ path: '/magic', expect: 'Magic UI' },
	{ path: '/magic/word-rotate', expect: 'Word Rotate' },
	{ path: '/magic/number-ticker', expect: 'Number Ticker' },
	{ path: '/magic/animated-shiny-text', expect: 'Animated Shiny Text' },
	{ path: '/magic/border-beam', expect: 'Border Beam' },
	{ path: '/magic/meteors', expect: 'Meteors' },
	{ path: '/magic/ripple', expect: 'Ripple' },
];

const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

await using view = new Bun.WebView({ width: 1280, height: 800 });

let failures = 0;
for (const { path, expect } of routes) {
	await view.navigate(BASE + path);
	await sleep(700);
	const snap = (await view.evaluate(`(() => {
		const root = document.getElementById('root');
		return {
			title: document.title,
			overlay: !!document.querySelector('vite-error-overlay'),
			mounted: !!root && root.children.length > 0,
			text: (document.querySelector('main')?.innerText || document.body.innerText || '').slice(0, 4000),
		};
	})()`)) as { title: string; overlay: boolean; mounted: boolean; text: string };

	const hasExpected = expect === '' ? true : snap.text.includes(expect);
	const ok = snap.mounted && !snap.overlay && hasExpected;
	if (!ok) failures++;
	console.log(
		`${ok ? '✓' : '✗'} ${path.padEnd(30)} mounted=${snap.mounted} overlay=${snap.overlay} expect="${expect}"=${hasExpected}`,
	);
	if (!ok) console.log(`    title="${snap.title}" text="${snap.text.slice(0, 200).replace(/\n/g, ' ')}"`);
}

// Visual capture of a couple of animated pages.
for (const p of ['/magic/meteors', '/spell/gradient-wave-text', '/fancy/vertical-cut-reveal']) {
	await view.navigate(BASE + p);
	await sleep(900);
	const name = p.replace(/\//g, '_').replace(/^_/, '');
	await Bun.write(`/tmp/shot-${name}.png`, await view.screenshot());
}

console.log(`\n${failures === 0 ? 'ALL PASS' : failures + ' FAILED'} (${routes.length} routes)`);
process.exit(failures === 0 ? 0 : 1);
