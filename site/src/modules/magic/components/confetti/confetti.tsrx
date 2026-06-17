import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// canvas-confetti fires once per burst; the Svelte source used @neoconfetti/svelte
// which is a thin Svelte action wrapper around the same vanilla confetti engine.
// We call canvas-confetti directly inside an effect (client-only) so SSR is safe.

// ---- Confetti (wrapper that fires when `active` flips to true) ----
export function Confetti({
	active = false,
	options = {},
	class: className = '',
	children,
}: any) @{
	// Ref on the outer container; burst fires from horizontal center-top of wrapper.
	const containerRef = track<HTMLElement | null>(null);

	effect(() => {
		if (!active) return;
		const el = containerRef.value;
		if (!el) return;

		// Lazily import so canvas-confetti is never evaluated on the server.
		import('canvas-confetti').then((mod) => {
			const confetti = mod.default;
			const rect = el.getBoundingClientRect();
			const origin = {
				x: (rect.left + rect.width / 2) / window.innerWidth,
				y: rect.top / window.innerHeight,
			};
			confetti({
				particleCount: 40,
				startVelocity: 30,
				spread: 70,
				origin,
				...options,
			});
		});
	});

	<>
	<div
		class={cn('relative', className)}
		ref={(el) => { containerRef.value = el; }}
	>
		{children}
	</div>
	</>
}

// ---- ConfettiButton (fires a burst on each click) ----
export function ConfettiButton({
	options = {},
	children,
	class: className = '',
	onClick,
	...props
}: any) @{
	const buttonRef = track<HTMLButtonElement | null>(null);
	// Increment on each click to re-trigger the effect; avoids double-fire on
	// rapid clicks by waiting for the active→inactive→active cycle to complete.
	const clickCount = track(0);

	effect(() => {
		if (clickCount.value === 0) return;
		const el = buttonRef.value;
		if (!el) return;

		import('canvas-confetti').then((mod) => {
			const confetti = mod.default;
			const rect = el.getBoundingClientRect();
			const origin = {
				x: (rect.left + rect.width / 2) / window.innerWidth,
				y: rect.top / window.innerHeight,
			};
			confetti({
				particleCount: 50,
				startVelocity: 35,
				spread: 90,
				origin,
				colors: ['#ff0000', '#00ff00', '#0000ff'],
				...options,
			});
		});
	});

	<>
	<button
		class={cn(
			'rounded-lg bg-blue-600 px-6 py-3 font-semibold text-white transition-colors hover:bg-blue-700',
			className,
		)}
		ref={(el) => { buttonRef.value = el as HTMLButtonElement | null; }}
		onClick={(e: any) => {
			clickCount.value += 1;
			onClick?.(e);
		}}
		{...props}
	>
		{children ?? 'Click Me!'}
	</button>
	</>
}
