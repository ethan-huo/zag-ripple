import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Each animated square tracks position + a version counter. The version
// increments on every "animation complete → new position" cycle, which lets
// the effect re-trigger the next animation without remounting DOM nodes.
type Square = { id: number; pos: [number, number]; version: number };

// Imperative approach: rects are rendered into a stable DOM list; animations
// are driven by `animate()` promises rather than by keyed remounting, because
// Ripple's SVG reconciler doesn't guarantee motion.rect–style lifecycle hooks.
export function AnimatedGridPattern({
	width = 40,
	height = 40,
	x = -1,
	y = -1,
	strokeDasharray = 0,
	numSquares = 50,
	maxOpacity = 0.5,
	duration = 4,
	repeatDelay = 0.5,
	class: className,
	...rest
}: any) @{
	// Stable unique id so multiple instances don't share a <pattern> id.
	const patternId = `agp-${Math.random().toString(36).slice(2, 8)}`;

	const svgRef = track<SVGSVGElement | null>(null);
	const dims = track({ w: 0, h: 0 });
	const squares = track<Square[]>([]);
	// Map from square id to its SVGRectElement so we can animate imperatively.
	const rectMap = new Map<number, SVGRectElement>();

	// Random grid-cell position given current known dimensions.
	const randomPos = (): [number, number] => [
		Math.floor((Math.random() * dims.value.w) / width),
		Math.floor((Math.random() * dims.value.h) / height),
	];

	// Animate one rect: fade in to maxOpacity, then reverse back to 0, then
	// recurse with a fresh position. Mirrors the original Svelte animation loop
	// (repeat: 1, repeatType: "reverse") driven by onAnimationComplete.
	const animateSquare = (sq: Square) => {
		const el = rectMap.get(sq.id);
		if (!el) return;

		animate(el, { opacity: [0, maxOpacity] }, { duration, delay: sq.id * 0.1, ease: 'easeInOut' })
			.then(() =>
				animate(el, { opacity: [maxOpacity, 0] }, { duration, delay: repeatDelay, ease: 'easeInOut' }),
			)
			.then(() => {
				// Reposition square and bump version so the reactive list stays in sync.
				const list = squares.value.slice();
				const idx = list.findIndex((s) => s.id === sq.id);
				if (idx === -1) return;
				const next: Square = { id: sq.id, pos: randomPos(), version: sq.version + 1 };
				list[idx] = next;
				squares.value = list;
				animateSquare(next);
			});
	};

	// Observe container size; generate initial squares once we have dimensions.
	effect(() => {
		const el = svgRef.value;
		if (!el) return;

		const ro = new ResizeObserver((entries) => {
			const r = entries[0]?.contentRect;
			if (!r) return;
			const { width: w, height: h } = r;
			if (dims.value.w === w && dims.value.h === h) return;
			dims.value = { w, h };
		});
		ro.observe(el);
		return () => ro.disconnect();
	});

	// When dimensions become available, (re-)generate squares and kick off
	// animations. Guard against zero dimensions to avoid NaN grid positions.
	effect(() => {
		const { w, h } = dims.value;
		if (!w || !h) return;

		// Clear stale rect refs before rebuilding the square list.
		rectMap.clear();

		const list: Square[] = Array.from({ length: numSquares }, (_, i) => ({
			id: i,
			pos: [
				Math.floor((Math.random() * w) / width),
				Math.floor((Math.random() * h) / height),
			],
			version: 0,
		}));
		squares.value = list;
		// Animations are started from the ref callback once the rects mount.
	});

	<>
	<svg
		ref={(el) => { svgRef.value = el; }}
		aria-hidden="true"
		class={cn(
			'pointer-events-none absolute inset-0 h-full w-full fill-gray-400/30 stroke-gray-400/30',
			className,
		)}
		{...rest}
	>
		<defs>
			<pattern id={patternId} width={width} height={height} patternUnits="userSpaceOnUse" x={x} y={y}>
				<path d={`M.5 ${height}V.5H${width}`} fill="none" strokeDasharray={strokeDasharray} />
			</pattern>
		</defs>
		<rect width="100%" height="100%" fill={`url(#${patternId})`} />
		<svg x={x} y={y} overflow="visible">
			@for (const sq of squares.value; index i) {
				<rect
					ref={(el) => {
						if (!el) { rectMap.delete(sq.id); return; }
						const isNew = !rectMap.has(sq.id);
						rectMap.set(sq.id, el as SVGRectElement);
						// Start animation only when the rect is first mounted.
						if (isNew) animateSquare(sq);
					}}
					width={width - 1}
					height={height - 1}
					x={sq.pos[0] * width + 1}
					y={sq.pos[1] * height + 1}
					fill="currentColor"
					stroke="none"
					opacity={0}
				/>
			}
		</svg>
	</svg>
	</>
}
