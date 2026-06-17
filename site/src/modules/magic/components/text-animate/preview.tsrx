import { TextAnimate } from './text-animate.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6 p-8 text-center">
		<TextAnimate
			content="Animate words as they enter the view."
			by="word"
			animation="blurInUp"
			class="text-2xl font-bold tracking-tight text-foreground"
		/>
		<TextAnimate
			content="Character by character."
			by="character"
			animation="fadeIn"
			duration={0.8}
			class="text-lg font-medium text-muted-foreground"
		/>
		<TextAnimate
			content="Slide right into focus."
			by="word"
			animation="slideRight"
			class="text-base text-primary font-semibold"
		/>
	</div>
	</>
}
