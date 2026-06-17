import { track } from 'ripple';
import { animate, stagger } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Ping-pong variant of LetterSwap: letters animate out on hover-enter AND back
// on hover-leave, creating a bidirectional swap. We track `hovered` to drive the
// reverse animation and use a `pending` flag (analogous to the source's
// Debounced guard) to prevent re-entry while a transition is in flight.
export function LetterSwapPingPong({
	label,
	reverse = true,
	transition = { type: 'spring', duration: 0.7 },
	staggerDuration = 0.03,
	staggerFrom = 'first',
	class: className,
	...props
}: any) @{
	let scope = track<HTMLElement | null>(null);
	// Tracks current hover state so hover-leave knows which direction to reverse.
	let hovered = track(false);
	// Guards against re-entrant animation calls while a transition is running.
	let pending = false;

	const letters = label.split('');

	// Merge in stagger delay so each letter animates offset from the previous.
	const merge = (base: any) => ({
		...base,
		delay: stagger(staggerDuration, { from: staggerFrom }),
	});

	const runAnimation = (nextHovered: boolean) => {
		const root = scope.value;
		if (!root || pending) return;
		pending = true;

		const primaries = root.querySelectorAll('.letter');
		const secondaries = root.querySelectorAll('.letter-secondary');

		// Primary letters: slide out when hovering, return to rest when leaving.
		const primaryTarget = nextHovered ? (reverse ? '100%' : '-100%') : '0%';
		// Secondary letters: slide into view when hovering, retreat when leaving.
		const secondaryTarget = nextHovered ? '0%' : (reverse ? '-100%' : '100%');

		Promise.all([
			animate(primaries, { y: primaryTarget }, merge(transition) as any),
			animate(secondaries, { top: secondaryTarget }, merge(transition) as any),
		]).then(() => {
			pending = false;
		});
	};

	const hoverStart = () => {
		if (hovered.value) return;
		hovered.value = true;
		runAnimation(true);
	};

	const hoverEnd = () => {
		if (!hovered.value) return;
		hovered.value = false;
		runAnimation(false);
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
				<span class="letter relative" style="top: 0">{letter}</span>
				<span
					class="letter-secondary absolute"
					style={`top: ${reverse ? '-100%' : '100%'}`}
				>
					{letter}
				</span>
			</span>
		}
	</span>
	</>
}
