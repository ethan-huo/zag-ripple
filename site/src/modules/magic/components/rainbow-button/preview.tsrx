import { RainbowButton } from './rainbow-button.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-wrap items-center justify-center gap-6 p-10">
		<RainbowButton>{'Get Started'}</RainbowButton>
		<RainbowButton size="lg">{'Learn More'}</RainbowButton>
		<RainbowButton variant="outline">{'Sign Up'}</RainbowButton>
		<RainbowButton size="sm" variant="outline">{'Explore'}</RainbowButton>
	</div>
	</>
}
