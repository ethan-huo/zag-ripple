import { NoiseTexture } from './noise-texture.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-80 overflow-hidden rounded-xl border border-border bg-card">
		<NoiseTexture />
		<div class="relative z-10 flex h-full flex-col items-center justify-center gap-2">
			<p class="text-lg font-semibold text-foreground">{'Noise Texture'}</p>
			<p class="text-sm text-muted-foreground">{'Procedural SVG grain overlay'}</p>
		</div>
	</div>
	</>
}
