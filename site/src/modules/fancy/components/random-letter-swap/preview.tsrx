import { RandomLetterSwap } from './random-letter-swap.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 text-3xl font-semibold">
		<RandomLetterSwap label="Hover me" class="cursor-pointer" />
		<RandomLetterSwap
			label="Random"
			reverse={false}
			class="cursor-pointer text-primary"
		/>
		<RandomLetterSwap
			label="Letter Swap"
			staggerDuration={0.04}
			class="cursor-pointer text-muted-foreground"
		/>
	</div>
	</>
}
