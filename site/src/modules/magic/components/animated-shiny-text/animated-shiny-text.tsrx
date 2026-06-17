import { cn } from '@/lib/utils';

// A shine sweeps across the text by animating a clipped gradient's
// background-position (see `animate-shiny-text` in styles/magic.css).
export function AnimatedShinyText({
	children,
	class: className,
	shimmerWidth = 100,
	duration = 8,
	...restProps
}: any) @{
	<>
	<span
		style={`--shiny-width: ${shimmerWidth}px; --duration: ${duration}s`}
		class={cn(
			'mx-auto max-w-md text-neutral-600/70 dark:text-neutral-400/70',
			'animate-shiny-text bg-size-[var(--shiny-width)_100%] bg-clip-text bg-position-[0_0] bg-no-repeat',
			'bg-linear-to-r from-transparent via-black/80 via-50% to-transparent dark:via-white/80',
			className,
		)}
		{...restProps}
	>
		{children}
	</span>
	</>
}
