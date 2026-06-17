import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Each ray's random parameters are generated client-only (inside effect) to
// avoid SSR/hydration mismatch — Math.random() at render-time would produce
// different values on server vs client, causing a flicker.
// Animation is pure CSS: one shared @keyframes swings rotation and fades
// opacity; per-ray CSS vars supply the individualized timing and geometry.
export function LightRays({
	class: className,
	count = 7,
	color = 'rgba(160, 210, 255, 0.2)',
	blur = 36,
	speed = 14,
	length = '70vh',
	style,
	...rest
}: any) @{
	type RayData = {
		id: string;
		left: number;
		rotate: number;
		width: number;
		swing: number;
		delay: number;
		duration: number;
		intensity: number;
	};

	const rays = track<RayData[]>([]);

	// Runs only on the client — all Math.random() calls live here so the server
	// emits an empty list and the client populates it after hydration.
	effect(() => {
		const cycle = Math.max(speed, 0.1);
		const n = count > 0 ? count : 0;
		rays.value = Array.from({ length: n }, (_, i) => {
			const left = 8 + Math.random() * 84;
			const rotate = -28 + Math.random() * 56;
			const width = 160 + Math.random() * 160;
			const swing = 0.8 + Math.random() * 1.8;
			const delay = Math.random() * cycle;
			const duration = cycle * (0.75 + Math.random() * 0.5);
			const intensity = 0.6 + Math.random() * 0.5;
			return {
				id: `${i}-${Math.round(left * 10)}`,
				left,
				rotate,
				width,
				swing,
				delay,
				duration,
				intensity,
			};
		});
	});

	const containerStyle = [
		`--lr-color: ${color}`,
		`--lr-blur: ${blur}px`,
		`--lr-length: ${length}`,
		style || '',
	]
		.filter(Boolean)
		.join('; ');

	<>
	<div
		class={cn(
			'pointer-events-none absolute inset-0 isolate overflow-hidden rounded-[inherit]',
			className,
		)}
		style={containerStyle}
		{...rest}
	>
		<div class="absolute inset-0 overflow-hidden">
			{/* Ambient glow blobs — pure CSS, SSR-safe */}
			<div
				aria-hidden="true"
				class="absolute inset-0 opacity-60"
				style="background: radial-gradient(circle at 20% 15%, color-mix(in srgb, var(--lr-color) 45%, transparent), transparent 70%)"
			/>
			<div
				aria-hidden="true"
				class="absolute inset-0 opacity-60"
				style="background: radial-gradient(circle at 80% 10%, color-mix(in srgb, var(--lr-color) 35%, transparent), transparent 75%)"
			/>
			@for (const ray of rays.value; key ray.id) {
				<div
					aria-hidden="true"
					class="pointer-events-none absolute -top-[12%] h-(--lr-length) origin-top -translate-x-1/2 rounded-full bg-linear-to-b from-(--lr-from) to-transparent mix-blend-screen blur-(--lr-blur)"
					style={[
						`left: ${ray.left}%`,
						`width: ${ray.width}px`,
						`--lr-rotate: ${ray.rotate}`,
						`--lr-swing: ${ray.swing}`,
						`--lr-intensity: ${ray.intensity}`,
						`--lr-from: color-mix(in srgb, var(--lr-color) 70%, transparent)`,
						`animation: light-ray-pulse ${ray.duration.toFixed(2)}s ease-in-out ${ray.delay.toFixed(2)}s infinite`,
					].join('; ')}
				/>
			}
		</div>
	</div>

	<style>
		@keyframes light-ray-pulse {
			0%   { opacity: 0; rotate: calc((var(--lr-rotate) - var(--lr-swing)) * 1deg); }
			50%  { opacity: var(--lr-intensity); rotate: calc((var(--lr-rotate) + var(--lr-swing)) * 1deg); }
			100% { opacity: 0; rotate: calc((var(--lr-rotate) - var(--lr-swing)) * 1deg); }
		}
	</style>
	</>
}
