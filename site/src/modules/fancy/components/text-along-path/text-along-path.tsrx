import { effect, track } from 'ripple';

// SVG <animate> handles the "auto" looping case natively in the browser — no JS
// needed. For "scroll", we read scrollYProgress from a scroll event listener
// and imperatively update startOffset on the <textPath> nodes to avoid
// re-rendering the whole SVG on every scroll tick.
//
// `useScroll` from motion-sv has no Ripple equivalent, so we wire a plain
// scroll listener on the scrollContainer (or window) and derive progress the
// same way the original did: clamp(scrollTop / scrollHeight).

let _uid = 0;
function nextId() {
	_uid += 1;
	return _uid;
}

export function TextAlongPath({
	path,
	pathId,
	pathClass,
	preserveAspectRatio = 'xMidYMid meet',
	showPath = false,
	width = '100%',
	height = '100%',
	viewBox = '0 0 100 100',
	svgClass,
	text,
	textClass,
	textAnchor = 'start',
	animationType = 'auto',
	duration = 4,
	repeatCount = 'indefinite',
	easingFunction = {},
	scrollContainer,
	scrollOffset,
	scrollTransformValues = [0, 100],
	...props
}: any) @{
	// Stable per-instance path ID so multiple instances on the same page don't
	// share the same <path> href target. Computed once at construction time, not
	// inside a reactive track, so nextId() is only called once per instance.
	const resolvedPathId = pathId ?? `tap-path-${nextId()}`;
	const isAuto = animationType === 'auto';
	const autoDuration = `${duration}s`;

	// Refs for imperatively updating startOffset in scroll mode (avoids full
	// re-render on every scroll tick).
	const primaryRef = track<SVGTextPathElement | null>(null);
	const secondaryRef = track<SVGTextPathElement | null>(null);

	effect(() => {
		if (animationType !== 'scroll') return;

		const primary = primaryRef.value;
		const secondary = secondaryRef.value;
		// Wait until refs are populated.
		if (!primary) return;

		const [startVal, endVal] = scrollTransformValues as [number, number];

		function update() {
			// Derive scroll progress from the container element or the viewport.
			const container = scrollContainer as HTMLElement | null | undefined;
			let progress: number;
			if (container) {
				const { scrollTop, scrollHeight, clientHeight } = container;
				const max = scrollHeight - clientHeight;
				progress = max > 0 ? Math.min(1, Math.max(0, scrollTop / max)) : 0;
			} else {
				const { scrollY, innerHeight } = window;
				const max = document.documentElement.scrollHeight - innerHeight;
				progress = max > 0 ? Math.min(1, Math.max(0, scrollY / max)) : 0;
			}

			const offset = startVal + (endVal - startVal) * progress;
			primary?.setAttribute('startOffset', `${offset}%`);
			secondary?.setAttribute('startOffset', `${offset - 100}%`);
		}

		const target = (scrollContainer as HTMLElement | null | undefined) ?? window;
		update();
		target.addEventListener('scroll', update, { passive: true });
		return () => target.removeEventListener('scroll', update);
	});

	<>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		class={svgClass}
		width={width}
		height={height}
		viewBox={viewBox}
		preserveAspectRatio={preserveAspectRatio}
		{...props}
	>
		<path
			id={resolvedPathId}
			class={pathClass}
			d={path}
			stroke={showPath ? 'currentColor' : 'none'}
			fill="none"
		/>

		<text text-anchor={textAnchor} fill="currentColor">
			<textPath
				ref={(el: SVGTextPathElement | null) => { primaryRef.value = el; }}
				class={textClass}
				href={`#${resolvedPathId}`}
				startOffset="0%"
			>
				@if (isAuto) {
					<animate
						attributeName="startOffset"
						from="0%"
						to="100%"
						begin="0s"
						dur={autoDuration}
						repeatCount={repeatCount}
						calcMode={(easingFunction as any).calcMode}
						keyTimes={(easingFunction as any).keyTimes}
						keySplines={(easingFunction as any).keySplines}
					/>
				}
				{text}
			</textPath>
		</text>

		@if (isAuto) {
			<text text-anchor={textAnchor} fill="currentColor">
				<textPath
					ref={(el: SVGTextPathElement | null) => { secondaryRef.value = el; }}
					class={textClass}
					href={`#${resolvedPathId}`}
					startOffset="-100%"
				>
					<animate
						attributeName="startOffset"
						from="-100%"
						to="0%"
						begin="0s"
						dur={autoDuration}
						repeatCount={repeatCount}
						calcMode={(easingFunction as any).calcMode}
						keyTimes={(easingFunction as any).keyTimes}
						keySplines={(easingFunction as any).keySplines}
					/>
					{text}
				</textPath>
			</text>
		}
	</svg>
	</>
}
