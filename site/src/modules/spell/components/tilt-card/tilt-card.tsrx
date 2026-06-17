import { track } from 'ripple';
import { cn } from '@/lib/utils';

// Pointer-reactive 3D tilt with an optional spotlight that follows the cursor.
// `evade` tilts away from the pointer, `gravitate` tilts toward it.
export function TiltCard({
	tiltLimit = 15,
	scale = 1.05,
	perspective = 1200,
	effect: tiltEffect = 'evade',
	spotlight = true,
	children,
	class: className,
	style,
	...restProps
}: any) @{
	let isHovered = track(false);
	let pointerX = track(0.5);
	let pointerY = track(0.5);

	const clamp = (value: number, min: number, max: number) =>
		Math.min(Math.max(value, min), max);

	const buildTransform = (rotateX: number, rotateY: number, scaleValue: number) =>
		`perspective(${perspective}px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(${scaleValue}, ${scaleValue}, ${scaleValue})`;

	function handlePointerMove(event: PointerEvent) {
		const el = event.currentTarget as HTMLElement | null;
		if (!el) return;
		const rect = el.getBoundingClientRect();
		if (rect.width === 0 || rect.height === 0) return;
		pointerX.value = clamp((event.clientX - rect.left) / rect.width, 0, 1);
		pointerY.value = clamp((event.clientY - rect.top) / rect.height, 0, 1);
	}

	const transform = track(() => {
		if (!isHovered.value) return buildTransform(0, 0, 1);
		const direction = tiltEffect === 'evade' ? -1 : 1;
		const rotateX = (pointerY.value - 0.5) * (tiltLimit * 2) * direction;
		const rotateY = (pointerX.value - 0.5) * -(tiltLimit * 2) * direction;
		return buildTransform(rotateX, rotateY, scale);
	});

	const rootStyle = track(
		() =>
			`transform: ${transform.value}; transition: transform 0.2s ease-out; transform-style: preserve-3d; ${style ?? ''}`,
	);

	<>
	<div
		class={cn('relative overflow-hidden will-change-transform', className)}
		style={rootStyle.value}
		onPointerEnter={() => (isHovered.value = true)}
		onPointerMove={handlePointerMove}
		onPointerLeave={() => (isHovered.value = false)}
		{...restProps}
	>
		{children}

		@if (spotlight) {
			<div
				class="pointer-events-none absolute inset-0 z-10 overflow-hidden"
				style={`opacity: ${isHovered.value ? 1 : 0}; transition: opacity 0.3s;`}
			>
				<div
					class="absolute h-[200%] w-[200%] rounded-full opacity-100 dark:opacity-60"
					style={`left: ${pointerX.value * 100}%; top: ${pointerY.value * 100}%; transform: translate(-50%, -50%); transition: left 0.2s ease-out, top 0.2s ease-out; background: radial-gradient(circle, rgba(255,255,255,0.15) 0%, transparent 40%);`}
				/>
			</div>
		}
	</div>
	</>
}
