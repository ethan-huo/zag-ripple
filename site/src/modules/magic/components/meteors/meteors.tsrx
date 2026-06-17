import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// A shower of diagonal meteors with randomized position, delay and duration.
// Drop inside a `relative overflow-hidden` container.
export function Meteors({
	number = 20,
	minDelay = 0.2,
	maxDelay = 1.2,
	minDuration = 2,
	maxDuration = 10,
	angle = 215,
	class: className,
}: any) @{
	const meteorStyles = track<any[]>([]);

	effect(() => {
		meteorStyles.value = Array.from({ length: number }, () => ({
			angle: `${-angle}deg`,
			top: '-5%',
			left: `calc(0% + ${Math.floor(Math.random() * window.innerWidth)}px)`,
			animationDelay: `${Math.random() * (maxDelay - minDelay) + minDelay}s`,
			animationDuration: `${Math.floor(Math.random() * (maxDuration - minDuration) + minDuration)}s`,
		}));
	});

	<>
	@for (const style of meteorStyles.value; index idx) {
		<span
			style={`--angle: ${style.angle}; top: ${style.top}; left: ${style.left}; animation-delay: ${style.animationDelay}; animation-duration: ${style.animationDuration};`}
			class={cn(
				'animate-meteor pointer-events-none absolute size-0.5 rotate-(--angle) rounded-full bg-zinc-500 shadow-[0_0_0_1px_#ffffff10]',
				className,
			)}
		>
			<div class="pointer-events-none absolute top-1/2 -z-10 h-px w-12.5 -translate-y-1/2 bg-linear-to-r from-zinc-500 to-transparent" />
		</span>
	}
	</>
}
