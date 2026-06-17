import { LetterSwapPingPong } from './letter-swap-ping-pong.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 text-3xl font-semibold">
		<LetterSwapPingPong label="Hover me" staggerFrom="first" class="cursor-pointer" />
		<LetterSwapPingPong
			label="Ripple"
			reverse={false}
			staggerFrom="center"
			class="cursor-pointer text-primary"
		/>
		<LetterSwapPingPong
			label="Ping Pong"
			staggerFrom="last"
			class="cursor-pointer text-muted-foreground"
		/>
	</div>
	</>
}
