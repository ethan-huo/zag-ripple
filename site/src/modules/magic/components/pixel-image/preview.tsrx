import { PixelImage } from './pixel-image.tsrx';

// A landscape photo from Unsplash — free to use, loads from CDN.
const DEMO_SRC = 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&h=300&fit=crop&auto=format';

export function Preview() @{
	<>
	<div class="flex items-center justify-center p-8">
		<PixelImage
			src={DEMO_SRC}
			grid="6x4"
			grayscaleAnimation={true}
			pixelFadeInDuration={900}
			maxAnimationDelay={1000}
			colorRevealDelay={1100}
		/>
	</div>
	</>
}
