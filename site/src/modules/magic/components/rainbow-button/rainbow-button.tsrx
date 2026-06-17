import { cn } from '@/lib/utils';

// The rainbow border effect uses a three-layer background-clip trick
// (padding-box / border-box / border-box) on a `transparent` border —
// the third gradient layer (90deg color stops) shows through the border slot.
// The glow beneath the button is a real <span> (instead of a CSS ::before) so
// the animation class doesn't need to live in the Tailwind theme; the scoped
// <style> block below covers both `rainbow-btn--animate` and variant classes.
export function RainbowButton({
	children,
	class: className,
	variant = 'default',
	size = 'default',
	...props
}: any) @{
	const sizeClass =
		size === 'sm' ? 'h-8 rounded-xl px-3 text-xs'
		: size === 'lg' ? 'h-11 rounded-xl px-8'
		: size === 'icon' ? 'size-9'
		: 'h-9 px-4 py-2';

	<>
	<button
		class={cn(
			'rainbow-btn rainbow-btn--animate group relative cursor-pointer transition-all',
			'inline-flex shrink-0 items-center justify-center gap-2',
			'aria-invalid:border-destructive rounded-sm outline-none focus-visible:ring-[3px]',
			'text-sm font-medium whitespace-nowrap',
			'disabled:pointer-events-none disabled:opacity-50',
			'[&_svg]:pointer-events-none [&_svg]:shrink-0',
			variant === 'outline' ? 'rainbow-btn--outline' : 'rainbow-btn--default',
			sizeClass,
			className,
		)}
		{...props}
	>
		{children}
		{/* Decorative glow blur below the button — mirrors the source's ::before glow */}
		<span
			aria-hidden="true"
			class="rainbow-btn__glow rainbow-btn--animate pointer-events-none absolute -bottom-[20%] left-1/2 z-0 h-1/5 w-3/5 -translate-x-1/2"
		/>
	</button>

	<style>
		/* CSS custom properties for the five rainbow color stops.
		   These match the source component's --color-1..5 convention. */
		:root {
			--color-1: #ff0000;
			--color-2: #ff8c00;
			--color-3: #ffff00;
			--color-4: #00c800;
			--color-5: #0000ff;
		}

		/* Scrolls the 200%-wide gradient to create the continuous rainbow shimmer. */
		@keyframes rainbow-btn-scroll {
			0%   { background-position: 0%; }
			100% { background-position: 200%; }
		}

		.rainbow-btn--animate {
			animation: rainbow-btn-scroll 3s linear infinite;
		}

		/* Default (dark-fill) variant */
		.rainbow-btn.rainbow-btn--default {
			color: var(--color-primary-foreground);
			background-image:
				linear-gradient(#121213, #121213),
				linear-gradient(#121213 50%, rgba(18,18,19,0.6) 80%, rgba(18,18,19,0)),
				linear-gradient(90deg, var(--color-1), var(--color-5), var(--color-3), var(--color-4), var(--color-2));
			background-size: 200%;
			background-clip: padding-box, border-box, border-box;
			background-origin: border-box;
			border: calc(0.125rem) solid transparent;
		}

		.dark .rainbow-btn.rainbow-btn--default {
			background-image:
				linear-gradient(#fff, #fff),
				linear-gradient(#fff 50%, rgba(255,255,255,0.6) 80%, rgba(0,0,0,0)),
				linear-gradient(90deg, var(--color-1), var(--color-5), var(--color-3), var(--color-4), var(--color-2));
		}

		/* Outline variant */
		.rainbow-btn.rainbow-btn--outline {
			color: var(--color-accent-foreground);
			background-image:
				linear-gradient(#ffffff, #ffffff),
				linear-gradient(#ffffff 50%, rgba(18,18,19,0.6) 80%, rgba(18,18,19,0)),
				linear-gradient(90deg, var(--color-1), var(--color-5), var(--color-3), var(--color-4), var(--color-2));
			background-size: 200%;
			background-clip: padding-box, border-box, border-box;
			background-origin: border-box;
			border: 1px solid transparent;
			border-bottom-color: transparent;
		}

		.dark .rainbow-btn.rainbow-btn--outline {
			background-image:
				linear-gradient(#0a0a0a, #0a0a0a),
				linear-gradient(#0a0a0a 50%, rgba(255,255,255,0.6) 80%, rgba(0,0,0,0)),
				linear-gradient(90deg, var(--color-1), var(--color-5), var(--color-3), var(--color-4), var(--color-2));
		}

		/* The glow span: rainbow gradient blurred downward under the button */
		.rainbow-btn__glow {
			background-image: linear-gradient(90deg, var(--color-1), var(--color-5), var(--color-3), var(--color-4), var(--color-2));
			background-size: 200%;
			filter: blur(0.75rem);
		}
	</style>
	</>
}
