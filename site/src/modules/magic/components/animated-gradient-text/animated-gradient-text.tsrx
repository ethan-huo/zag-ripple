import { cn } from '@/lib/utils';

// The gradient animation is a simple CSS keyframe that shifts backgroundPosition.
// `animate-gradient` in the source is a Tailwind theme alias for "gradient 8s linear infinite";
// we define the keyframe locally so no global CSS change is needed.
export function AnimatedGradientText({
	children,
	class: className,
	speed = 1,
	colorFrom = '#ffaa40',
	colorTo = '#9c40ff',
	...rest
}: any) @{
	// bg-size scales with speed: higher speed → larger bg-size → faster apparent shift per cycle.
	const bgSize = `${300 * speed}%`;

	<>
	<span
		{...rest}
		class={cn(
			'magic-animated-gradient-text inline bg-linear-to-r from-(--color-from) via-(--color-to) to-(--color-from) bg-clip-text text-transparent',
			className,
		)}
		style={`--color-from: ${colorFrom}; --color-to: ${colorTo}; --magic-agt-bg-size: ${bgSize};`}
	>
		{children}
	</span>

	<style>
		@keyframes magic-gradient-shift {
			0% { background-position: 0% 50%; }
			100% { background-position: 100% 50%; }
		}
		.magic-animated-gradient-text {
			background-size: var(--magic-agt-bg-size, 300%) 100%;
			animation: magic-gradient-shift 8s linear infinite;
		}
	</style>
	</>
}
