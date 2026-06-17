import { track } from 'ripple';
import { RandomizedText } from './randomized-text.tsrx';

export function Preview() @{
	const triggered = track(false);

	<>
	<div class="flex flex-col items-center gap-8 text-center">
		<div class="space-y-2">
			<p class="text-xs uppercase tracking-widest text-muted-foreground">Words (in-view)</p>
			<div class="text-2xl font-semibold text-foreground">
				<RandomizedText text="Words animate in one by one" triggerOnView duration={1.0} delay={0.15} />
			</div>
		</div>

		<div class="space-y-2">
			<p class="text-xs uppercase tracking-widest text-muted-foreground">Characters</p>
			<div class="text-xl font-mono text-primary">
				<RandomizedText text="char by char" split="chars" triggerOnView delay={0.05} duration={0.8} />
			</div>
		</div>

		<div class="space-y-3">
			<p class="text-xs uppercase tracking-widest text-muted-foreground">Manual trigger</p>
			<div class="text-lg font-medium text-foreground">
				<RandomizedText text="Click the button to replay" trigger={triggered.value} delay={0.1} duration={0.9} />
			</div>
			<button
				class="rounded-md bg-primary px-4 py-1.5 text-sm font-medium text-primary-foreground hover:opacity-90 active:scale-95 transition-all"
				onClick={() => {
					triggered.value = false;
					// Give the reset effect one tick before re-triggering.
					setTimeout(() => { triggered.value = true; }, 30);
				}}
			>
				Replay
			</button>
		</div>
	</div>
	</>
}
