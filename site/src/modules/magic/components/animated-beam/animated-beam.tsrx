import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Monotonic counter for SSR-stable gradient ids: same sequence on server and
// client as long as component render order is consistent across both passes.
let _beamCounter = 0;

// Draws an SVG beam between two DOM elements inside a shared container.
// Path geometry is recalculated on mount and whenever the container resizes —
// all DOM reads live in effects (SSR-safe: render body emits only static SVG).
// The gradient animation targets the <linearGradient> SVG element directly via
// motion's `animate()`, which handles SVG presentation attributes just like CSS.
export function AnimatedBeam({
	class: className,
	containerRef,
	fromRef,
	toRef,
	curvature = 0,
	reverse = false,
	duration = Math.random() * 3 + 4,
	delay = 0,
	pathColor = 'gray',
	pathWidth = 2,
	pathOpacity = 0.2,
	gradientStartColor = '#ffaa40',
	gradientStopColor = '#9c40ff',
	startXOffset = 0,
	startYOffset = 0,
	endXOffset = 0,
	endYOffset = 0,
}: any) @{
	// Counter-based id: same render order → same id on SSR and hydrate passes.
	const id = `ab-gradient-${++_beamCounter}`;

	const pathD = track('');
	const svgWidth = track(0);
	const svgHeight = track(0);
	let gradientEl = track<SVGLinearGradientElement | null>(null);

	// Gradient coordinate keyframes depend only on `reverse` (static prop).
	const gradientCoords = reverse
		? { x1: ['90%', '-10%'], x2: ['100%', '0%'], y1: ['0%', '0%'], y2: ['0%', '0%'] }
		: { x1: ['10%', '110%'], x2: ['0%', '100%'], y1: ['0%', '0%'], y2: ['0%', '0%'] };

	function recalcPath() {
		const container = containerRef?.value ?? containerRef;
		const from = fromRef?.value ?? fromRef;
		const to = toRef?.value ?? toRef;
		if (!container || !from || !to) return;

		const cRect = container.getBoundingClientRect();
		const aRect = from.getBoundingClientRect();
		const bRect = to.getBoundingClientRect();

		svgWidth.value = cRect.width;
		svgHeight.value = cRect.height;

		const startX = aRect.left - cRect.left + aRect.width / 2 + startXOffset;
		const startY = aRect.top - cRect.top + aRect.height / 2 + startYOffset;
		const endX = bRect.left - cRect.left + bRect.width / 2 + endXOffset;
		const endY = bRect.top - cRect.top + bRect.height / 2 + endYOffset;
		const controlY = startY - curvature;

		pathD.value = `M ${startX},${startY} Q ${(startX + endX) / 2},${controlY} ${endX},${endY}`;
	}

	// Mount: calculate path, set up ResizeObserver, kick off gradient animation.
	// Read .value here so Ripple tracks the dependency — the effect re-runs when
	// refs are populated (ref callbacks fire during DOM commit, before effects).
	effect(() => {
		const container = containerRef?.value ?? containerRef;
		// Touch fromRef/toRef values so this effect re-runs if they change.
		const from = fromRef?.value ?? fromRef;
		const to = toRef?.value ?? toRef;
		if (!container || !from || !to) return;

		recalcPath();

		const ro = new ResizeObserver(() => recalcPath());
		ro.observe(container);
		return () => ro.disconnect();
	});

	// Animate the linearGradient once it mounts (ref callback fires before effects,
	// but effect ordering guarantees the gradient el is set before this runs).
	effect(() => {
		const el = gradientEl.value;
		if (!el) return;

		// Start from initial position so the first frame is correct.
		animate(el, { x1: gradientCoords.x1[0], x2: gradientCoords.x2[0], y1: gradientCoords.y1[0], y2: gradientCoords.y2[0] }, { duration: 0 });

		const controls = animate(
			el,
			{ x1: gradientCoords.x1, x2: gradientCoords.x2, y1: gradientCoords.y1, y2: gradientCoords.y2 },
			{ delay, duration, ease: [0.16, 1, 0.3, 1], repeat: Infinity, repeatDelay: 0 },
		);
		return () => controls.stop();
	});

	<>
	<svg
		fill="none"
		width={svgWidth.value || undefined}
		height={svgHeight.value || undefined}
		xmlns="http://www.w3.org/2000/svg"
		class={cn('pointer-events-none absolute top-0 left-0 transform-gpu', className)}
		viewBox={`0 0 ${svgWidth.value} ${svgHeight.value}`}
	>
		<path
			d={pathD.value}
			stroke={pathColor}
			stroke-width={pathWidth}
			stroke-opacity={pathOpacity}
			stroke-linecap="round"
		/>
		<path
			d={pathD.value}
			stroke-width={pathWidth}
			stroke={`url(#${id})`}
			stroke-opacity="1"
			stroke-linecap="round"
		/>
		<defs>
			<linearGradient
				ref={(el: SVGLinearGradientElement) => { gradientEl.value = el; }}
				id={id}
				gradientUnits="userSpaceOnUse"
				x1="0%"
				x2="0%"
				y1="0%"
				y2="0%"
			>
				<stop stop-color={gradientStartColor} stop-opacity="0" />
				<stop stop-color={gradientStartColor} />
				<stop offset="32.5%" stop-color={gradientStopColor} />
				<stop offset="100%" stop-color={gradientStopColor} stop-opacity="0" />
			</linearGradient>
		</defs>
	</svg>
	</>
}
