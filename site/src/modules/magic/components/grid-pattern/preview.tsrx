import { GridPattern } from './grid-pattern.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<GridPattern
			width={32}
			height={32}
			squares={[[1, 1], [3, 2], [5, 1], [2, 4], [4, 3], [6, 2], [1, 5], [7, 4], [3, 6], [5, 5]]}
			class="text-primary/40 fill-primary/10 stroke-primary/20"
		/>
		<div class="relative z-10 flex h-full flex-col items-center justify-center gap-2">
			<p class="text-xl font-semibold text-foreground">{'Grid Pattern'}</p>
			<p class="text-sm text-muted-foreground">{'SVG tiling grid with highlighted squares'}</p>
		</div>
	</div>
	</>
}
