import { GradientWaveText } from './gradient-wave-text.tsrx';

export function Preview() @{
	<>
	<GradientWaveText
		class="text-5xl font-bold tracking-tight md:text-6xl"
		repeat
		speed={1.2}
	>
		{'Gradient Wave'}
	</GradientWaveText>
	</>
}
