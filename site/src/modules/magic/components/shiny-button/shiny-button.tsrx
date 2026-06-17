import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// The shimmer sweep is driven by a CSS custom property `--x` animated on the
// button element itself, so both the mask-image on the text span and the
// background-image on the border span pick it up via `var(--x)` without any
// extra JS reads. Spring physics controls the per-cycle curve; a 1s repeatDelay
// gives the idle "pause then sweep" feel from the original motion-sv source.
//
// Dark-mode background/glow use a scoped <style> block because `color-mix()`
// inside Tailwind arbitrary-value brackets doesn't survive the CSS parser.
export function ShinyButton({ children, class: className, ...rest }: any) @{
	let node = track<HTMLButtonElement | null>(null);
	let isPressed = track(false);

	effect(() => {
		const el = node.value;
		if (!el) return;

		// Entrance scale-in: spring from 0.8 → 1 once.
		animate(
			el,
			{ scale: [0.8, 1] },
			{ type: 'spring', stiffness: 200, damping: 5, mass: 0.5 },
		);

		// Infinite shimmer sweep: --x goes 100% → -100% each cycle,
		// pausing 1s between sweeps. Spring gives a natural deceleration.
		const shimmerControls = animate(
			el,
			{ '--x': ['100%', '-100%'] },
			{
				repeat: Infinity,
				repeatType: 'loop',
				repeatDelay: 1,
				type: 'spring',
				stiffness: 20,
				damping: 15,
				mass: 2,
			} as any,
		);

		return () => shimmerControls.stop();
	});

	<>
	<button
		ref={(el: HTMLButtonElement | null) => { node.value = el; }}
		class={cn('shiny-btn relative cursor-pointer rounded-lg border px-6 py-2 font-medium backdrop-blur-xl', className)}
		style={isPressed.value ? 'transform: scale(0.95); transition: transform 0.1s ease;' : 'transition: transform 0.1s ease;'}
		onPointerDown={() => { isPressed.value = true; }}
		onPointerUp={() => { isPressed.value = false; }}
		onPointerLeave={() => { isPressed.value = false; }}
		{...rest}
	>
		<span
			class="relative block size-full text-sm tracking-wide text-[rgb(0,0,0,65%)] uppercase dark:font-light dark:text-[rgb(255,255,255,90%)]"
			style="mask-image: linear-gradient(-75deg, var(--color-primary) calc(var(--x) + 20%), transparent calc(var(--x) + 30%), var(--color-primary) calc(var(--x) + 100%));"
		>
			{children}
		</span>
		{/* Border shine layer: background uses --x via inline style so the animation
		    engine can drive it; mask punches a hole through the padding area so only
		    the border slot shows the gradient. */}
		<span
			style="mask: linear-gradient(rgb(0,0,0), rgb(0,0,0)) content-box exclude, linear-gradient(rgb(0,0,0), rgb(0,0,0)); -webkit-mask: linear-gradient(rgb(0,0,0), rgb(0,0,0)) content-box exclude, linear-gradient(rgb(0,0,0), rgb(0,0,0)); background-image: linear-gradient(-75deg, color-mix(in oklch, var(--color-primary) 10%, transparent) calc(var(--x) + 20%), color-mix(in oklch, var(--color-primary) 50%, transparent) calc(var(--x) + 25%), color-mix(in oklch, var(--color-primary) 10%, transparent) calc(var(--x) + 100%))"
			class="absolute inset-0 z-10 block rounded-[inherit] p-px"
		/>
	</button>

	<style>
		.shiny-btn {
			transition-property: box-shadow;
			transition-duration: 300ms;
			transition-timing-function: ease-in-out;
		}
		.shiny-btn:hover {
			box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1);
		}
		.dark .shiny-btn {
			background: radial-gradient(circle at 50% 0%, color-mix(in oklch, var(--color-primary) 10%, transparent) 0%, transparent 60%);
		}
		.dark .shiny-btn:hover {
			box-shadow: 0 0 20px color-mix(in oklch, var(--color-primary) 10%, transparent);
		}
	</style>
	</>
}
