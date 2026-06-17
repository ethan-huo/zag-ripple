import { TextMarquee } from './text-marquee.tsrx';

const techs = ['Ripple', 'Zag', 'Vite', 'Bun', 'TSRX', 'Motion', 'Tailwind', 'TypeScript'];
const frameworks = ['React', 'Vue', 'Svelte', 'Solid', 'Ripple'];

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-8 py-6">
		<div class="flex items-center gap-2 text-2xl font-bold text-foreground">
			<span>Built with</span>
			<TextMarquee
				items={techs}
				speed={1}
				height={40}
				itemHeight={40}
				renderItem={(item: string) => (
					<span class="font-bold text-primary">{item}</span>
				)}
			/>
		</div>

		<div class="flex items-center gap-2 text-lg text-muted-foreground">
			<span class="text-foreground font-medium">Stack:</span>
			<TextMarquee
				items={frameworks}
				speed={0.8}
				height={32}
				itemHeight={32}
				renderItem={(item: string) => (
					<span class="rounded bg-muted px-2 py-0.5 text-sm font-mono text-foreground">{item}</span>
				)}
			/>
		</div>
	</div>
	</>
}
