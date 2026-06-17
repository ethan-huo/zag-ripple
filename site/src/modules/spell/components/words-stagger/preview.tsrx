import { WordsStagger } from './words-stagger.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-8 py-8">
		<WordsStagger
			text="Build beautiful animated interfaces."
			as="h2"
			class="text-3xl font-bold tracking-tight text-foreground"
			speed={0.6}
			stagger={0.12}
			triggerOnView
		/>
		<WordsStagger
			text="Every word fades in with a soft blur and upward drift."
			as="p"
			class="max-w-sm text-center text-base text-muted-foreground"
			speed={0.4}
			stagger={0.08}
			delay={0.3}
			triggerOnView
		/>
	</div>
	</>
}
