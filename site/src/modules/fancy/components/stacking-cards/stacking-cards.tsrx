import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// StackingCards tracks scroll progress to shrink earlier cards as later ones
// scroll into view, creating a depth-layered stacking effect.
//
// Scroll tracking modes:
//   scrollable=false (default): window scroll drives progress. The container
//     must be tall (e.g. height: 400vh) so the user scrolls through it.
//   scrollable=true: the container is its own scroll parent with overflow-y:auto.
//     In this mode an inner spacer div provides the scrollable height so that
//     sticky-positioned cards have room to animate. Set the container height
//     via the `style` prop and let the spacer handle the scroll range.
//
// StackingCardItem receives scrollProgress as an explicit prop because TSRX has
// no setContext/getContext equivalent of Svelte's context API. The original
// Svelte source passed a MotionValue through Svelte context; here the parent
// propagates progress via the `items` array instead.

const DEFAULT_SCALE_MULTIPLIER = 0.03;

// Mirrors the useTransform derivation from stacking-card-item.svelte exactly.
function computeCardScale(
	scrollProgress: number,
	index: number,
	totalCards: number,
	scaleMultiplier: number,
): number {
	const safeTotalCards = Math.max(totalCards, 1);
	// scaleTo: minimum scale this card reaches once all later cards stack on it.
	const scaleTo = 1 - (safeTotalCards - index) * scaleMultiplier;
	// rangeScaleStart: the scroll fraction at which this card begins to shrink.
	const rangeScaleStart = index * (1 / safeTotalCards);
	const clampedProgress = Math.min(1, Math.max(rangeScaleStart, scrollProgress));
	const normalizedProgress =
		rangeScaleStart === 1
			? Number(scrollProgress >= 1)
			: (clampedProgress - rangeScaleStart) / (1 - rangeScaleStart);
	return 1 + (scaleTo - 1) * normalizedProgress;
}

export type StackingCardItemData = {
	/** 0-based card index (defaults to array position). */
	index?: number;
	/** Overrides the computed `top` offset (`5 + index * 3 %`). */
	topPosition?: string;
	class?: string;
	children?: any;
};

// StackingCards — manages scroll-driven stacking for a set of cards.
//
// Pass `items`, an array of { children (JSX), index?, topPosition?, class? }.
// Set `scrollable` to true when you want this element to be the scroll parent
// (e.g. inside a fixed-height preview box). In that mode an inner spacer gives
// the cards room to animate; the outer div handles overflow-y:auto.
export function StackingCards({
	items,
	scaleMultiplier = DEFAULT_SCALE_MULTIPLIER,
	scrollable = false,
	class: className,
	style: styleAttribute,
	...rest
}: any) @{
	const root = track<HTMLElement | null>(null);
	const scrollYProgress = track(0);

	effect(() => {
		const el = root.value;
		if (!el) return;

		if (scrollable) {
			// Self-scroll: progress = scrollTop / (scrollHeight - clientHeight).
			function onSelfScroll() {
				const scrollRange = el!.scrollHeight - el!.clientHeight;
				scrollYProgress.value = scrollRange > 0 ? el!.scrollTop / scrollRange : 0;
			}
			el.addEventListener('scroll', onSelfScroll, { passive: true });
			onSelfScroll();
			return () => el.removeEventListener('scroll', onSelfScroll);
		} else {
			// Window scroll: progress 0→1 as element traverses the viewport
			// (element top at viewport top → element bottom at viewport bottom).
			function onWindowScroll() {
				const rect = el!.getBoundingClientRect();
				const viewportH = window.innerHeight;
				const total = rect.height - viewportH;
				if (total <= 0) {
					scrollYProgress.value = rect.top <= 0 ? 1 : 0;
					return;
				}
				scrollYProgress.value = Math.min(1, Math.max(0, -rect.top / total));
			}
			window.addEventListener('scroll', onWindowScroll, { passive: true });
			onWindowScroll();
			return () => window.removeEventListener('scroll', onWindowScroll);
		}
	});

	const totalCards = track(() => (Array.isArray(items) ? items.length : 0));

	<>
	<div
		ref={(el) => { root.value = el; }}
		class={cn(scrollable ? 'overflow-y-auto' : '', className)}
		style={styleAttribute}
		{...rest}
	>
		@if (scrollable) {
			<div class="relative">
				@for (const item of (items ?? []); index i) {
					<StackingCardItem
						index={item.index ?? i}
						topPosition={item.topPosition}
						class={item.class}
						scrollProgress={scrollYProgress.value}
						totalCards={totalCards.value}
						scaleMultiplier={scaleMultiplier}
					>
						{item.children}
					</StackingCardItem>
				}
				<div aria-hidden="true" style={`height: ${(totalCards.value) * 200}px;`} />
			</div>
		} @else {
			@for (const item of (items ?? []); index i) {
				<StackingCardItem
					index={item.index ?? i}
					topPosition={item.topPosition}
					class={item.class}
					scrollProgress={scrollYProgress.value}
					totalCards={totalCards.value}
					scaleMultiplier={scaleMultiplier}
				>
					{item.children}
				</StackingCardItem>
			}
		}
	</div>
	</>
}

// StackingCardItem — sticky wrapper that scales its card based on scroll
// progress. Use inside StackingCards or standalone with explicit props.
export function StackingCardItem({
	index,
	topPosition,
	scrollProgress = 0,
	totalCards = 1,
	scaleMultiplier = DEFAULT_SCALE_MULTIPLIER,
	class: className,
	children,
	...rest
}: any) @{
	const top = track(() => topPosition ?? `${5 + index * 3}%`);
	const scale = track(() =>
		computeCardScale(scrollProgress, index, totalCards, scaleMultiplier),
	);

	<>
	<div class={cn('sticky top-0', className)} {...rest}>
		<div
			class="relative origin-top"
			style={`top: ${top.value}; transform: scale(${scale.value}); transform-origin: top center;`}
		>
			{children}
		</div>
	</div>
	</>
}
