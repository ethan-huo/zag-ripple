import { Lens } from './lens.tsrx';

export function Preview() @{
	<>
	<Lens
		lensSize={180}
		zoomFactor={1.4}
		class="w-80 cursor-crosshair"
	>
		<div class="relative overflow-hidden rounded-xl border border-border bg-card">
			<img
				src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=640&q=80"
				alt="Mountain landscape"
				class="h-56 w-full object-cover"
			/>
			<div class="p-4">
				<h3 class="font-semibold text-foreground">{'Mountain Vista'}</h3>
				<p class="text-sm text-muted-foreground">{'Hover to zoom in and explore the detail.'}</p>
			</div>
		</div>
	</Lens>
	</>
}
