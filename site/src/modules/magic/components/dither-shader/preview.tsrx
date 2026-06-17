import { DitherShader } from './dither-shader.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6">
		<div class="relative h-56 w-80 overflow-hidden rounded-xl border border-border bg-card">
			<DitherShader
				src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=640&q=80"
				gridSize={4}
				ditherMode="bayer"
				colorMode="grayscale"
			/>
		</div>
		<div class="flex gap-4">
			<div class="relative h-36 w-40 overflow-hidden rounded-xl border border-border bg-card">
				<DitherShader
					src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=640&q=80"
					gridSize={6}
					ditherMode="halftone"
					colorMode="duotone"
					primaryColor="#7c3aed"
					secondaryColor="#e0e7ff"
				/>
			</div>
			<div class="relative h-36 w-40 overflow-hidden rounded-xl border border-border bg-card">
				<DitherShader
					src="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=640&q=80"
					gridSize={4}
					ditherMode="crosshatch"
					colorMode="original"
					invert={true}
				/>
			</div>
		</div>
	</div>
	</>
}
