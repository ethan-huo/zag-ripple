import { track } from 'ripple';
import { cn } from '@/lib/utils';

// The lens overlay is a copy of `children` masked to a circle and scaled up.
// AnimatePresence (motion-sv) is not available in Ripple; instead we manage
// enter/exit with CSS `opacity`/`scale` transitions on a persistent div whose
// visibility is driven by `isHovering` or `isStatic`/`defaultPosition` modes.
// The overlay is always in the DOM (no conditional unmount) so the CSS
// transition can animate both in and out — the source used AnimatePresence
// for the same reason.
export function Lens({
	children,
	zoomFactor = 1.3,
	lensSize = 170,
	isStatic = false,
	position = { x: 0, y: 0 },
	defaultPosition,
	duration = 0.1,
	lensColor = 'black',
	ariaLabel = 'Zoom Area',
	class: className,
}: any) @{
	let isHovering = track(false);
	let mouseX = track(0);
	let mouseY = track(0);
	let containerRef = track<HTMLElement | null>(null);

	// currentPosition: if static → use prop.position; if not hovering and a
	// defaultPosition is set → show there; otherwise follow mouse.
	const currentPosition = track(() => {
		if (isStatic) return position;
		if (defaultPosition && !isHovering.value) return defaultPosition;
		return { x: mouseX.value, y: mouseY.value };
	});

	// Whether the lens overlay should be visible (opaque / full scale).
	const lensVisible = track(() => isStatic || defaultPosition != null || isHovering.value);

	const maskImage = track(() => {
		const { x, y } = currentPosition.value;
		return `radial-gradient(circle ${lensSize / 2}px at ${x}px ${y}px, ${lensColor} 100%, transparent 100%)`;
	});

	const transformOrigin = track(() => {
		const { x, y } = currentPosition.value;
		return `${x}px ${y}px`;
	});

	// zoomStyle applied to the inner scaled copy.
	const zoomStyle = track(
		() => `transform: scale(${zoomFactor}); transform-origin: ${transformOrigin.value};`,
	);

	// Overlay element style: mask + transition for enter/exit animation.
	// The `transition` prop mirrors the source's `duration` (in seconds).
	const overlayStyle = track(() => {
		const visible = lensVisible.value;
		return [
			`mask-image: ${maskImage.value}`,
			`-webkit-mask-image: ${maskImage.value}`,
			`transform-origin: ${transformOrigin.value}`,
			`z-index: 50`,
			// CSS transition replicates the motion-sv enter (0.58→1 scale, 0→1 opacity)
			// and exit (1→0.8 scale, 1→0 opacity) without needing AnimatePresence.
			`opacity: ${visible ? 1 : 0}`,
			`transform: scale(${visible ? 1 : 0.58})`,
			`transition: opacity ${duration}s ease, transform ${duration}s ease`,
		].join('; ');
	});

	function handleMouseMove(e: MouseEvent) {
		const el = containerRef.value;
		if (!el) return;
		const rect = el.getBoundingClientRect();
		mouseX.value = e.clientX - rect.left;
		mouseY.value = e.clientY - rect.top;
	}

	function handleKeyDown(e: KeyboardEvent) {
		if (e.key === 'Escape') isHovering.value = false;
	}

	<>
	<div
		ref={(el) => { containerRef.value = el; }}
		class={cn('relative z-20 overflow-hidden rounded-xl', className)}
		onMouseEnter={() => { isHovering.value = true; }}
		onMouseLeave={() => { isHovering.value = false; }}
		onMouseMove={handleMouseMove}
		onKeyDown={handleKeyDown}
		role="region"
		aria-label={ariaLabel}
		tabIndex={0}
	>
		{children}
		<div
			class="absolute inset-0 overflow-hidden"
			style={overlayStyle.value}
		>
			<div class="absolute inset-0" style={zoomStyle.value}>
				{children}
			</div>
		</div>
	</div>
	</>
}
