import { effect, track } from 'ripple';
import { animate, inView, toKeyframes } from './animate';

// Minimal Ripple stand-in for motion-sv's `motion.div`. It animates from
// `initial` to `animate` once on mount (or when scrolled into view). It renders a
// <div>; components needing another tag animate their own element via the
// `animate`/`useInView` helpers instead — that keeps this primitive ref-safe and
// free of Dynamic-tag edge cases.
export function Motion({
	initial,
	animate: target,
	transition,
	inView: triggerInView = false,
	amount = 0.2,
	margin,
	once = true,
	class: className,
	style,
	children,
	...rest
}: any) @{
	let node = track<HTMLElement | null>(null);

	effect(() => {
		const el = node.value;
		if (!el || !target) return;

		const keyframes = toKeyframes(initial, target);
		// Snap to `initial` immediately so the element doesn't flash at its rest
		// state before the entrance animation (or before it scrolls into view).
		if (initial) animate(el, initial, { duration: 0 });

		if (triggerInView) {
			return inView(
				el,
				() => {
					animate(el, keyframes, transition);
					if (once === false) return undefined;
				},
				{ amount, margin: margin as never },
			);
		}

		const controls = animate(el, keyframes, transition);
		return () => controls.stop();
	});

	<>
	<div
		ref={(el) => {
			node.value = el;
		}}
		class={className}
		style={style}
		{...rest}
	>
		{children}
	</div>
	</>
}
