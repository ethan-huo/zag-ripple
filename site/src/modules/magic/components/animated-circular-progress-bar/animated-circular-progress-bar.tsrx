import { track } from 'ripple';
import { cn } from '@/lib/utils';

// CSS custom-property trick: stroke-dasharray is driven by `--stroke-percent`
// and `--percent-to-px`, so the browser's CSS transition handles the smooth
// animation without any JS animation frame loop. The secondary arc (gap fill)
// only renders when progress is between 0 and 90 % — at the extremes the arc
// math degenerates and the gap disappears naturally.
export function AnimatedCircularProgressBar({
	max = 100,
	min = 0,
	value = 0,
	gaugePrimaryColor,
	gaugeSecondaryColor,
	class: className,
}: any) @{
	const circumference = 2 * Math.PI * 45;
	const percentPx = circumference / 100;

	const currentPercent = track(() => Math.round(((value - min) / (max - min)) * 100));

	const containerStyle = [
		'--circle-size: 100px',
		`--circumference: ${circumference}`,
		`--percent-to-px: ${percentPx}px`,
		'--gap-percent: 5',
		'--offset-factor: 0',
		'--transition-length: 1s',
		'--transition-step: 200ms',
		'--delay: 0s',
		'--percent-to-deg: 3.6deg',
		'transform: translateZ(0)',
	].join('; ');

	<>
	<div
		class={cn('relative size-40 text-2xl font-semibold', className)}
		style={containerStyle}
	>
		<svg fill="none" class="size-full" stroke-width="2" viewBox="0 0 100 100">
			@if (currentPercent.value <= 90 && currentPercent.value >= 0) {
				<circle
					cx="50"
					cy="50"
					r="45"
					stroke-width="10"
					stroke-dashoffset="0"
					stroke-linecap="round"
					stroke-linejoin="round"
					class="opacity-100"
					style={[
						`stroke: ${gaugeSecondaryColor}`,
						`--stroke-percent: ${90 - currentPercent.value}`,
						'--offset-factor-secondary: calc(1 - var(--offset-factor))',
						'stroke-dasharray: calc(var(--stroke-percent) * var(--percent-to-px)) var(--circumference)',
						'transform: rotate(calc(1turn - 90deg - (var(--gap-percent) * var(--percent-to-deg) * var(--offset-factor-secondary)))) scaleY(-1)',
						'transition: all var(--transition-length) ease var(--delay)',
						'transform-origin: calc(var(--circle-size) / 2) calc(var(--circle-size) / 2)',
					].join('; ')}
				/>
			}
			<circle
				cx="50"
				cy="50"
				r="45"
				stroke-width="10"
				stroke-dashoffset="0"
				stroke-linecap="round"
				stroke-linejoin="round"
				class="opacity-100"
				style={[
					`stroke: ${gaugePrimaryColor}`,
					`--stroke-percent: ${currentPercent.value}`,
					'stroke-dasharray: calc(var(--stroke-percent) * var(--percent-to-px)) var(--circumference)',
					'transition: var(--transition-length) ease var(--delay), stroke var(--transition-length) ease var(--delay)',
					'transition-property: stroke-dasharray, transform',
					'transform: rotate(calc(-90deg + var(--gap-percent) * var(--offset-factor) * var(--percent-to-deg)))',
					'transform-origin: calc(var(--circle-size) / 2) calc(var(--circle-size) / 2)',
				].join('; ')}
			/>
		</svg>
		<span
			data-current-value={currentPercent.value}
			class="acpb-label absolute inset-0 m-auto size-fit"
		>
			{currentPercent.value}
		</span>
	</div>

	<style>
		@keyframes acpb-fade-in {
			from { opacity: 0; }
			to   { opacity: 1; }
		}
		.acpb-label {
			animation: acpb-fade-in var(--transition-length, 1s) ease var(--delay, 0s) both;
		}
	</style>
	</>
}
