import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Dock + DockIcon are two cooperating components. In the Svelte source, the
// parent shared a MotionValue for mouseX through Svelte context so any
// DockIcon in the slot could subscribe. TSRX has no context API, so the
// design is flipped: Dock owns `items` data and renders DockIcon internally,
// passing mouseX as an explicit prop. This matches the stacking-cards
// precedent in this codebase.
//
// Spring: motion-sv's useSpring(stiffness:150, damping:12, mass:0.1) is
// approximated with a rAF loop inside an effect. The loop runs only on the
// client (inside effect) and is cleaned up on unmount.

const DEFAULT_SIZE = 40;
const DEFAULT_MAGNIFICATION = 60;
const DEFAULT_DISTANCE = 140;

// Minimal spring integrator: F = -k*x - c*v,  a = F/m.
// Returns a cleanup function. Calls `setValue` on every animation frame until
// the spring is at rest.
function springTo(
	getCurrent: () => number,
	target: number,
	{ stiffness = 150, damping = 12, mass = 0.1 } = {},
	setValue: (v: number) => void,
): () => void {
	let pos = getCurrent();
	let vel = 0;
	let raf = 0;
	let lastTime = performance.now();

	function step(now: number) {
		const dt = Math.min((now - lastTime) / 1000, 0.064); // cap at ~4 frames
		lastTime = now;
		const force = -stiffness * (pos - target) - damping * vel;
		const acc = force / mass;
		vel += acc * dt;
		pos += vel * dt;

		// At-rest heuristic from framer-motion.
		const isResting = Math.abs(vel) < 0.01 && Math.abs(pos - target) < 0.01;
		if (isResting) {
			setValue(target);
			return;
		}
		setValue(pos);
		raf = requestAnimationFrame(step);
	}

	raf = requestAnimationFrame(step);
	return () => cancelAnimationFrame(raf);
}

export type DockItemDef = {
	/** Rendered inside the icon wrapper. */
	icon: any;
	/** Accessible label (used as aria-label + optional visible tooltip). */
	label?: string;
	/** Optional href — renders an <a> instead of a <div>. */
	href?: string;
	class?: string;
};

// DockIcon is exported for advanced use: compose your own items array and drop
// it into Dock, or use DockIcon standalone if you supply mouseX yourself.
export function DockIcon({
	icon,
	label,
	href,
	mouseX,
	iconSize = DEFAULT_SIZE,
	iconMagnification = DEFAULT_MAGNIFICATION,
	disableMagnification = false,
	iconDistance = DEFAULT_DISTANCE,
	class: className,
}: any) @{
	const node = track<HTMLElement | null>(null);
	// `displaySize` is the spring-smoothed pixel dimension driven by mouse proximity.
	const displaySize = track(iconSize);

	// The whole magnification + spring loop must be client-only (accesses
	// getBoundingClientRect and rAF).
	effect(() => {
		const el = node.value;
		if (!el) return;

		let cancelSpring: (() => void) | undefined;

		function updateTarget() {
			const bounds = el!.getBoundingClientRect();
			const center = bounds.x + bounds.width / 2;
			const dist = mouseX.value - center;

			let target: number;
			if (disableMagnification || Math.abs(dist) >= iconDistance) {
				target = iconSize;
			} else {
				const progress = 1 - Math.abs(dist) / iconDistance;
				target = iconSize + (iconMagnification - iconSize) * progress;
			}

			if (cancelSpring) cancelSpring();
			cancelSpring = springTo(
				() => displaySize.value,
				target,
				{ stiffness: 150, damping: 12, mass: 0.1 },
				(v) => { displaySize.value = v; },
			);
		}

		// Re-run whenever mouseX changes. mouseX is a track() object, so reading
		// `.value` here registers it as a reactive dependency of this effect.
		mouseX.value;
		updateTarget();

		return () => { if (cancelSpring) cancelSpring(); };
	});

	const padding = track(() => Math.max(6, iconSize * 0.2));

	const wrapperStyle = track(
		() =>
			`width: ${displaySize.value}px; height: ${displaySize.value}px; padding: ${padding.value}px;`,
	);

	const sharedClass = cn(
		'flex aspect-square cursor-pointer items-center justify-center rounded-full transition-colors',
		disableMagnification && 'hover:bg-muted-foreground',
		className,
	);

	<>
	@if (href) {
		<a
			ref={(el: HTMLElement | null) => { node.value = el; }}
			aria-label={label}
			class={sharedClass}
			style={wrapperStyle.value}
			href={href}
		>
			<div class="flex h-full w-full items-center justify-center">
				{icon}
			</div>
		</a>
	} @else {
		<div
			ref={(el: HTMLElement | null) => { node.value = el; }}
			aria-label={label}
			class={sharedClass}
			style={wrapperStyle.value}
		>
			<div class="flex h-full w-full items-center justify-center">
				{icon}
			</div>
		</div>
	}
	</>
}

export function Dock({
	items = [],
	iconSize = DEFAULT_SIZE,
	iconMagnification = DEFAULT_MAGNIFICATION,
	disableMagnification = false,
	iconDistance = DEFAULT_DISTANCE,
	direction = 'middle',
	class: className,
}: any) @{
	// mouseX is a track object shared by reference with every DockIcon child.
	// Infinity means "no hover" — icons return to their rest size.
	const mouseX = track(Infinity);

	function handleMouseMove(e: MouseEvent) {
		mouseX.value = e.pageX;
	}
	function handleMouseLeave() {
		mouseX.value = Infinity;
	}

	const alignClass = track(() => {
		if (direction === 'top') return 'items-start';
		if (direction === 'bottom') return 'items-end';
		return 'items-center';
	});

	<>
	<div
		onMouseMove={handleMouseMove}
		onMouseLeave={handleMouseLeave}
		class={cn(
			'mx-auto mt-8 flex h-14 w-max justify-center gap-2 rounded-2xl border p-2 backdrop-blur-md supports-backdrop-blur:bg-white/10 dark:supports-backdrop-blur:bg-black/10',
			alignClass.value,
			className,
		)}
	>
		@for (const item of items; index i) {
			<DockIcon
				icon={item.icon}
				label={item.label}
				href={item.href}
				class={item.class}
				mouseX={mouseX}
				iconSize={iconSize}
				iconMagnification={iconMagnification}
				disableMagnification={disableMagnification}
				iconDistance={iconDistance}
			/>
		}
	</div>
	</>
}
