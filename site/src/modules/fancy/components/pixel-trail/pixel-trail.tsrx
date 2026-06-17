import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Svelte 5 used `bind:this` to collect imperative `flash()` handles on each
// PixelDot child. Ripple has no component-ref mechanism, so we flip the data
// flow: the parent holds a `flashMap` (Map<index, version>) and increments a
// cell's version when the mouse hits it. Each PixelDot watches only its own
// version slot and self-triggers its `animate()` call whenever the version
// bumps — same behaviour, no imperative refs needed.

function PixelDot({
	index,
	size,
	fadeDuration,
	delay,
	flashMap,
	class: className,
}: any) @{
	let node = track<HTMLElement | null>(null);
	// Read the flash version for this cell. A bump means "fire".
	const version = track(() => flashMap.value.get(index) ?? 0);

	effect(() => {
		const el = node.value;
		if (!el || version.value === 0) return;

		// Snap to full opacity, then animate to 0. `delay` is in ms.
		animate(el, { opacity: 1 }, { duration: 0 });
		const ctrl = animate(el, { opacity: 0 }, { duration: fadeDuration / 1000, delay: delay / 1000 });
		return () => ctrl.stop();
	});

	<>
	<div
		ref={(el) => { node.value = el; }}
		class={cn('pointer-events-none', className)}
		style={`width:${size}px;height:${size}px;opacity:0;`}
	/>
	</>
}

export function PixelTrail({
	pixelSize = 20,
	fadeDuration = 500,
	delay = 0,
	class: className,
	pixelClassName,
}: any) @{
	let containerRef = track<HTMLElement | null>(null);
	// width/height measured by ResizeObserver — zero until client mounts.
	const width = track(0);
	const height = track(0);

	// flashMap: Map<cellIndex, version>. Incrementing version triggers the dot.
	const flashMap = track<Map<number, number>>(new Map());

	// Wire up ResizeObserver inside effect (client-only: ResizeObserver is not SSR-safe).
	effect(() => {
		const el = containerRef.value;
		if (!el) return;

		const update = () => {
			const rect = el.getBoundingClientRect();
			width.value = rect.width;
			height.value = rect.height;
		};

		const ro = new ResizeObserver(update);
		ro.observe(el);
		update();
		return () => ro.disconnect();
	});

	const columns = track(() => (width.value > 0 ? Math.ceil(width.value / pixelSize) : 0));
	const rows = track(() => (height.value > 0 ? Math.ceil(height.value / pixelSize) : 0));
	const rowIndices = track(() => Array.from({ length: rows.value }, (_, i) => i));
	const columnIndices = track(() => Array.from({ length: columns.value }, (_, i) => i));

	function getPixelIndex(col: number, row: number) {
		return row * columns.value + col;
	}

	function handleMouseMove(event: MouseEvent) {
		const el = containerRef.value;
		if (!el) return;
		const rect = el.getBoundingClientRect();
		const col = Math.floor((event.clientX - rect.left) / pixelSize);
		const row = Math.floor((event.clientY - rect.top) / pixelSize);
		if (col < 0 || col >= columns.value || row < 0 || row >= rows.value) return;

		const idx = getPixelIndex(col, row);
		// Bump the version for this cell so its PixelDot effect re-fires.
		const next = new Map(flashMap.value);
		next.set(idx, (next.get(idx) ?? 0) + 1);
		flashMap.value = next;
	}

	<>
	<div
		ref={(el) => { containerRef.value = el; }}
		role="presentation"
		class={cn('pointer-events-auto absolute inset-0 h-full w-full', className)}
		onMouseMove={handleMouseMove}
	>
		@for (const rowIndex of rowIndices.value; ) {
			<div class="flex">
				@for (const colIndex of columnIndices.value; ) {
					<PixelDot
						index={getPixelIndex(colIndex, rowIndex)}
						size={pixelSize}
						fadeDuration={fadeDuration}
						delay={delay}
						flashMap={flashMap}
						class={pixelClassName}
					/>
				}
			</div>
		}
	</div>
	</>
}
