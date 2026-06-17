import { track } from 'ripple';
import { cn } from '@/lib/utils';

// useMotionTemplate + useMotionValue from motion-sv are framer-motion reactive
// stores — here we replace them with plain track() values and derive the
// gradient strings inline (no motion engine needed; they're just CSS strings
// recomputed on pointer move).
export function MagicCard({
	children,
	class: className,
	gradientSize = 200,
	gradientColor = '#262626',
	gradientOpacity = 0.8,
	gradientFrom = '#9E7AFF',
	gradientTo = '#FE8BBB',
}: any) @{
	// Start off-screen so the gradient doesn't flash at (0,0) before the first
	// pointer event arrives.
	let mouseX = track(-gradientSize as number);
	let mouseY = track(-gradientSize as number);

	const reset = () => {
		mouseX.value = -gradientSize;
		mouseY.value = -gradientSize;
	};

	const handlePointerMove = (e: PointerEvent) => {
		const target = e.currentTarget as HTMLElement;
		const rect = target.getBoundingClientRect();
		mouseX.value = e.clientX - rect.left;
		mouseY.value = e.clientY - rect.top;
	};

	const borderGradient = track(
		() =>
			`radial-gradient(${gradientSize}px circle at ${mouseX.value}px ${mouseY.value}px, ${gradientFrom}, ${gradientTo}, var(--border) 100%)`,
	);

	const overlayGradient = track(
		() =>
			`radial-gradient(${gradientSize}px circle at ${mouseX.value}px ${mouseY.value}px, ${gradientColor}, transparent 100%)`,
	);

	<>
	<div
		class={cn('group relative rounded-[inherit]', className)}
		onPointerMove={handlePointerMove}
		onPointerLeave={reset}
		onPointerEnter={reset}
		role="region"
	>
		{/* Border gradient layer — lights up on hover */}
		<div
			class="bg-border pointer-events-none absolute inset-0 rounded-[inherit] duration-300 group-hover:opacity-100"
			style={`background: ${borderGradient.value};`}
		/>
		{/* Solid background sits between border and overlay so content isn't on glass */}
		<div class="bg-background absolute inset-px rounded-[inherit]" />
		{/* Overlay gradient — adds the color wash on hover */}
		<div
			class="pointer-events-none absolute inset-px rounded-[inherit] opacity-0 transition-opacity duration-300 group-hover:opacity-100"
			style={`background: ${overlayGradient.value}; opacity: ${gradientOpacity};`}
		/>
		{/* Content sits on top of all gradient layers */}
		<div class="relative">
			{children}
		</div>
	</div>
	</>
}
