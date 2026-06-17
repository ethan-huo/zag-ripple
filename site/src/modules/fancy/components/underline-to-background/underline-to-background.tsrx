import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Hover fills a background bar from underline-height to 100% behind the text,
// while the text color transitions to targetTextColor. We drive the animation
// with animate() callbacks rather than motion-sv's whileHover variants because
// Ripple has no AnimationPresence / variant propagation primitive — pointer
// events give us explicit control over enter and exit timelines.
export function UnderlineToBackground({
	children,
	class: className,
	targetTextColor = '#fef',
	underlineHeightRatio = 0.1,
	underlinePaddingRatio = 0.01,
	// Spring-like transition mirroring the source defaults (damping 30, stiffness 300).
	// motion/dom doesn't accept spring params directly, so we map to a fast ease.
	duration = 0.25,
	ease = 'easeOut',
	...props
}: any) @{
	let wrapNode = track<HTMLElement | null>(null);
	let bgNode = track<HTMLElement | null>(null);
	let textNode = track<HTMLElement | null>(null);

	// Underline dimensions in CSS custom properties — set imperatively once we
	// know the computed font-size (client-only; SSR renders 0px fallback).
	const underlineHeight = track('0px');
	const underlineBottom = track('0px');
	// The natural text color is captured from the rendered element on the client.
	const baseColor = track('currentColor');

	function measure(el: HTMLElement) {
		const fs = parseFloat(getComputedStyle(el).fontSize);
		if (Number.isNaN(fs)) return;
		baseColor.value = getComputedStyle(el).color;
		underlineHeight.value = `${fs * underlineHeightRatio}px`;
		underlineBottom.value = `${-(fs * underlinePaddingRatio)}px`;
	}

	// ResizeObserver keeps dimensions in sync with font-size changes (client-only).
	effect(() => {
		const el = wrapNode.value;
		if (!el) return;
		measure(el);
		const ro = new ResizeObserver(() => measure(el));
		ro.observe(el);
		return () => ro.disconnect();
	});

	// Re-measure whenever ratios change (guards against prop drift after mount).
	effect(() => {
		// Track both ratios as dependencies.
		void underlineHeightRatio;
		void underlinePaddingRatio;
		const el = wrapNode.value;
		if (el) measure(el);
	});

	function handleEnter() {
		const bg = bgNode.value;
		const txt = textNode.value;
		if (!bg || !txt) return;
		animate(bg, { height: ['var(--ul-h)', '100%'] }, { duration, ease });
		animate(txt, { color: [baseColor.value, targetTextColor] }, { duration, ease });
	}

	function handleLeave() {
		const bg = bgNode.value;
		const txt = textNode.value;
		if (!bg || !txt) return;
		animate(bg, { height: ['100%', 'var(--ul-h)'] }, { duration, ease });
		animate(txt, { color: [targetTextColor, baseColor.value] }, { duration, ease });
	}

	<>
	<span
		ref={(el) => { wrapNode.value = el; }}
		class={cn('relative inline-block cursor-pointer', className)}
		style={`--ul-h: ${underlineHeight.value}; --ul-pad: ${underlineBottom.value};`}
		onMouseEnter={handleEnter}
		onMouseLeave={handleLeave}
		{...props}
	>
		{/* Background fill bar — starts as an underline, expands to full height on hover */}
		<span
			ref={(el) => { bgNode.value = el; }}
			class="pointer-events-none absolute inset-x-0 bottom-[--ul-pad] z-0 will-change-[height]"
			style={`height: var(--ul-h, 0px); background-color: ${baseColor.value};`}
			aria-hidden="true"
		/>
		{/* Text sits above the bar and its color transitions on hover */}
		<span
			ref={(el) => { textNode.value = el; }}
			class="relative z-10 inline-block will-change-[color]"
		>
			{children}
		</span>
	</span>
	</>
}
