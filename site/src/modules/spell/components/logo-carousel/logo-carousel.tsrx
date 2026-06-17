import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// CSS-class-driven animation: each item's animation state is expressed as a
// class name. We avoid writing tracked state inside derived computations by
// keeping all class logic as pure functions called from JSX.
//
// The Svelte source uses a typed Snippet<[T, number]> for per-item rendering.
// In Ripple we expose this as a `renderItem(item, index)` function prop —
// cleaner than overloading the `children` slot for a parameterised renderer.
export function LogoCarousel({
	items,
	renderItem,
	stagger = 0.14,
	count,
	class: className,
	duration = 600,
	interval = 2500,
	initialDelay = 500,
	...props
}: any) @{
	// groups is a pure derived — no window access, SSR-safe.
	const groups = track((): any[][] => {
		if (!items || items.length === 0) return [];
		const groupSize = count && count > 0 ? count : items.length;
		const result: any[][] = [];
		for (let i = 0; i < items.length; i += groupSize) {
			result.push(items.slice(i, i + groupSize));
		}
		return result;
	});

	const groupsLength = track(() => groups.value.length);
	const canLoop = track(() => groupsLength.value > 1);

	let index = track(0);
	let nextIndex = track(0);
	let animating = track(false);

	// Reset index/state whenever groupsLength changes (items/count prop change).
	effect(() => {
		index.value = 0;
		nextIndex.value = groupsLength.value > 1 ? 1 : 0;
		animating.value = false;
	});

	// Start the initial delay timer — window only touched inside effect (client-only).
	effect(() => {
		if (!canLoop.value) return;
		const id = window.setTimeout(() => {
			animating.value = true;
		}, initialDelay);
		return () => window.clearTimeout(id);
	});

	// Cycle groups on interval once animating is true.
	effect(() => {
		if (!animating.value || !canLoop.value) return;
		const id = window.setInterval(() => {
			const newIndex = (index.value + 1) % groupsLength.value;
			index.value = newIndex;
			nextIndex.value = (newIndex + 1) % groupsLength.value;
		}, interval);
		return () => window.clearInterval(id);
	});

	// itemIndex is accepted for API symmetry with the render loop but unused here
	function itemClass(groupIndex: number, _itemIndex: number): string {
		const isCurrent = groupIndex === index.value;
		const isNext = canLoop.value && animating.value && groupIndex === nextIndex.value;
		const isVisible = canLoop.value ? isCurrent || isNext : isCurrent;

		if (animating.value && isVisible && !isCurrent) return 'logo-carousel__item--enter';
		if (animating.value && isVisible && isCurrent) return 'logo-carousel__item--exit';
		if ((animating.value && !isVisible) || (!animating.value && !isCurrent)) return 'logo-carousel__item--hidden';
		return 'logo-carousel__item--static';
	}

	function groupPointerEvents(groupIndex: number): string {
		const isCurrent = groupIndex === index.value;
		const isNext = canLoop.value && animating.value && groupIndex === nextIndex.value;
		const isVisible = canLoop.value ? isCurrent || isNext : isCurrent;
		return isVisible ? 'auto' : 'none';
	}

	<>
	@if (groupsLength.value > 0) {
		<div class="grid w-full max-w-[720px] place-items-center" {...props}>
			@for (const group of groups.value; index groupIndex) {
				<div
					class={cn('flex w-full justify-center gap-10', className)}
					style={`grid-area: 1 / 1; pointer-events: ${groupPointerEvents(groupIndex)};`}
				>
					@for (const item of group; index itemIndex) {
						<div
							class={itemClass(groupIndex, itemIndex)}
							style={`animation-delay: ${itemIndex * stagger}s; animation-duration: ${duration}ms; animation-fill-mode: both; animation-timing-function: ease;`}
						>
							{renderItem(item, itemIndex)}
						</div>
					}
				</div>
			}
		</div>
	}

	<style>
		@keyframes logo-carousel-enter {
			0% { transform: translateY(40px); filter: blur(4px); opacity: 0; }
			100% { transform: translateY(0); filter: blur(0); opacity: 1; }
		}
		@keyframes logo-carousel-exit {
			0% { transform: translateY(0); filter: blur(0); opacity: 1; }
			100% { transform: translateY(-40px); filter: blur(4px); opacity: 0; }
		}
		.logo-carousel__item--enter { animation-name: logo-carousel-enter; }
		.logo-carousel__item--exit { animation-name: logo-carousel-exit; }
		.logo-carousel__item--hidden { opacity: 0; }
		.logo-carousel__item--static { opacity: 1; }
	</style>
	</>
}
