import { LetterSwap } from './letter-swap.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-4 text-3xl font-semibold">
		<LetterSwap label="Hover me" staggerFrom="first" class="cursor-pointer" />
		<LetterSwap label="Ripple" reverse={false} staggerFrom="center" class="cursor-pointer text-primary" />
	</div>
	</>
}
