import { effect, track } from 'ripple';
import { motionValue, springValue, scroll } from 'motion';
import { cn } from '@/lib/utils';

// Scroll-driven text swap: two stacked spans (top and incoming) slide via a
// spring-smoothed scroll-progress value. The root element acts as the scroll
// target so progress goes 0→1 as it travels from the viewport top to the
// viewport bottom — matching the original motion-sv useScroll/useSpring/useTransform chain.

export function ScrollAndSwap({
	text,
	as: Tag = 'span',
	scrollContainer = null,
	offset = ['0 0', '0 1'],
	springConfig = { stiffness: 200, damping: 30 },
	class: className,
	children,
	...props
}: any) @{
	// root holds the element reference used both as scroll target and tag container
	const rootRef = track<HTMLElement | null>(null);
	const topSpanRef = track<HTMLSpanElement | null>(null);
	const bottomSpanRef = track<HTMLSpanElement | null>(null);
	const probeRef = track<HTMLSpanElement | null>(null);

	// Track the scrollContainer prop so the effect re-runs if the caller provides
	// the container after their own ref mounts (common in preview contexts).
	const scrollContainerRef = track<HTMLElement | null>(scrollContainer ?? null);

	// slottedText is read from the invisible probe span when text prop is absent
	const slottedText = track('');

	const resolvedText = track(() =>
		text !== undefined ? String(text) : slottedText.value
	);

	// Keep scrollContainerRef in sync if the prop changes (e.g. deferred ref resolution)
	effect(() => {
		scrollContainerRef.value = scrollContainer ?? null;
	});

	effect(() => {
		const root = rootRef.value;
		const topSpan = topSpanRef.value;
		const bottomSpan = bottomSpanRef.value;
		if (!root || !topSpan || !bottomSpan) return;

		// Raw scroll progress (0–1)
		const rawProgress = motionValue(0);
		// Spring-smoothed progress that trails the raw value
		const springProgress = springValue(rawProgress, springConfig);

		// Derive CSS top for each span and push to DOM directly — avoids
		// reactive re-renders on every animation frame.
		const unsubSpring = springProgress.on('change', (p: number) => {
			// First span: slides from 0% → -100% (exits upward)
			topSpan.style.top = `${p * -100}%`;
			// Second span: slides from 100% → 0% (enters from below)
			bottomSpan.style.top = `${100 - p * 100}%`;
		});

		// container: null → falls back to document.scrollingElement inside motion's scroll()
		const container = scrollContainerRef.value;

		// Attach scroll tracking; returns a cleanup function
		const stopScroll = scroll(
			(progress: number) => {
				rawProgress.set(progress);
			},
			{
				container: container ?? undefined,
				target: root,
				offset: offset as any,
			},
		);

		return () => {
			unsubSpring();
			stopScroll();
		};
	});

	// When text prop is absent, observe the probe span for text-content changes
	effect(() => {
		if (text !== undefined) {
			slottedText.value = '';
			return;
		}
		const probe = probeRef.value;
		if (!probe) return;

		const sync = () => {
			slottedText.value = probe.textContent ?? '';
		};
		sync();

		const observer = new MutationObserver(sync);
		observer.observe(probe, { childList: true, characterData: true, subtree: true });
		return () => observer.disconnect();
	});

	<>
	<{Tag}
		ref={(el: HTMLElement | null) => { rootRef.value = el; }}
		class={cn(
			'relative inline-flex items-center justify-center overflow-hidden p-0',
			className,
		)}
		{...props}
	>
		{/* Spacer — holds the element's intrinsic dimensions without being visible */}
		<span class="relative whitespace-pre-wrap text-transparent">{resolvedText.value}</span>

		{/* Top span — visible at rest, slides out upward as element scrolls down */}
		<span
			ref={(el: HTMLSpanElement | null) => { topSpanRef.value = el; }}
			class="absolute whitespace-pre-wrap"
			style={{ top: '0%' }}
			aria-hidden="true"
		>
			{resolvedText.value}
		</span>

		{/* Bottom span — starts below, slides in as element scrolls down */}
		<span
			ref={(el: HTMLSpanElement | null) => { bottomSpanRef.value = el; }}
			class="absolute whitespace-pre-wrap"
			style={{ top: '100%' }}
			aria-hidden="true"
		>
			{resolvedText.value}
		</span>

		{/* Invisible probe to extract text content when children are used instead of text prop */}
		@if (text === undefined) {
			<span
				ref={(el: HTMLSpanElement | null) => { probeRef.value = el; }}
				aria-hidden="true"
				class="pointer-events-none absolute whitespace-pre-wrap opacity-0"
			>
				{children}
			</span>
		}
	</{Tag}>
	</>
}
