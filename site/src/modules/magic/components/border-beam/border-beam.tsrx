import { Motion } from '@/lib/motion';
import { cn } from '@/lib/utils';

// A light beam travels the border by animating `offset-distance` along an
// `offset-path` rectangle. Drop it inside any `relative` rounded container.
export function BorderBeam({
	class: className,
	size = 50,
	delay = 0,
	duration = 6,
	colorFrom = '#ffaa40',
	colorTo = '#9c40ff',
	transition,
	reverse = false,
	initialOffset = 0,
	borderWidth = 1,
}: any) @{
	const animateConfig = {
		offsetDistance: reverse
			? [`${100 - initialOffset}%`, `${-initialOffset}%`]
			: [`${initialOffset}%`, `${100 + initialOffset}%`],
	};
	const transitionConfig = {
		repeat: Infinity,
		ease: 'linear',
		duration,
		delay: -delay,
		...transition,
	};
	const beamStyle = `width: ${size}px; offset-path: rect(0 auto auto 0 round ${size}px); --color-from: ${colorFrom}; --color-to: ${colorTo};`;

	<>
	<div
		class="pointer-events-none absolute inset-0 rounded-[inherit] border-(length:--border-beam-width) border-transparent mask-[linear-gradient(transparent,transparent),linear-gradient(#000,#000)] mask-intersect [mask-clip:padding-box,border-box]"
		style={`--border-beam-width: ${borderWidth}px;`}
	>
		<Motion
			class={cn(
				'absolute aspect-square bg-linear-to-l from-(--color-from) via-(--color-to) to-transparent',
				className,
			)}
			style={beamStyle}
			animate={animateConfig}
			transition={transitionConfig}
		/>
	</div>
	</>
}
