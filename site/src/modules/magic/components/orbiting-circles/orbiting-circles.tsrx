import { track } from 'ripple';
import { cn } from '@/lib/utils';

// The orbit CSS animation reads --duration, --radius, --angle, --delay, and
// --icon-size from per-element inline styles; the keyframe lives in a
// component-scoped <style> block so it doesn't pollute the shared stylesheet.
// `direction: reverse` is handled via an animation-direction inline style
// rather than a Tailwind utility — direction-[reverse] is a bespoke class that
// only exists in the source project's layout.css.
export function OrbitingCircles({
	children,
	class: className,
	reverse = false,
	duration = 20,
	radius = 160,
	path = false,
	iconSize = 30,
	speed = 1,
	angle = 0,
	delay = 0,
	...props
}: any) @{
	const calculatedDuration = track(() => duration / speed);

	const inlineStyle = track(() => {
		// CSS vars feed the @keyframes calculation; animation-delay uses the delay
		// value directly (negative = start mid-orbit, matching the source convention).
		const parts = [
			`--duration: ${calculatedDuration.value}`,
			`--radius: ${radius}`,
			`--angle: ${angle}`,
			`--icon-size: ${iconSize}px`,
			`animation-delay: ${delay * 1000}ms`,
		];
		if (reverse) parts.push('animation-direction: reverse');
		return parts.join('; ');
	});

	<>
	@if (path) {
		<svg
			xmlns="http://www.w3.org/2000/svg"
			version="1.1"
			class="pointer-events-none absolute inset-0 size-full"
		>
			<circle
				class="stroke-1 stroke-black/20 dark:stroke-white/20"
				cx="50%"
				cy="50%"
				r={radius}
				fill="none"
				stroke-dasharray="4 4"
			/>
		</svg>
	}
	<div
		{...props}
		style={inlineStyle.value}
		class={cn(
			'orbiting-circles absolute flex transform-gpu items-center justify-center rounded-full',
			'size-(--icon-size)',
			className,
		)}
	>
		{children}
	</div>

	<style>
		@keyframes magic-orbit {
			0% {
				transform: rotate(calc(var(--angle) * 1deg)) translateY(calc(var(--radius) * 1px))
					rotate(calc(var(--angle) * -1deg));
			}
			100% {
				transform: rotate(calc(var(--angle) * 1deg + 360deg)) translateY(calc(var(--radius) * 1px))
					rotate(calc((var(--angle) * -1deg) - 360deg));
			}
		}
		.orbiting-circles {
			animation: magic-orbit calc(var(--duration) * 1s) linear infinite;
		}
	</style>
	</>
}
