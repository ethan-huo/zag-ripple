import { UnderlineToBackground } from './underline-to-background.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-8 text-center font-sans">
		<p class="text-2xl font-semibold leading-relaxed">
			Try hovering the words below to see the
			{' '}
			<UnderlineToBackground
				targetTextColor="#fff"
				class="text-foreground"
			>
				underline to background
			</UnderlineToBackground>
			{' '}
			animation.
		</p>

		<div class="flex flex-wrap items-center justify-center gap-4 text-lg">
			<UnderlineToBackground targetTextColor="#ffffff" class="font-medium text-foreground">
				Hover Me
			</UnderlineToBackground>
			<UnderlineToBackground targetTextColor="#fef08a" class="font-medium text-foreground">
				Yellow Fill
			</UnderlineToBackground>
			<UnderlineToBackground targetTextColor="#f0fdf4" class="font-medium text-foreground" underlineHeightRatio={0.15}>
				Thick Bar
			</UnderlineToBackground>
		</div>
	</div>
	</>
}
