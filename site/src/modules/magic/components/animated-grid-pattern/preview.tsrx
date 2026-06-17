import { AnimatedGridPattern } from './animated-grid-pattern.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<AnimatedGridPattern
			width={32}
			height={32}
			numSquares={40}
			maxOpacity={0.4}
			duration={3}
			class="text-primary/60 fill-primary/20 stroke-primary/20"
		/>
		<div class="relative z-10 flex h-full items-center justify-center">
			<span class="text-sm font-medium text-foreground/60">{'Animated Grid Pattern'}</span>
		</div>
	</div>
	</>
}
