import { Globe } from './globe.tsrx';

export function Preview() @{
	<>
	<div class="relative h-80 w-full overflow-hidden rounded-xl border border-border bg-card">
		<div class="flex h-full flex-col items-center justify-center gap-2">
			<p class="z-10 text-sm font-medium text-foreground">{"Interactive Globe"}</p>
			<p class="z-10 text-xs text-muted-foreground">{"Drag to rotate"}</p>
		</div>
		<Globe />
	</div>
	</>
}
