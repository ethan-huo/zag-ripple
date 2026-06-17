import { RetroGrid } from './retro-grid.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<RetroGrid angle={65} cellSize={60} opacity={0.5} lightLineColor="gray" darkLineColor="gray" />
		<div class="relative z-10 flex h-full flex-col items-center justify-center gap-2">
			<p class="text-2xl font-bold tracking-tight text-foreground">{'Retro Grid'}</p>
			<p class="text-sm text-muted-foreground">{'Perspective scrolling grid background'}</p>
		</div>
	</div>
	</>
}
