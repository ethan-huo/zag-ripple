import { cn } from '@/lib/utils';
import { Motion } from '@/lib/motion';

// A highlight bar that slides in from a chosen edge behind the text. The text
// sits on top with `mix-blend-difference`, so it flips to readable contrast as
// the bar passes under it.
const fromTargets: Record<string, { initial: any; animate: any }> = {
	left: { initial: { x: '-100%' }, animate: { x: '0%' } },
	right: { initial: { x: '100%' }, animate: { x: '0%' } },
	top: { initial: { y: '-100%' }, animate: { y: '0%' } },
	bottom: { initial: { y: '100%' }, animate: { y: '0%' } },
};

export function HighlightedText({
	children,
	class: className,
	from = 'bottom',
	delay = 0,
	triggerOnView = false,
	once = true,
	...props
}: any) @{
	const variant = fromTargets[from] ?? fromTargets.bottom;
	const transition = { type: 'spring', damping: 30, stiffness: 300, delay };

	<>
	<span
		class={cn('relative inline-flex overflow-hidden align-baseline', className)}
		{...props}
	>
		<Motion
			class="absolute inset-0 -right-[0.18em] -left-[0.15em] z-0 bg-black dark:bg-white"
			initial={variant.initial}
			animate={variant.animate}
			transition={transition}
			inView={triggerOnView}
			once={once}
		/>
		<span class="relative z-10 pr-[0.18em] pl-[0.15em] text-white mix-blend-difference">
			{children}
		</span>
	</span>
	</>
}
