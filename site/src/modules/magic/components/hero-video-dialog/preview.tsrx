import { HeroVideoDialog } from './hero-video-dialog.tsrx';

export function Preview() @{
	<>
	<div class="relative flex w-full items-center justify-center">
		<HeroVideoDialog
			animationStyle="from-center"
			videoSrc="https://www.youtube.com/embed/qh3NGpYRG3I?si=4rb-zSdDkVK9qxxb"
			thumbnailSrc="https://startup-template-sage.vercel.app/hero-dark.png"
			thumbnailAlt="Hero Video"
			class="w-full max-w-2xl"
		/>
	</div>
	</>
}
