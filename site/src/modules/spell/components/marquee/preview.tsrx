import { Marquee } from './marquee.tsrx';

const items = ['Ripple', 'Zag', 'Motion', 'Tailwind', 'Vite', 'Bun', 'TSRX', 'Shiki'];

export function Preview() @{
	<>
	<div class="w-full max-w-xl">
		<Marquee duration={18} pauseOnHover>
			@for (const item of items) {
				<div class="mx-3 rounded-full border border-border bg-card px-4 py-2 text-sm font-medium text-foreground">
					{item}
				</div>
			}
		</Marquee>
	</div>
	</>
}
