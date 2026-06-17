import { cn } from '@/lib/utils';

// Concentric pulsing rings radiating from the center — a calm background accent.
export function Ripple({
	mainCircleSize = 210,
	mainCircleOpacity = 0.24,
	numCircles = 8,
	class: className,
	...props
}: any) @{
	const circles = Array.from({ length: numCircles }, (_, i) => i);

	<>
	<div
		class={cn(
			'pointer-events-none absolute inset-0 mask-[linear-gradient(to_bottom,white,transparent)] select-none',
			className,
		)}
		{...props}
	>
		@for (const i of circles) {
			const size = mainCircleSize + i * 70;
			const opacity = mainCircleOpacity - i * 0.03;
			const animationDelay = `${i * 0.06}s`;
			<div
				class="animate-ripple absolute rounded-full border bg-foreground/25 shadow-xl"
				style={`--i: ${i}; width: ${size}px; height: ${size}px; opacity: ${opacity}; animation-delay: ${animationDelay}; border-style: solid; border-width: 1px; border-color: var(--foreground); top: 50%; left: 50%; transform: translate(-50%, -50%) scale(1);`}
			/>
		}
	</div>
	</>
}
