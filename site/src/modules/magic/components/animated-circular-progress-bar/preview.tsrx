import { effect, track } from 'ripple';
import { AnimatedCircularProgressBar } from './animated-circular-progress-bar.tsrx';

export function Preview() @{
	const value = track(60);

	// Oscillate the progress value so the animation is visible in the preview.
	effect(() => {
		let ascending = true;
		const id = setInterval(() => {
			if (ascending) {
				value.value = Math.min(value.value + 1, 100);
				if (value.value >= 100) ascending = false;
			} else {
				value.value = Math.max(value.value - 1, 0);
				if (value.value <= 0) ascending = true;
			}
		}, 50);
		return () => clearInterval(id);
	});

	<>
	<div class="flex items-center justify-center gap-8 p-8">
		<AnimatedCircularProgressBar
			value={value.value}
			gaugePrimaryColor="rgb(79 70 229)"
			gaugeSecondaryColor="rgba(79 70 229 / 0.15)"
		/>
	</div>
	</>
}
