import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// The clip-path trick: two identical sets of tab buttons are stacked. The
// bottom layer uses muted-foreground text; the top layer uses primary bg +
// primary-foreground text and is clipped to only show the active tab region.
// The clip-path is updated imperatively via DOM measurements so we need
// ResizeObserver inside an effect (SSR-safe).
export function AnimatedTabs({
	tabs = [],
	value,
	onChange,
	class: className,
}: any) @{
	// DOM refs for the clip-path overlay container and its inner track.
	let containerRef = track(null);
	let trackRef = track(null);
	// Each button in the bottom (base) layer — populated by ref callbacks in @for.
	let buttonRefs = track([]);

	// Internal selection state for standalone (uncontrolled) use.
	// When `value` prop is provided the caller controls selection externally.
	let internalValue = track(undefined);

	// Resolved active tab: external `value` prop wins, then internal, then first tab.
	const active = track(() => {
		const v = value ?? internalValue.value;
		if (!v) return tabs[0] ?? '';
		return tabs.includes(v) ? v : (tabs[0] ?? '');
	});

	function selectTab(tab: any) {
		internalValue.value = tab;
		if (onChange) onChange(tab);
	}

	function updateClipPath() {
		const container = containerRef.value;
		const tr = trackRef.value;
		const btns = buttonRefs.value;

		if (!container || !tr || tr.offsetWidth === 0) return;

		const activeIndex = tabs.indexOf(active.value);
		const activeBtn = btns[activeIndex];
		if (!activeBtn) return;

		const clipLeft = activeBtn.offsetLeft;
		const clipRight = clipLeft + activeBtn.offsetWidth;
		const leftInset = (clipLeft / tr.offsetWidth) * 100;
		const rightInset = 100 - (clipRight / tr.offsetWidth) * 100;

		container.style.clipPath = `inset(0 ${rightInset.toFixed(3)}% 0 ${leftInset.toFixed(3)}% round 17px)`;
	}

	// Re-run clip-path update whenever active tab changes.
	effect(() => {
		// Reading active.value creates a reactive dependency.
		active.value;
		updateClipPath();
	});

	// Attach ResizeObserver to the track element on mount; also do an initial
	// clip-path update once the DOM is available.
	effect(() => {
		const tr = trackRef.value;
		if (!tr) return;

		// First paint — compute clip before first frame.
		updateClipPath();

		const ro = new ResizeObserver(() => updateClipPath());
		ro.observe(tr);
		return () => ro.disconnect();
	});

	<>
	<div class={cn('relative mx-auto flex w-fit flex-col items-center rounded-full', className)}>
		{/* Overlay layer: clipped to active tab region, shows primary colors */}
		<div
			ref={(el) => { containerRef.value = el; }}
			aria-hidden="true"
			class="pointer-events-none absolute z-10 w-full overflow-hidden [clip-path:inset(0_75%_0_0_round_17px)] [transition:clip-path_0.25s_ease]"
		>
			<div class="bg-primary relative flex w-full justify-center">
				@for (const tab of tabs; ) {
					<button
						type="button"
						class="text-primary-foreground flex h-8 items-center rounded-full p-3 text-sm/5.5 font-medium whitespace-nowrap max-sm:last:hidden"
						tabIndex={-1}
					>
						{tab}
					</button>
				}
			</div>
		</div>

		{/* Base layer: all tabs visible, muted color, clickable */}
		<div
			ref={(el) => { trackRef.value = el; }}
			class="relative flex w-full justify-center"
		>
			@for (const tab of tabs; index i) {
				<button
					ref={(el) => {
						const arr = [...(buttonRefs.value ?? [])];
						arr[i] = el;
						buttonRefs.value = arr;
					}}
					type="button"
					class="text-muted-foreground flex h-8 items-center rounded-full p-3 text-sm/5.5 font-medium whitespace-nowrap transition-colors focus-visible:ring-2 focus-visible:outline-none max-sm:last:hidden"
					aria-pressed={active.value === tab}
					data-state={active.value === tab ? 'active' : 'inactive'}
					onClick={() => selectTab(tab)}
				>
					{tab}
				</button>
			}
		</div>
	</div>
	</>
}
