import { VideoText } from './video-text.tsrx';

export function Preview() @{
	<>
	<div class="relative h-48 w-full overflow-hidden rounded-xl border border-border bg-black">
		<VideoText
			src="https://cdn.pixabay.com/video/2015/08/08/284-134992502_large.mp4"
			content="RIPPLE"
			fontSize={18}
			fontWeight="bold"
			fontFamily="sans-serif"
		/>
	</div>
	</>
}
