import { ScrambleHover } from './scramble-hover.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-4 font-mono text-2xl font-medium">
		<ScrambleHover text="Scramble on hover" class="cursor-pointer" scrambledClass="text-primary" />
		<ScrambleHover
			text="Sequential reveal"
			sequential
			revealDirection="center"
			class="cursor-pointer text-muted-foreground"
			scrambledClass="text-foreground"
		/>
	</div>
	</>
}
