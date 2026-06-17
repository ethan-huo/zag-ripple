import { StripedPattern } from './striped-pattern.tsrx';

export function Preview() @{
	<>
	<div class="flex gap-4 p-4">
		<div class="relative h-48 flex-1 overflow-hidden rounded-xl border border-border bg-card text-muted-foreground/40">
			<StripedPattern direction="left" width={12} height={12} />
			<div class="relative z-20 flex h-full items-center justify-center">
				<span class="text-sm font-medium text-foreground">{'Left'}</span>
			</div>
		</div>
		<div class="relative h-48 flex-1 overflow-hidden rounded-xl border border-border bg-card text-muted-foreground/40">
			<StripedPattern direction="right" width={12} height={12} />
			<div class="relative z-20 flex h-full items-center justify-center">
				<span class="text-sm font-medium text-foreground">{'Right'}</span>
			</div>
		</div>
	</div>
	</>
}
