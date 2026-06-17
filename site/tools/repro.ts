// Reproduce the client-navigation bugs: click sidebar links (SPA nav within the
// persistent routing-machine Layout) and observe whether the preview updates.
const BASE = 'http://localhost:3000';
const sleep = (ms: number) => new Promise((r) => setTimeout(r, ms));

await using view = new Bun.WebView({ width: 1280, height: 800 });

// Capture page console errors.
const errors: string[] = [];
// @ts-ignore experimental hook
view.onConsoleMessage = (m: any) => {
	if (m?.level === 'error' || m?.type === 'error') errors.push(String(m.text ?? m));
};

async function previewText() {
	return (await view.evaluate(
		`(() => { const m = document.querySelector('main'); const box = m && [...m.querySelectorAll('div')].find(d => /min-h-\\[18rem\\]/.test(d.className)); return (box?.innerText || '').slice(0,120); })()`,
	)) as string;
}

// 1) Load a component page fresh, then client-navigate via sidebar links.
await view.navigate(BASE + '/spell/badge');
await sleep(900);
const t1 = await previewText();
console.log('fresh /spell/badge preview:', JSON.stringify(t1));

// click the sidebar link for Tilt Card (client nav, same route name → persistent page)
const clicked = await view.evaluate(
	`(() => { const a = [...document.querySelectorAll('a')].find(a => a.textContent?.trim() === 'Tilt Card'); if (a) { a.click(); return true; } return false; })()`,
);
await sleep(900);
const url2 = await view.evaluate('location.pathname');
const title2 = await view.evaluate(`document.querySelector('h1')?.textContent || ''`);
const t2 = await previewText();
console.log('clicked Tilt Card =>', clicked, 'url=', url2, 'h1=', JSON.stringify(title2));
console.log('after-click preview:', JSON.stringify(t2));
console.log('PREVIEW CHANGED?', t1 !== t2);

// 2) Home -> Magic nav -> click a component, watch for blank.
await view.navigate(BASE + '/');
await sleep(600);
await view.evaluate(`[...document.querySelectorAll('a')].find(a=>a.textContent?.trim()==='Magic')?.click()`);
await sleep(800);
const magicUrl = await view.evaluate('location.pathname');
await view.evaluate(`[...document.querySelectorAll('a')].find(a=>a.textContent?.trim()==='Word Rotate')?.click()`);
await sleep(800);
const afterMagic = (await view.evaluate(
	`(() => { const r=document.getElementById('root'); return { url: location.pathname, rootKids: r?.children.length||0, mainLen: (document.querySelector('main')?.innerText||'').length }; })()`,
)) as any;
console.log('magic landing url=', magicUrl, ' after click Word Rotate:', JSON.stringify(afterMagic));

console.log('\nconsole errors captured:', errors.length);
errors.slice(0, 8).forEach((e) => console.log('  ERR:', e.slice(0, 200)));
