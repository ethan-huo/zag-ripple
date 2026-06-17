import { track } from 'ripple';
import { cn } from '@/lib/utils';

// Ripple items must be removed after the animation completes on the client.
// We can't do that in a derived or render path — the setTimeout fires inside
// a click handler (client-only), so it's safe to reference DOM timing APIs.
export function RippleButton({
	children,
	class: className,
	rippleColor = '#ffffff',
	duration = '600ms',
	onClick,
	...props
}: any) @{
	// Each ripple is a circle positioned at the click point, keyed by timestamp.
	type RippleItem = { x: number; y: number; size: number; key: number };
	const ripples = track<RippleItem[]>([]);

	function handleClick(event: MouseEvent) {
		const button = event.currentTarget as HTMLButtonElement;
		const rect = button.getBoundingClientRect();
		const size = Math.max(rect.width, rect.height);
		const x = event.clientX - rect.left - size / 2;
		const y = event.clientY - rect.top - size / 2;
		const key = Date.now();

		ripples.value = [...ripples.value, { x, y, size, key }];

		// Remove this ripple after the animation finishes (client-only: setTimeout).
		const ms = parseInt(duration, 10) || 600;
		setTimeout(() => {
			ripples.value = ripples.value.filter((r) => r.key !== key);
		}, ms);

		onClick?.(event);
	}

	<>
	<button
		class={cn(
			'bg-muted text-primary relative flex cursor-pointer items-center justify-center overflow-hidden rounded-lg border-2 px-4 py-2 text-center',
			className,
		)}
		onClick={handleClick}
		{...props}
	>
		<div class="relative z-10">
			{children}
		</div>
		<span class="pointer-events-none absolute inset-0">
			@for (const ripple of ripples.value; index i) {
				<span
					class="magic-ripple-button__ripple absolute rounded-full"
					style={`--duration: ${duration}; width: ${ripple.size}px; height: ${ripple.size}px; top: ${ripple.y}px; left: ${ripple.x}px; background-color: ${rippleColor}; transform: scale(0);`}
				/>
			}
		</span>
	</button>

	<style>
		@keyframes magic-ripple-button-rippling {
			0% { transform: scale(0); opacity: 1; }
			100% { transform: scale(2); opacity: 0; }
		}
		.magic-ripple-button__ripple {
			animation: magic-ripple-button-rippling var(--duration, 600ms) ease-out forwards;
		}
	</style>
	</>
}
