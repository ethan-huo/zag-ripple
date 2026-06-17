import { effect, track } from 'ripple';
import { splitGraphemes } from '@/lib/text-utils';

// Text reveals left-to-right, with the not-yet-revealed tail showing a few
// scrambling random glyphs. Interval-driven; `autoStart` kicks it off on mount.
const DEFAULT_CHARACTERS = 'abcdefghijklmnopqrstuvwxyz!@#$%^&*()_+';

export function ScrambleIn({
	text,
	scrambleDelay = 0,
	scrambleSpeed = 50,
	scrambledLetterCount = 2,
	characters = DEFAULT_CHARACTERS,
	class: className,
	scrambledClass,
	autoStart = true,
	onStart,
	onComplete,
	...props
}: any) @{
	const displayText = track('');
	const isAnimating = track(false);
	const visibleLetterCount = track(0);
	const scrambleOffset = track(0);

	const sourceSegments = track(() => splitGraphemes(text));
	const displaySegments = track(() => splitGraphemes(displayText.value));
	const scrambleSegments = track(() => splitGraphemes(characters));
	const revealedText = track(() =>
		displaySegments.value.slice(0, visibleLetterCount.value).join(''),
	);
	const scrambledText = track(() => displaySegments.value.slice(visibleLetterCount.value).join(''));

	let startTimeout: ReturnType<typeof setTimeout> | null = null;
	const clearStart = () => {
		if (startTimeout !== null) {
			clearTimeout(startTimeout);
			startTimeout = null;
		}
	};

	const start = () => {
		clearStart();
		displayText.value = '';
		visibleLetterCount.value = 0;
		scrambleOffset.value = 0;
		isAnimating.value = false;
		const delay = Math.max(0, scrambleDelay);
		if (delay === 0) {
			isAnimating.value = true;
			onStart?.();
			return;
		}
		startTimeout = setTimeout(() => {
			startTimeout = null;
			isAnimating.value = true;
			onStart?.();
		}, delay);
	};

	effect(() => {
		if (autoStart) queueMicrotask(() => start());
		return clearStart;
	});

	effect(() => {
		if (!isAnimating.value) return;
		const intervalDelay = Math.max(0, scrambleSpeed);
		const totalSegments = sourceSegments.value.length;
		const maxScrambled = Math.max(0, Math.trunc(scrambledLetterCount));
		const pool = scrambleSegments.value;
		const getRandom = () =>
			pool.length === 0 ? '' : pool[Math.floor(Math.random() * pool.length)] ?? '';

		const id = setInterval(() => {
			const cv = visibleLetterCount.value;
			const co = scrambleOffset.value;
			if (cv < totalSegments) {
				visibleLetterCount.value = cv + 1;
			} else if (co < maxScrambled) {
				scrambleOffset.value = co + 1;
			} else {
				isAnimating.value = false;
				onComplete?.();
				return;
			}
			const remaining = Math.max(0, totalSegments - cv);
			const count = Math.min(remaining, maxScrambled);
			const scrambledPart = Array.from({ length: count }, getRandom).join('');
			displayText.value = sourceSegments.value.slice(0, cv).join('') + scrambledPart;
		}, intervalDelay);

		return () => clearInterval(id);
	});

	<>
	<span {...props}>
		<span class="sr-only">{text}</span>
		<span class="inline-block whitespace-pre-wrap" aria-hidden="true">
			<span class={className}>{revealedText.value}</span>
			<span class={scrambledClass}>{scrambledText.value}</span>
		</span>
	</span>
	</>
}
