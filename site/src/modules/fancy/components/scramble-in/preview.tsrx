import { ScrambleIn } from './scramble-in.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-3 font-mono text-2xl font-medium">
		<ScrambleIn text="Decrypting message..." scrambledClass="text-primary" />
		<ScrambleIn text="Welcome to Ripple" scrambleDelay={600} scrambledClass="text-muted-foreground" />
	</div>
	</>
}
