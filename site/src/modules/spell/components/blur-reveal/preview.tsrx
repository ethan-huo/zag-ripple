import { BlurReveal } from './blur-reveal.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-4 text-center">
		<BlurReveal
			text="Blur. Reveal. Delight."
			as="h2"
			class="text-3xl font-bold tracking-tight text-foreground"
			speedReveal={1.2}
			speedSegment={0.8}
		/>
		<BlurReveal
			text="Each character fades in from blurred to clear, letter by letter."
			as="p"
			class="max-w-sm text-base text-muted-foreground"
			delay={0.3}
			speedReveal={2}
			speedSegment={1.2}
		/>
	</div>
	</>
}
