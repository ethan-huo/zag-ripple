import { MediaBetweenText } from './media-between-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-10 py-8">
		{/* Hover trigger — most discoverable for a demo */}
		<MediaBetweenText
			firstText="Hover to reveal"
			secondText="magic"
			mediaUrl="https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80"
			mediaType="image"
			triggerType="hover"
			class="cursor-pointer gap-2 text-3xl font-semibold"
			mediaContainerClass="h-10 rounded-md mx-1"
		/>

		{/* inView trigger — fires automatically when scrolled into view */}
		<MediaBetweenText
			firstText="Scroll to see"
			secondText="nature"
			mediaUrl="https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400&q=80"
			mediaType="image"
			triggerType="inView"
			useInViewOptions={{ once: false, amount: 0.5 }}
			class="gap-2 text-3xl font-semibold text-muted-foreground"
			mediaContainerClass="h-10 rounded-md mx-1"
		/>
	</div>
	</>
}
