import { cn } from '@/lib/utils';

// Three box-shadow pulse variants driven entirely by CSS — no JS animation.
// The span behind the button content inherits the button's border-radius via
// `rounded-[inherit]` and `bg-inherit`, so the glow ring tracks any shape.
export function PulsatingButton({
	children,
	class: className,
	pulseColor = '#808080',
	duration = '1.5s',
	distance = '8px',
	variant = 'slow',
	...props
}: any) @{
	const variantClass = variant === 'ripple'
		? 'pulsating-btn--ripple'
		: variant === 'ring'
			? 'pulsating-btn--ring'
			: 'pulsating-btn--slow';

	<>
	<button
		class={cn(
			'bg-primary text-primary-foreground relative flex cursor-pointer items-center justify-center rounded-lg px-4 py-2 text-center',
			className,
		)}
		style={`--pulse-color: ${pulseColor}; --duration: ${duration}; --distance: ${distance};`}
		{...props}
	>
		<div class="relative z-10">{children}</div>
		<span
			aria-hidden="true"
			class={cn('pointer-events-none absolute inset-0 rounded-[inherit] bg-inherit', variantClass)}
		/>
	</button>

	<style>
		@keyframes pulsating-btn-slow {
			0% { box-shadow: 0 0 0 0 var(--pulse-color); }
			100% { box-shadow: 0 0 0 var(--distance) transparent; }
		}
		@keyframes pulsating-btn-ring {
			0%, 100% { box-shadow: 0 0 0 0 var(--pulse-color); }
			50% { box-shadow: 0 0 0 var(--distance) var(--pulse-color); }
		}
		@keyframes pulsating-btn-ripple {
			/* ripple: expand + fade — equivalent to the source's oklch-relative fade */
			0% { box-shadow: 0 0 0 0 var(--pulse-color); }
			100% { box-shadow: 0 0 0 var(--distance) transparent; }
		}
		.pulsating-btn--slow {
			animation: pulsating-btn-slow var(--duration, 1.5s) ease-out infinite;
		}
		.pulsating-btn--ring {
			animation: pulsating-btn-ring var(--duration, 1.5s) ease-out infinite;
		}
		.pulsating-btn--ripple {
			animation: pulsating-btn-ripple var(--duration, 1.5s) cubic-bezier(0.16, 1, 0.3, 1) infinite;
		}
	</style>
	</>
}
