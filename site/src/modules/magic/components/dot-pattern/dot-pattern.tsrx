import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Dots are generated client-side via ResizeObserver because the SVG must
// know its own pixel dimensions to fill the container — unavailable at SSR.
// The `glow` path animates each circle element imperatively (like
// animated-grid-pattern) rather than using <Motion> because Motion renders a
// <div> and SVG children must be real SVG elements.
export function DotPattern({
	width = 16,
	height = 16,
	x = 0,
	y = 0,
	cx = 1,
	cy = 1,
	cr = 1,
	glow = false,
	class: className,
	...rest
}: any) @{
	// Stable id so multiple instances don't clash inside the same <defs> tree.
	const gradientId = `dp-grad-${Math.random().toString(36).slice(2, 8)}`;

	const svgRef = track<SVGSVGElement | null>(null);
	const dims = track({ w: 0, h: 0 });
	const dots = track<Array<{ x: number; y: number; delay: number; duration: number }>>([]);

	// Map from dot key to its SVGCircleElement for imperative glow animation.
	const circleMap = new Map<string, SVGCircleElement>();

	// Rebuild the dot grid whenever dimensions change.
	effect(() => {
		const { w, h } = dims.value;
		if (!w || !h) return;

		const cols = Math.ceil(w / width);
		const rows = Math.ceil(h / height);

		const next = Array.from({ length: cols * rows }, (_, i) => {
			const col = i % cols;
			const row = Math.floor(i / cols);
			return {
				x: col * width + cx,
				y: row * height + cy,
				// Pre-compute per-dot randomness once so stable across re-renders.
				delay: Math.random() * 5,
				duration: Math.random() * 3 + 2,
			};
		});

		circleMap.clear();
		dots.value = next;
	});

	// Observe the SVG's own size (fills 100% of its positioned ancestor).
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

	// Animate glow on each circle. Runs once per circle via the ref callback.
	const startGlow = (el: SVGCircleElement, dot: { delay: number; duration: number }) => {
		// Loop: opacity 0.4 → 1 → 0.4, scale 1 → 1.5 → 1, reversing forever.
		const loop = () => {
			animate(
				el,
				{ opacity: [0.4, 1, 0.4], scale: [1, 1.5, 1] },
				{ duration: dot.duration, delay: dot.delay, ease: 'easeInOut', repeat: Infinity },
			);
		};
		loop();
	};

	const dotKey = (dot: { x: number; y: number }) => `${dot.x}-${dot.y}`;

	<>
	<svg
		ref={(el) => { svgRef.value = el; }}
		aria-hidden="true"
		class={cn('pointer-events-none absolute inset-0 h-full w-full text-neutral-400/80', className)}
		{...rest}
	>
		@if (glow) {
			<defs>
				<radialGradient id={gradientId}>
					<stop offset="0%" stop-color="currentColor" stop-opacity="1" />
					<stop offset="100%" stop-color="currentColor" stop-opacity="0" />
				</radialGradient>
			</defs>
		}
		@for (const dot of dots.value; index i) {
			<circle
				cx={dot.x}
				cy={dot.y}
				r={cr}
				fill={glow ? `url(#${gradientId})` : 'currentColor'}
				opacity={glow ? 0.4 : 1}
				ref={(el) => {
					const k = dotKey(dot);
					if (!el) { circleMap.delete(k); return; }
					const isNew = !circleMap.has(k);
					circleMap.set(k, el as SVGCircleElement);
					if (isNew && glow) startGlow(el as SVGCircleElement, dot);
				}}
			/>
		}
	</svg>
	</>
}
