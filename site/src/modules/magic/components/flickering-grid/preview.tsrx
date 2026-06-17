import { FlickeringGrid } from './flickering-grid.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<FlickeringGrid
			squareSize={4}
			gridGap={6}
			flickerChance={0.3}
			color="rgb(99,102,241)"
			maxOpacity={0.4}
		/>
		<div class="absolute inset-0 flex items-center justify-center">
			<span class="text-sm font-medium text-foreground/80">{'Flickering Grid'}</span>
		</div>
	</div>
	</>
}
