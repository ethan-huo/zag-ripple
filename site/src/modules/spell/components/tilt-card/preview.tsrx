import { TiltCard } from './tilt-card.tsrx';

export function Preview() @{
	<>
	<TiltCard class="h-56 w-80 rounded-xl border border-border bg-gradient-to-br from-card to-muted p-6">
		<div class="flex h-full flex-col justify-between">
			<span class="text-xs uppercase tracking-widest text-muted-foreground">{'Interactive'}</span>
			<div>
				<h3 class="text-xl font-bold text-foreground">{'Tilt Card'}</h3>
				<p class="text-sm text-muted-foreground">{'Move your cursor across me.'}</p>
			</div>
		</div>
	</TiltCard>
	</>
}
