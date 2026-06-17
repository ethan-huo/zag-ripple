import { VerticalCutReveal } from './vertical-cut-reveal.tsrx';

export function Preview() @{
	<>
	<div class="text-3xl font-bold tracking-tight md:text-4xl">
		<VerticalCutReveal splitBy="characters" staggerDuration={0.03} staggerFrom="center">
			{'Reveal me ↑'}
		</VerticalCutReveal>
	</div>
	</>
}
