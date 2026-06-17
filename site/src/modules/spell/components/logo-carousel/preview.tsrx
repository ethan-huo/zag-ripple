import { LogoCarousel } from './logo-carousel.tsrx';

// Simulated company/tool logos as styled text badges — representative of the
// typical logo-carousel use-case without requiring external image assets.
const logos = [
	{ name: 'Vercel', abbr: 'VC', color: '#000000' },
	{ name: 'Supabase', abbr: 'SB', color: '#3ECF8E' },
	{ name: 'Tailwind', abbr: 'TW', color: '#38BDF8' },
	{ name: 'Vite', abbr: 'VT', color: '#BD34FE' },
	{ name: 'Bun', abbr: 'BN', color: '#FBF0DF' },
	{ name: 'TypeScript', abbr: 'TS', color: '#3178C6' },
	{ name: 'Ripple', abbr: 'RP', color: '#6366F1' },
	{ name: 'Motion', abbr: 'MO', color: '#FF0055' },
	{ name: 'Zag', abbr: 'ZG', color: '#F59E0B' },
];

export function Preview() @{
	<>
	<div class="flex w-full flex-col items-center gap-4 py-8">
		<p class="text-sm text-muted-foreground">Trusted by teams using</p>
		<LogoCarousel
			items={logos}
			count={4}
			duration={500}
			interval={2000}
			renderItem={(logo: any) => (
				<div class="flex flex-col items-center gap-2">
					<div
						class="flex size-12 items-center justify-center rounded-xl text-sm font-bold text-white shadow-sm"
						style={`background-color: ${logo.color};`}
					>
						{logo.abbr}
					</div>
					<span class="text-xs text-muted-foreground">{logo.name}</span>
				</div>
			)}
		/>
	</div>
	</>
}
