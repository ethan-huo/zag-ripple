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

export const spell: ModuleDef = {
	id: 'spell',
	label: 'Spell',
	tagline: 'Spell UI',
	description:
		'Polished, self-contained UI spells — badges, loaders, text effects and cards — ported to Ripple.',
	credit: { label: 'Spell UI', href: 'https://animation-svelte.vercel.app/spell' },
	components,
};
