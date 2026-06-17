import { components } from '../lib/components';
import { modules } from '@/modules';
import { LuBlocks, LuWandSparkles, LuBookOpen, LuShapes, LuTerminal, LuArrowRight } from '../lib/lucide-icons.tsrx';
import { cn } from '../lib/utils';

// The module index — the home's centerpiece. Every section of the playground is
// a first-class card with its own accent, icon and count, so the multi-module
// nature is obvious at a glance. Components is featured (spans two columns).
//
// NOTE: accent classes are FULL LITERAL strings (incl. the `dark:`/`group-hover:`
// variants). Tailwind only emits utilities it finds literally in source — built
// at runtime via interpolation they'd never be generated.
const cards = [
	{
		href: '/components',
		label: 'Components',
		desc: 'Headless, accessible UI primitives powered by Zag.js — accordions, dialogs, comboboxes, date pickers and more.',
		count: `${components.length} components`,
		Icon: LuBlocks,
		line: 'text-primary',
		chip: 'bg-primary/10 text-primary',
		hover: 'group-hover:text-primary',
		featured: true,
	},
	{
		href: '/magic',
		label: 'Magic',
		desc: 'Eye-catching landing-page effects: beams, shimmers, tickers and marquees.',
		count: `${modules.magic.components.length} effects`,
		Icon: LuWandSparkles,
		line: 'text-violet-600 dark:text-violet-400',
		chip: 'bg-violet-500/12 text-violet-600 dark:text-violet-400',
		hover: 'group-hover:text-violet-600 dark:group-hover:text-violet-400',
		featured: false,
	},
	{
		href: '/spell',
		label: 'Spell',
		desc: 'Polished, self-contained UI spells and text effects.',
		count: `${modules.spell.components.length} components`,
		Icon: LuBookOpen,
		line: 'text-amber-600 dark:text-amber-400',
		chip: 'bg-amber-500/12 text-amber-600 dark:text-amber-400',
		hover: 'group-hover:text-amber-600 dark:group-hover:text-amber-400',
		featured: false,
	},
	{
		href: '/fancy',
		label: 'Fancy',
		desc: 'Expressive typographic motion — letter swaps, scrambles and reveals.',
		count: `${modules.fancy.components.length} components`,
		Icon: LuShapes,
		line: 'text-emerald-600 dark:text-emerald-400',
		chip: 'bg-emerald-500/12 text-emerald-600 dark:text-emerald-400',
		hover: 'group-hover:text-emerald-600 dark:group-hover:text-emerald-400',
		featured: false,
	},
	{
		href: '/streamdown',
		label: 'Streamdown',
		desc: 'A streaming-Markdown playground with live Shiki, Mermaid and KaTeX rendering.',
		count: 'Playground',
		Icon: LuTerminal,
		line: 'text-sky-600 dark:text-sky-400',
		chip: 'bg-sky-500/12 text-sky-600 dark:text-sky-400',
		hover: 'group-hover:text-sky-600 dark:group-hover:text-sky-400',
		featured: false,
	},
];

export function HomeModules() @{
	<>
	<section class="mx-auto max-w-[89rem] px-6 pb-24">
		<div class="mb-6 border-t border-border pt-8">
			<h2 class="text-lg font-semibold">{'Explore the modules'}</h2>
			<p class="text-sm text-muted-foreground">{'Each section is its own corner of the playground.'}</p>
		</div>

		<div class="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
			@for (const card of cards) {
				const Icon = card.Icon;
				<a
					href={card.href}
					class={cn(
						'group relative flex flex-col overflow-hidden rounded-xl border border-border bg-card p-5 transition-all duration-200 hover:-translate-y-0.5 hover:shadow-[var(--shadow-2)]',
						card.featured && 'md:col-span-2',
					)}
				>
					<div class={cn('absolute inset-x-0 top-0 h-0.5 origin-left scale-x-0 bg-current opacity-70 transition-transform duration-300 group-hover:scale-x-100', card.line)} />

					<div class="mb-4 flex items-start justify-between gap-3">
						<div class={cn('flex size-11 items-center justify-center rounded-lg', card.chip)}>
							<Icon class="size-5" />
						</div>
						<span class="rounded-full border border-border bg-background px-2.5 py-0.5 text-xs font-medium text-muted-foreground">
							{card.count}
						</span>
					</div>

					<h3 class={cn('mb-1.5 font-semibold transition-colors', card.featured ? 'text-xl' : 'text-lg', card.hover)}>
						{card.label}
					</h3>
					<p class={cn('text-sm leading-relaxed text-muted-foreground', card.featured && 'max-w-xl')}>
						{card.desc}
					</p>

					<div class={cn('mt-4 flex items-center gap-1.5 text-sm font-medium text-muted-foreground transition-colors', card.hover)}>
						<span>{'Open'}</span>
						<LuArrowRight class="size-4 transition-transform group-hover:translate-x-1" />
					</div>
				</a>
			}
		</div>
	</section>
	</>
}
