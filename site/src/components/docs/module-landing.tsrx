import { track } from 'ripple';
import { Navigation } from '../navigation.tsrx';
import { Card } from '../ui/card.tsrx';
import { Badge } from '../ui/badge.tsrx';
import { LuSearch, LuExternalLink } from '@/lib/lucide-icons.tsrx';
import { useSearch } from '@/lib/use-search.tsrx';
import { getModule, type ModuleId } from '@/modules';

export function ModuleLanding({ module }: { module: ModuleId }) @{
	const mod = getModule(module)!;
	let searchTerm = track('');
	// Copy the registry so useSearch's in-place sort can't reorder the sidebar /
	// prev-next sequence.
	const results = useSearch(searchTerm, [...mod.components], [
		{ name: 'title', weight: 3 },
		{ name: 'description', weight: 1 },
	]);

	<>
	<head>
		<title>{`${mod.tagline} | ZagRipple`}</title>
	</head>

	<Navigation section={mod.id} />

	<main class="mx-auto max-w-[89rem] px-6 py-10">
		<div class="mb-10 max-w-[48rem]">
			<h1 class="mb-4 text-[2.125rem] font-bold leading-tight">
				<span class="text-primary">{mod.tagline}</span>
			</h1>
			<p class="mb-4 text-[1rem] leading-7 text-muted-foreground">{mod.description}</p>
			@if (mod.credit) {
				<p class="mb-6 text-sm text-muted-foreground">
					{'Ported to Ripple from '}
					<a
						href={mod.credit.href}
						target="_blank"
						class="inline-flex items-center gap-1 text-primary hover:underline"
					>
						{mod.credit.label}
						<LuExternalLink class="h-3 w-3" />
					</a>
				</p>
			}

			<div class="relative max-w-md">
				<LuSearch class="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
				<input
					type="text"
					value={searchTerm.value}
					onInput={(e) => (searchTerm.value = (e.target as HTMLInputElement).value)}
					placeholder={`Search ${mod.label.toLowerCase()}...`}
					class="h-9 w-full rounded-full border border-border bg-card pl-10 pr-4 text-sm outline-none placeholder:text-muted-foreground hover:bg-muted/50 focus-visible:outline-2 focus-visible:outline-ring focus-visible:outline-offset-[-1px]"
				/>
			</div>
		</div>

		@if (mod.components.length === 0) {
			<div class="rounded-lg border border-dashed border-border px-6 py-16 text-center text-muted-foreground">
				{'Components for this module are being ported. Check back soon.'}
			</div>
		} @else {
			<div class="grid grid-cols-1 gap-3 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
				@for (const comp of results.value) {
					<a href={`/${mod.id}/${comp.id}`}>
						<Card class="group relative h-full cursor-pointer overflow-hidden p-4 transition-colors hover:bg-muted/40">
							<div class="absolute inset-x-0 top-0 h-px bg-border" />
							<div class="relative">
								<div class="mb-3 flex items-center justify-between gap-2">
									<h3 class="text-base font-semibold transition-colors group-hover:text-primary">
										{comp.title}
									</h3>
									@if (comp.group) {
										<Badge variant="secondary" class="shrink-0 text-[10px]">{comp.group}</Badge>
									}
								</div>
								<p class="text-sm leading-relaxed text-muted-foreground">{comp.description}</p>
								<div class="mt-4 flex items-center text-xs text-muted-foreground transition-colors group-hover:text-primary">
									<span>{'View docs'}</span>
									<svg class="ml-1 h-3 w-3 transition-transform duration-300 group-hover:translate-x-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
									</svg>
								</div>
							</div>
						</Card>
					</a>
				}
			</div>
		}
	</main>
	</>
}
