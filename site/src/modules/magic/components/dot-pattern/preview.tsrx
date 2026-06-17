import { DotPattern } from './dot-pattern.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<DotPattern glow={true} class="text-primary/40" />
		<div class="relative z-10 flex h-full flex-col items-center justify-center gap-2">
			<p class="text-xl font-semibold text-foreground">{'Dot Pattern'}</p>
			<p class="text-sm text-muted-foreground">{'Glowing animated dots'}</p>
		</div>
	</div>
	</>
}
