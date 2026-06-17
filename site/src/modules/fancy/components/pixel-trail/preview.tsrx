import { PixelTrail } from './pixel-trail.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card flex items-center justify-center select-none">
		<PixelTrail
			pixelSize={16}
			fadeDuration={600}
			delay={100}
			pixelClassName="rounded-sm bg-primary"
		/>
		<span class="pointer-events-none relative z-10 text-sm text-muted-foreground font-mono">
			move your cursor here
		</span>
	</div>
	</>
}
