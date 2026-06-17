import { track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Random-order variant of LetterSwapPingPong. The source uses per-letter class
// selectors (`.letter-${i}`) so that motion's `animate` can target each letter
// individually with a custom delay derived from the shuffled animation order.
// We reproduce that here rather than using motion's `stagger`, which only
// supports sequential order.
export function RandomLetterSwapPingPong({
	label,
	reverse = true,
	transition = { type: 'spring', duration: 0.8 },
	staggerDuration = 0.02,
	class: className,
	...props
}: any) @{
	let scope = track<HTMLElement | null>(null);
	// Tracks current hover state so hover-leave knows which direction to reverse.
	let hovered = track(false);
	// Guards against re-entrant animation calls while a transition is in flight.
	let blocked = false;
	// Cached shuffle from hover-enter, reused on hover-leave so letters reverse
	// in the same random order they animated in.
	let lastShuffle: number[] = [];

	const letters = label.split('');

	const getShuffledIndices = () =>
		Array.from({ length: letters.length }, (_, i) => i).sort(() => Math.random() - 0.5);

	const runAnimation = (indices: number[], nextHovered: boolean) => {
		const root = scope.value;
		if (!root) return;

		// Primary letters: slide out on hover-enter, return on hover-leave.
		const primaryTarget = nextHovered ? (reverse ? '100%' : '-100%') : '0%';
		// Secondary letters: slide in on hover-enter, retreat on hover-leave.
		const secondaryTarget = nextHovered ? '0%' : reverse ? '-100%' : '100%';

		const animations: Promise<unknown>[] = [];

		for (let orderIndex = 0; orderIndex < indices.length; orderIndex += 1) {
			const letterIndex = indices[orderIndex];
			const delay = orderIndex * staggerDuration;
			const t = { ...transition, delay };

			const primary = root.querySelector(`.letter-${letterIndex}`);
			const secondary = root.querySelector(`.letter-secondary-${letterIndex}`);

			if (primary) animations.push(animate(primary as Element, { y: primaryTarget }, t as any));
			if (secondary) animations.push(animate(secondary as Element, { top: secondaryTarget }, t as any));
		}

		Promise.all(animations).then(() => {
			blocked = false;
		});
	};

	const hoverStart = () => {
		if (hovered.value || blocked) return;
		hovered.value = true;
		blocked = true;
		lastShuffle = getShuffledIndices();
		runAnimation(lastShuffle, true);
	};

	const hoverEnd = () => {
		if (!hovered.value || blocked) return;
		hovered.value = false;
		blocked = true;
		// Reuse the same shuffle order so the reverse mirrors the entry.
		const indices = lastShuffle.length === letters.length ? lastShuffle : getShuffledIndices();
		runAnimation(indices, false);
	};

	<>
	<span
		ref={(el) => {
			scope.value = el;
		}}
		class={cn('relative flex items-center justify-center overflow-hidden', className)}
		onMouseEnter={hoverStart}
		onMouseLeave={hoverEnd}
		{...props}
	>
		<span class="sr-only">{label}</span>

		@for (const letter of letters; index i) {
			<span class="relative flex whitespace-pre" aria-hidden="true">
				<span class={`letter-${i} relative`} style="top: 0">{letter}</span>
				<span
					class={`letter-secondary-${i} absolute`}
					style={`top: ${reverse ? '-100%' : '100%'}`}
				>
					{letter}
				</span>
			</span>
		}
	</span>
	</>
}
