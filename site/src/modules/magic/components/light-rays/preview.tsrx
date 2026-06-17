import { LightRays } from './light-rays.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<LightRays count={8} color="rgba(160, 210, 255, 0.25)" speed={12} />
		<div class="relative z-10 flex h-full flex-col items-center justify-center gap-2">
			<p class="text-lg font-semibold text-foreground">{'Light Rays'}</p>
			<p class="text-sm text-muted-foreground">{'Volumetric light ray overlay'}</p>
		</div>
	</div>
	</>
}
