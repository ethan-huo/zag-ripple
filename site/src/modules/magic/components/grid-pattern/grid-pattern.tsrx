import { cn } from '@/lib/utils';

// Pure SVG grid — no DOM measurements needed because the pattern tiles
// infinitely in userSpaceOnUse coordinates regardless of container size.
// The pattern `id` must be unique per instance so that multiple GridPattern
// elements on the same page don't share the same <defs> entry. We combine an
// incrementing module-level counter (stable ordering) with a random suffix
// (guards against SSR→client counter mismatch during hydration).
let _counter = 0;

export function GridPattern({
	width = 40,
	height = 40,
	x = -1,
	y = -1,
	strokeDashArray = '0',
	squares,
	class: className,
	...rest
}: any) @{
	const id = `gp-${++_counter}-${Math.random().toString(36).slice(2, 6)}`;

	<>
	<svg
		aria-hidden="true"
		class={cn(
			'pointer-events-none absolute inset-0 h-full w-full fill-gray-400/30 stroke-gray-400/30',
			className,
		)}
		{...rest}
	>
		<defs>
			<pattern id={id} width={width} height={height} patternUnits="userSpaceOnUse" x={x} y={y}>
				<path d={`M.5 ${height}V.5H${width}`} fill="none" strokeDasharray={strokeDashArray} />
			</pattern>
		</defs>
		<rect width="100%" height="100%" strokeWidth={0} fill={`url(#${id})`} />
		@if (squares && squares.length > 0) {
			<svg x={x} y={y} overflow="visible">
				@for (const sq of squares; index i) {
					<rect
	
						strokeWidth="0"
						width={width - 1}
						height={height - 1}
						x={sq[0] * width + 1}
						y={sq[1] * height + 1}
					/>
				}
			</svg>
		}
	</svg>
	</>
}
