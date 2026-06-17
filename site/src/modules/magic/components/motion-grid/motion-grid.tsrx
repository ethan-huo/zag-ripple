import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// MotionGrid + MotionGridCells — co-located because TSRX has no
// setContext/getContext equivalent of Svelte's context API. The Svelte source
// used context purely as a sibling-to-sibling data channel; here MotionGrid
// exposes a render-prop callback so callers can pass the derived state down
// explicitly instead.
//
// MotionGridCells imperatively animates cells via a ref-based element map: the
// active set changes on each frame tick, triggering an effect that calls
// animate() on every cell that flipped. This sidesteps the "prop changes
// don't re-run child effects" limitation of functional TSRX components.

export type FrameDot = [number, number];
export type Frame = FrameDot[];
export type Frames = Frame[];

// ── MotionGrid ───────────────────────────────────────────────────────────────

// Ticking container. Advances through `frames` on a `duration`-ms interval.
//
// Ripple children cannot be called as a function, so this component uses an
// explicit `renderCells` render-prop instead of the Svelte snippet pattern.
//
// Usage:
//   <MotionGrid
//     gridSize={[5, 5]} frames={FRAMES} duration={220}
//     renderCells={(ctx) => <MotionGridCells {...ctx} activeProps={...} inactiveProps={...} />}
//   />
//
// Pass `children` for plain non-animated content inside the grid wrapper.
export function MotionGrid({
	gridSize,
	frames,
	duration = 200,
	animate: shouldAnimate = true,
	class: className,
	style,
	children,
	renderCells,
	...rest
}: any) @{
	const cols = gridSize[0] as number;
	const rows = gridSize[1] as number;
	const frameIndex = track(0);

	// Reset whenever the frames reference changes (mirrors Svelte: `$effect(() => { frames; index = 0 })`).
	effect(() => {
		void frames;
		frameIndex.value = 0;
	});

	// Clamp to valid range when frames array shrinks.
	effect(() => {
		if (frames.length === 0) {
			frameIndex.value = 0;
		} else if (frameIndex.value >= frames.length) {
			frameIndex.value = 0;
		}
	});

	// Advance the frame on a fixed interval.
	effect(() => {
		if (!shouldAnimate || frames.length === 0) return;
		const id = setInterval(() => {
			frameIndex.value = (frameIndex.value + 1) % frames.length;
		}, duration);
		return () => clearInterval(id);
	});

	const gridStyle = `display: grid; grid-template-columns: repeat(${cols}, minmax(0, 1fr)); grid-auto-rows: 1fr;${style ? ' ' + style : ''}`;

	<>
	<div
		class={className}
		style={gridStyle}
		data-animate={shouldAnimate}
		{...rest}
	>
		@if (renderCells) {
			{renderCells({ frameIndex, cols, rows, frames, transitionDuration: duration / 1000 })}
		} @else {
			{children}
		}
	</div>
	</>
}

// ── MotionGridCells ──────────────────────────────────────────────────────────

// Renders cols × rows cells and imperatively animates each between
// `activeProps` and `inactiveProps` when the active set changes.
//
// `frameIndex` is a tracked reference (from MotionGrid's render-prop ctx), so
// the effect here reacts to its `.value` changes.
export function MotionGridCells({
	cols,
	rows,
	frames,
	frameIndex,
	transitionDuration = 0.2,
	activeProps,
	inactiveProps,
	class: baseClass,
	style: baseStyle,
}: any) @{
	const totalCells = cols * rows;

	// Element map: cell index → DOM node, populated via ref callbacks.
	// Using a plain Map (not tracked) because DOM nodes are never rendered into JSX —
	// they're only consumed inside an effect, so reactivity tracking is unnecessary.
	const cellNodes = new Map<number, HTMLElement>();

	// Derive the active set from the current frame.
	const active = track(() => {
		const fi = typeof frameIndex === 'object' ? frameIndex.value : frameIndex;
		const frameData: FrameDot[] = frames[fi] ?? [];
		return new Set<number>(frameData.map(([x, y]) => y * cols + x));
	});

	// When the active set changes, animate every cell that flipped state.
	// The previous set is cached so we only touch cells that actually changed.
	let prevActive = new Set<number>();
	effect(() => {
		const next = active.value;
		for (let i = 0; i < totalCells; i++) {
			const wasActive = prevActive.has(i);
			const isActive = next.has(i);
			if (wasActive === isActive) continue;

			const el = cellNodes.get(i);
			if (!el) continue;

			const vp = (isActive ? activeProps : inactiveProps) ?? {};
			// Collect animatable CSS properties from the variant object.
			// Class/style switches happen via the data-active attribute + CSS, while
			// explicit CSS-in-props like opacity, scale, backgroundColor are animated.
			const animatableKeys = ['opacity', 'scale', 'backgroundColor', 'color', 'borderColor'];
			const target: Record<string, unknown> = {};
			for (const key of animatableKeys) {
				if (key in vp) target[key] = vp[key];
			}
			if (Object.keys(target).length > 0) {
				animate(el, target, { duration: transitionDuration, ease: 'easeInOut' });
			}
		}
		prevActive = new Set(next);
	});

	// Merge base + variant class/style strings (used on initial render and class attr).
	function cellClass(i: number) {
		const isActive = active.value.has(i);
		const vp = (isActive ? activeProps : inactiveProps) ?? {};
		return cn(baseClass, vp.class) || undefined;
	}

	function cellStyleStr(i: number) {
		const isActive = active.value.has(i);
		const vp = (isActive ? activeProps : inactiveProps) ?? {};
		const base: Record<string, string> = baseStyle ?? {};
		const variant: Record<string, string> = vp.style ?? {};
		const merged = { ...base, ...variant };
		const entries = Object.entries(merged);
		if (entries.length === 0) return undefined;
		return entries.map(([k, v]) => `${k.replace(/([A-Z])/g, (m) => `-${m.toLowerCase()}`)}: ${v}`).join('; ');
	}

	<>
	@for (const _ of Array.from({ length: totalCells }); index i) {
		<div
			ref={(el) => {
				if (el) cellNodes.set(i, el as HTMLElement);
				else cellNodes.delete(i);
			}}
			class={cellClass(i)}
			style={cellStyleStr(i)}
			data-active={active.value.has(i)}
		/>
	}
	</>
}
