import { track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// On hover, letters swap in a randomly shuffled order rather than sequential
// left-to-right. Each letter is animated independently so delay is derived
// from its position in the shuffle, not the stagger() helper (which only
// supports linear orderings).
export function RandomLetterSwap({
	label,
	reverse = true,
	transition = { type: 'spring', duration: 0.8 },
	staggerDuration = 0.02,
	class: className,
	...props
}: any) @{
	let scope = track<HTMLElement | null>(null);
	let blocked = false;
	const letters = label.split('');

	const getShuffledIndices = () =>
		Array.from({ length: letters.length }, (_: unknown, i: number) => i).sort(
			() => Math.random() - 0.5,
		);

	const hoverStart = () => {
		const root = scope.value;
		if (!root || blocked || letters.length === 0) return;
		blocked = true;

		const shuffledIndices = getShuffledIndices();
		let completions = 0;

		for (let orderIndex = 0; orderIndex < shuffledIndices.length; orderIndex += 1) {
			const randomIndex = shuffledIndices[orderIndex];
			const delay = orderIndex * staggerDuration;

			const primary = root.querySelector(`.rl-primary-${randomIndex}`) as HTMLElement | null;
			const secondary = root.querySelector(`.rl-secondary-${randomIndex}`) as HTMLElement | null;

			if (primary) {
				animate(primary, { y: reverse ? '100%' : '-100%' }, { ...transition, delay }).then(
					() => {
						animate(primary, { y: 0 }, { duration: 0 });
					},
				);
			}

			if (secondary) {
				animate(secondary, { top: '0%' }, { ...transition, delay })
					.then(() => animate(secondary, { top: reverse ? '-100%' : '100%' }, { duration: 0 }))
					.then(() => {
						completions += 1;
						// Unblock only after the last animation in the shuffle completes.
						if (completions === shuffledIndices.length) {
							blocked = false;
						}
					});
			}
		}
	};

	<>
	<span
		ref={(el) => {
			scope.value = el;
		}}
		class={cn('relative flex items-center justify-center overflow-hidden', className)}
		onMouseEnter={hoverStart}
		{...props}
	>
		<span class="sr-only">{label}</span>

		@for (const letter of letters; index i) {
			<span class="relative flex whitespace-pre" aria-hidden="true">
				<span class={`rl-primary-${i} relative pb-2`} style="top: 0">{letter}</span>
				<span
					class={`rl-secondary-${i} absolute`}
					style={`top: ${reverse ? '-100%' : '100%'}`}
				>
					{letter}
				</span>
			</span>
		}
	</span>
	</>
}
