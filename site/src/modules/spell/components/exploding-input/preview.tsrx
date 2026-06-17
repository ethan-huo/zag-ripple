import { ExplodingInput } from './exploding-input.tsrx';

// Wrap input + ExplodingInput inside a <label> so the overlay can resolve
// the input via closest('label').querySelector('input').
export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 p-8">
		<label class="relative flex flex-col gap-2">
			<span class="text-sm font-medium text-muted-foreground">{'Type something…'}</span>
			<input
				type="text"
				placeholder="Type here to see particles"
				class="w-72 rounded-lg border border-border bg-card px-4 py-2.5 text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-primary"
			/>
			<ExplodingInput
				count={3}
				duration={1.8}
				gravity={0.5}
				direction={{ horizontal: 'center', vertical: 'top' }}
				scale={{ value: 1, randomize: true, randomVariation: 30 }}
				rotation={{ value: 0, animate: true }}
			/>
		</label>
		<p class="text-xs text-muted-foreground">{'Particles burst from the caret on each keystroke.'}</p>
	</div>
	</>
}
