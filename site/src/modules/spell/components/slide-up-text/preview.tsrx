import { SlideUpText } from './slide-up-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 py-8 text-center">
		<SlideUpText
			text="Slide up word by word"
			split="words"
			class="text-3xl font-bold tracking-tight text-foreground"
			stagger={0.08}
			duration={0.5}
		/>
		<SlideUpText
			text="Character by character reveal"
			split="characters"
			class="text-xl font-medium text-muted-foreground"
			stagger={0.04}
			duration={0.4}
			delay={0.3}
		/>
	</div>
	</>
}
