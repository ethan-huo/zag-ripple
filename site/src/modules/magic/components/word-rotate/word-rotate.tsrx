import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Rotates through a list of words on an interval, sliding the current word out
// before the next slides in. A single persistent element is reused — the exit
// animation finishes before the text swaps, then the entrance plays.
export function WordRotate({ words, duration = 2500, class: className }: any) @{
	const index = track(0);
	let node = track<HTMLElement | null>(null);

	// Entrance: runs on mount and after every index change (text swap).
	effect(() => {
		index.value;
		const el = node.value;
		if (!el) return;
		animate(el, { opacity: [0, 1], y: [-24, 0] }, { duration: 0.35, ease: 'easeOut' });
	});

	// Exit-then-swap loop.
	effect(() => {
		if (!words || words.length < 2) return;
		const id = setInterval(() => {
			const el = node.value;
			const advance = () => {
				index.value = (index.value + 1) % words.length;
			};
			if (el) {
				animate(el, { opacity: [1, 0], y: [0, 24] }, { duration: 0.25, ease: 'easeIn' }).then(
					advance,
				);
			} else {
				advance();
			}
		}, duration);
		return () => clearInterval(id);
	});

	<>
	<div class="overflow-hidden py-2">
		<h1
			ref={(el) => {
				node.value = el;
			}}
			class={cn('inline-block', className)}
		>
			{words[index.value]}
		</h1>
	</div>
	</>
}
