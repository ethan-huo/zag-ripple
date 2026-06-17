import { effect, track } from 'ripple';
import { animate, useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Wraps children in a div that fades in with a blur + directional slide when it
// enters the viewport. The outer ref-div feeds useInView (client-only via effect);
// the inner animated div is the motion target. Keeping them separate lets the
// ref attachment be SSR-safe while the animation target stays a stable node.
export function BlurFade({
	children,
	class: className,
	variant,
	duration = 0.4,
	delay = 0,
	offset = 6,
	direction = 'down',
	triggerOnView = true,
	inViewMargin = '-50px',
	blur = '6px',
	once = true,
}: any) @{
	const containerRef = track<HTMLElement | null>(null);
	const animatedRef = track<HTMLElement | null>(null);

	// useInView is effect-guarded internally — SSR-safe to call at render.
	const inView = useInView({ once, amount: 0.1, margin: inViewMargin });

	const shouldAnimate = track(() =>
		triggerOnView ? inView.visible.value : true
	);

	// Derive "hidden" and "visible" keyframe shapes from direction + blur + offset.
	// variant prop can supply custom shapes; the hidden/visible labels are resolved
	// to concrete style values here so we avoid a framer-motion Variants lookup.
	effect(() => {
		const el = animatedRef.value;
		if (!el) return;

		const isHorizontal = direction === 'left' || direction === 'right';
		// For "down" and "right" the element starts *above/left* of its rest
		// position, mirroring the Svelte source's offset sign convention.
		const sign = direction === 'down' || direction === 'right' ? -1 : 1;

		const hidden = variant?.hidden ?? {
			opacity: 0,
			filter: `blur(${blur})`,
			...(isHorizontal ? { x: sign * offset } : { y: sign * offset }),
		};
		const visible = variant?.visible ?? {
			opacity: 1,
			filter: 'blur(0px)',
			...(isHorizontal ? { x: 0 } : { y: 0 }),
		};

		// Snap to hidden state immediately so the element never flashes at rest
		// before the entrance animation fires or the viewport threshold is met.
		animate(el, hidden, { duration: 0 });

		if (!shouldAnimate.value) return;

		// Build [from, to] pairs so motion's engine uses hidden as the start rather
		// than reading the live computed style (which may already be the end state).
		const keyframes: Record<string, unknown> = {};
		for (const key in visible) {
			const from = (hidden as any)[key];
			keyframes[key] = from !== undefined ? [from, (visible as any)[key]] : (visible as any)[key];
		}

		const controls = animate(el, keyframes, {
			delay: 0.04 + delay,
			duration,
			ease: 'easeOut',
		});
		return () => controls.stop();
	});

	<>
	<div
		ref={(el: HTMLElement | null) => {
			containerRef.value = el;
			if (triggerOnView) inView.ref(el);
		}}
	>
		<div
			ref={(el: HTMLElement | null) => {
				animatedRef.value = el;
			}}
			class={cn(className)}
		>
			{children}
		</div>
	</div>
	</>
}
