// Framework-agnostic wrappers over the `motion` (framer-motion/dom) engine.
// Ripple has no Motion port, so the whole animation module is built on these
// thin helpers + the `<Motion>` component below them. Keeping the surface tiny
// means every ported component animates through one code path.
import { animate, inView, stagger } from 'motion';

export { animate, inView, stagger };

type StyleTarget = Record<string, unknown>;

// framer's `animate(el, keyframes)` reads the "from" value off the live element.
// To honor an explicit `initial`, fold each shared key into a [from, to] pair so
// the engine starts from `initial` instead of the computed style.
export function toKeyframes(
	initial: StyleTarget | undefined,
	target: StyleTarget,
): Record<string, unknown> {
	const out: Record<string, unknown> = {};
	for (const key in target) {
		const to = target[key];
		out[key] = initial && key in initial ? [initial[key], to] : to;
	}
	return out;
}
