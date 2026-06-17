import type { ComponentEntry, ModuleDef } from '@/modules/types';

// Auto-collect every component's `data` export. Adding a component directory
// under ./components/<id>/data.ts (exporting `export const data`) registers it —
// no manual edits here, and no concurrent-edit conflicts when porting in bulk.
const mods = import.meta.glob('./components/*/data.ts', { eager: true }) as Record<
	string,
	{ data?: ComponentEntry }
>;

const components = Object.values(mods)
	.map((m) => m.data)
	.filter((d): d is ComponentEntry => Boolean(d))
	.sort(
		(a, b) =>
			(a.group ?? '').localeCompare(b.group ?? '') || a.title.localeCompare(b.title),
	);

export const magic: ModuleDef = {
	id: 'magic',
	label: 'Magic',
	tagline: 'Magic UI',
	description:
		'Eye-catching landing-page effects — beams, shimmers, tickers and marquees — ported to Ripple.',
	credit: { label: 'Magic UI', href: 'https://magicui.design' },
	components,
};
