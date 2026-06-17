import type { ComponentEntry, ModuleDef } from '@/modules/types';

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

export const fancy: ModuleDef = {
	id: 'fancy',
	label: 'Fancy',
	tagline: 'Fancy Components',
	description:
		'Expressive typographic motion — letter swaps, scrambles and reveals — ported to Ripple.',
	credit: { label: 'Fancy Components', href: 'https://fancycomponents.dev' },
	components,
};
