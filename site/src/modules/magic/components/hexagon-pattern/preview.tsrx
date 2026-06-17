import { HexagonPattern } from './hexagon-pattern.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<HexagonPattern
			radius={30}
			gap={4}
			direction="horizontal"
			hexagons={[[1, 2], [3, 1], [5, 3], [2, 4], [4, 0]]}
			class="fill-primary/20 stroke-primary/40"
		/>
		<div class="relative z-10 flex h-full items-center justify-center">
			<span class="text-sm font-medium text-foreground/60">{'Hexagon Pattern'}</span>
		</div>
	</div>
	</>
}
