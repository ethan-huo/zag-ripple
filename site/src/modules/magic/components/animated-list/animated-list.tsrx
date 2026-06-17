import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Progressively prepends items from a list on a timer, animating each new item
// in with a spring-like entrance. No AnimatePresence equivalent exists in the
// motion layer, so entrance-only animation is used; layout reflow is left to the
// browser (visually sufficient because items are only ever prepended, never
// reordered or removed mid-list).
//
// Items are expected to carry a stable `id` field (matching the Svelte source's
// `{#each … as item (item.id)}`). Without `id`, diffing degrades to value
// stringification and re-mounts may occur on each prepend cycle.
export function AnimatedList({
	items = [],
	delay = 1000,
	class: className,
	// renderItem replaces the Svelte snippet/children render-prop pattern.
	// Ripple children cannot be called as a function; use an explicit prop instead.
	renderItem,
}: any) @{
	// itemsToShow grows from [items[0]] to the full list, prepending each new item.
	const itemsToShow = track<any[]>([]);

	// Keys waiting for their entrance animation. Populated before the render that
	// inserts the item; consumed in the ref callback so double-fires are blocked.
	const pendingAnimate = new Set<string>();

	// Stable string key per item. Uses `id` when present; otherwise serialises the
	// value (fine for strings/numbers, degrades for complex objects without id).
	function stableKey(item: any): string {
		if (item != null && typeof item === 'object' && 'id' in item) {
			return String(item.id);
		}
		return String(item);
	}

	effect(() => {
		if (!items || items.length === 0) return;
		// Seed with the first item immediately.
		const firstKey = stableKey(items[0]);
		pendingAnimate.add(firstKey);
		itemsToShow.value = [items[0]];

		let currentIndex = 0;
		const id = setInterval(() => {
			if (currentIndex < items.length - 1) {
				currentIndex++;
				const newItem = items[currentIndex];
				pendingAnimate.add(stableKey(newItem));
				// Prepend so newest appears at top, matching the source behaviour.
				itemsToShow.value = [newItem, ...itemsToShow.value];
			}
		}, delay);

		return () => clearInterval(id);
	});

	// Called from the ref callback once the node is in the DOM. Uses a spring-
	// approximating cubic-bezier that overshoots slightly, matching the source's
	// `spring(stiffness:500, damping:30)` entrance feel.
	function animateIn(el: HTMLElement, key: string) {
		if (!pendingAnimate.has(key)) return;
		pendingAnimate.delete(key);
		animate(
			el,
			{ opacity: [0, 1], scale: [0, 1], y: [-8, 0] },
			{ duration: 0.35, ease: [0.34, 1.56, 0.64, 1] },
		);
	}

	<>
	<div class={cn('flex flex-col items-center gap-4', className)}>
		@for (const item of itemsToShow.value; key stableKey(item)) {
			const key = stableKey(item);
			<div
				class="mx-auto w-full"
				ref={(el) => {
					if (!el) return;
					animateIn(el, key);
				}}
			>
				{renderItem ? renderItem(item) : null}
			</div>
		}
	</div>
	</>
}
