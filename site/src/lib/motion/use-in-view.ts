import { effect, track } from 'ripple';
import { inView } from 'motion';

export type InViewOptions = {
	once?: boolean;
	amount?: number | 'some' | 'all';
	margin?: string;
};

// Ripple equivalent of motion-sv's `useInView`: returns a `ref` setter to attach
// to the watched element and a tracked `visible` flag. `once` (default) latches
// true on first intersection; otherwise it toggles with viewport presence.
export function useInView(options: InViewOptions = {}) {
	const node = track<HTMLElement | null>(null);
	const visible = track(false);

	effect(() => {
		const el = node.value;
		if (!el) return;

		const stop = inView(
			el,
			() => {
				visible.value = true;
				if (options.once === false) {
					return () => {
						visible.value = false;
					};
				}
			},
			{ amount: options.amount ?? 0.2, margin: options.margin as never },
		);

		return stop;
	});

	return {
		ref: (el: HTMLElement | null) => {
			node.value = el;
		},
		visible,
	};
}
