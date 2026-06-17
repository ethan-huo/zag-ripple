import { cn } from '@/lib/utils';

// Pure SVG pattern — tiles infinitely in userSpaceOnUse so no DOM measurement
// is needed. Instance-unique id prevents <defs> collisions when multiple
// StripedPattern elements share the same page.
let _counter = 0;

export function StripedPattern({
	direction = 'left',
	width = 10,
	height = 10,
	class: className,
	...rest
}: any) @{
	const id = `sp-${++_counter}-${Math.random().toString(36).slice(2, 6)}`;
	const w = Number(width);
	const h = Number(height);

	<>
	<svg
		aria-hidden="true"
		class={cn('pointer-events-none absolute inset-0 z-10 h-full w-full stroke-[0.5]', className)}
		xmlns="http://www.w3.org/2000/svg"
		{...rest}
	>
		<defs>
			<pattern id={id} width={w} height={h} patternUnits="userSpaceOnUse">
				@if (direction === 'left') {
					<>
					<line x1="0" y1={h} x2={w} y2="0" stroke="currentColor" />
					<line x1={-w} y1={h} x2="0" y2="0" stroke="currentColor" />
					<line x1={w} y1={h} x2={w * 2} y2="0" stroke="currentColor" />
					</>
				} @else {
					<>
					<line x1="0" y1="0" x2={w} y2={h} stroke="currentColor" />
					<line x1={-w} y1="0" x2="0" y2={h} stroke="currentColor" />
					<line x1={w} y1="0" x2={w * 2} y2={h} stroke="currentColor" />
					</>
				}
			</pattern>
		</defs>
		<rect width="100%" height="100%" fill={`url(#${id})`} />
	</svg>
	</>
}
