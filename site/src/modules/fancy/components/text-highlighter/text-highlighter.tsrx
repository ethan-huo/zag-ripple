import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Highlights wrapped text by animating background-size over a gradient fill.
// The `ref` trigger from the original Svelte API (exported animate/reset methods)
// is replaced with an `animated` boolean prop — callers toggle it externally.
// The inner <span> is always a span; the outer wrapper tag is fixed as span
// (covers the default + most common case; drop `as` for a cleaner API surface).

type HighlightDirection = 'ltr' | 'rtl' | 'ttb' | 'btt';
type TriggerType = 'hover' | 'ref' | 'inView' | 'auto';

const DEFAULT_TRANSITION = { type: 'spring' as const, duration: 1, bounce: 0 };

function getBackgroundSize(animated: boolean, dir: HighlightDirection) {
	switch (dir) {
		case 'ltr':
		case 'rtl':
			return animated ? '100% 100%' : '0% 100%';
		case 'ttb':
		case 'btt':
			return animated ? '100% 100%' : '100% 0%';
	}
}

function getBackgroundPosition(dir: HighlightDirection) {
	switch (dir) {
		case 'ltr':
		case 'ttb':
			return '0% 0%';
		case 'rtl':
			return '100% 0%';
		case 'btt':
			return '0% 100%';
	}
}

export function TextHighlighter({
	children,
	triggerType = 'inView',
	transition = DEFAULT_TRANSITION,
	inViewOptions = { once: true, amount: 0.1 },
	highlightColor = 'hsl(25, 90%, 80%)',
	direction = 'ltr',
	// For triggerType="ref": pass a tracked boolean whose `.value` you flip to trigger.
	animated: animatedProp = false,
	class: className,
	onMouseEnter,
	onMouseLeave,
	...rest
}: any) @{
	const isHovered = track(false);
	// Capture the inner span node so we can imperatively animate backgroundSize.
	const innerRef = track<HTMLElement | null>(null);

	// useInView wires up an IntersectionObserver — must be ref-driven, not inline.
	const { ref: inViewRef, visible } = useInView({
		once: inViewOptions?.once ?? true,
		amount: inViewOptions?.amount ?? 0.1,
		margin: inViewOptions?.margin,
	});

	const shouldAnimate = track(() => {
		switch (triggerType) {
			case 'hover':   return isHovered.value;
			case 'inView':  return visible.value;
			case 'ref':     return !!animatedProp;
			case 'auto':    return true;
			default:        return false;
		}
	});

	const dir = track(() => direction as HighlightDirection);

	// Animate background-size imperatively when shouldAnimate or direction changes.
	// background-size is not in the Web Animations API value set that motion handles
	// natively with spring, so we drive it via spring duration + easing approximation.
	effect(() => {
		const el = innerRef.value;
		if (!el) return;
		const active = shouldAnimate.value;
		const d = dir.value;
		const from = getBackgroundSize(!active, d);
		const to = getBackgroundSize(active, d);
		if (from === to) return;

		// motion/dom supports backgroundSize as a discrete string; we drive it as a
		// [from, to] pair. Spring bounce=0 maps to a smooth ease-out — approximate
		// as a 0.6s ease-out so the transition feels natural without true spring math.
		const controls = animate(
			el,
			{ backgroundSize: [from, to] },
			{ duration: transition?.duration ?? 1, ease: 'easeOut' },
		);
		return () => controls.stop();
	});

	// Merged ref: attach both inView watcher and our inner node tracker.
	function attachRef(el: HTMLElement | null) {
		innerRef.value = el;
		inViewRef(el);
	}

	const bgPosition = track(() => getBackgroundPosition(dir.value));

	// Static style portions that don't change after mount.
	const staticStyle = track(
		() =>
			`background-image: linear-gradient(${highlightColor}, ${highlightColor}); ` +
			`background-repeat: no-repeat; ` +
			`background-position: ${bgPosition.value}; ` +
			`background-size: ${getBackgroundSize(false, dir.value)}; ` +
			`box-decoration-break: clone; ` +
			`-webkit-box-decoration-break: clone;`,
	);

	function handleMouseEnter(e: MouseEvent) {
		if (triggerType === 'hover') isHovered.value = true;
		onMouseEnter?.(e);
	}

	function handleMouseLeave(e: MouseEvent) {
		if (triggerType === 'hover') isHovered.value = false;
		onMouseLeave?.(e);
	}

	<>
	<span
		class={cn(className)}
		onMouseEnter={handleMouseEnter}
		onMouseLeave={handleMouseLeave}
		{...rest}
	>
		<span
			ref={attachRef}
			class="inline"
			style={staticStyle.value}
		>
			{children}
		</span>
	</span>
	</>
}
