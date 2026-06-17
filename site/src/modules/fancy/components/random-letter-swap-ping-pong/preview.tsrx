import { RandomLetterSwapPingPong } from './random-letter-swap-ping-pong.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 text-3xl font-semibold">
		<RandomLetterSwapPingPong label="Hover me" class="cursor-pointer" />
		<RandomLetterSwapPingPong
			label="Random"
			reverse={false}
			class="cursor-pointer text-primary"
		/>
		<RandomLetterSwapPingPong
			label="Ping Pong"
			staggerDuration={0.04}
			class="cursor-pointer text-muted-foreground"
		/>
	</div>
	</>
}
