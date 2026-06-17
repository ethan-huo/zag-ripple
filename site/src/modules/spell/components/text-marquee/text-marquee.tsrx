import { track } from 'ripple';
import { cn } from '@/lib/utils';

// Vertical slot-machine ticker: each item has its own CSS animation with a
// staggered delay so items scroll through a fixed-height viewport one-by-one.
// The viewport mask fades edges; only pure CSS runs — fully SSR-safe.
//
// The Svelte source uses a typed Snippet<[T, number]> for per-item rendering.
// In Ripple we expose this as a `renderItem(item, index)` function prop —
// same pattern as logo-carousel; cleaner than parameterising the children slot.
export function TextMarquee({
	items = [],
	renderItem,
	prefix,
	class: className,
	style: styleAttribute,
	speed = 1,
	height = 200,
	itemHeight = 40,
	...props
}: any) @{
	const count = track(() => (items as any[]).length);
	const safeSpeed = track(() => Math.max(speed, 0.01));
	const safeHeight = track(() => Math.max(height, 0));
	const safeItemHeight = track(() => Math.max(itemHeight, 1));

	const rootStyle = track(() => styleAttribute ? String(styleAttribute) : '');
	const viewportStyle = track(() => `height: ${safeHeight.value}px;`);
	const trackStyle = track(
		() =>
			`--spell-text-marquee-count: ${count.value}; --spell-text-marquee-speed: ${safeSpeed.value}; --spell-text-marquee-item-height: ${safeItemHeight.value}px;`,
	);

	<>
	<div {...props} class={cn('spell-text-marquee relative flex', className)} style={rootStyle.value}>
		<div class="spell-text-marquee__content relative flex h-min w-min flex-row items-center gap-1 overflow-hidden">
			@if (prefix) {
				<div class="spell-text-marquee__prefix relative size-auto whitespace-pre">
					{prefix}
				</div>
			}

			@if (count.value > 0) {
				<div
					class="spell-text-marquee__viewport relative w-auto overflow-hidden opacity-100"
					style={viewportStyle.value}
				>
					<div class="spell-text-marquee__track relative h-full" style={trackStyle.value}>
						@for (const item of items as any[]; index i) {
							<div
								class="spell-text-marquee__item flex items-center"
								style={`--spell-text-marquee-index: ${i};`}
							>
								{renderItem ? renderItem(item, i) : item}
							</div>
						}
					</div>
				</div>
			}
		</div>
	</div>

	<style>
		@keyframes spell-text-marquee-slide-vertical {
			to {
				transform: translateY(var(--spell-text-marquee-destination));
			}
		}

		.spell-text-marquee__viewport {
			mask-image: linear-gradient(
				rgba(0, 0, 0, 0) 0%,
				rgb(0, 0, 0) 43.6902%,
				rgba(0, 0, 0, 0) 100%
			);
			-webkit-mask-image: linear-gradient(
				rgba(0, 0, 0, 0) 0%,
				rgb(0, 0, 0) 43.6902%,
				rgba(0, 0, 0, 0) 100%
			);
		}

		.spell-text-marquee__item {
			--spell-text-marquee-origin: calc(
				(var(--spell-text-marquee-count) - var(--spell-text-marquee-index)) * 100%
			);
			--spell-text-marquee-destination: calc(
				(var(--spell-text-marquee-index) + 1) * -100%
			);
			--spell-text-marquee-duration: calc(
				var(--spell-text-marquee-speed) * var(--spell-text-marquee-count) * 1s
			);
			--spell-text-marquee-delay: calc(
				(var(--spell-text-marquee-duration) / var(--spell-text-marquee-count)) *
					var(--spell-text-marquee-index) - var(--spell-text-marquee-duration)
			);

			height: var(--spell-text-marquee-item-height);
			transform: translateY(var(--spell-text-marquee-origin));
			animation: spell-text-marquee-slide-vertical var(--spell-text-marquee-duration)
				var(--spell-text-marquee-delay) infinite linear;
			will-change: transform;
		}
	</style>
	</>
}
