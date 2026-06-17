import { effect, track } from 'ripple';
import { inView } from '@/lib/motion';
import { splitGraphemes } from '@/lib/text-utils';
import { cn } from '@/lib/utils';

// The animation runs entirely via setTimeout chained recursively so we can vary
// the delay per phase (type / pause / delete) without fighting a fixed interval.
// inView from the motion engine starts the sequence only when the element
// scrolls into view, matching the Svelte source's `startOnView` behaviour.

export function TypingAnimation({
	content,
	words,
	class: className,
	duration = 100,
	typeSpeed,
	deleteSpeed,
	delay = 0,
	pauseDelay = 1000,
	loop = false,
	startOnView = true,
	showCursor = true,
	blinkCursor = true,
	cursorStyle = 'line',
}: any) @{
	// Resolve the list of strings to type. Empty array → nothing rendered.
	const wordsToAnimate = track(() => words ?? (content ? [content] : []));
	const hasMultipleWords = track(() => wordsToAnimate.value.length > 1);
	const typingSpeed = track(() => typeSpeed ?? duration);
	const deletingSpeed = track(() => deleteSpeed ?? typingSpeed.value / 2);

	// Mutable animation state — plain track values (not derived) because they
	// are written from inside the setTimeout callbacks.
	const displayedText = track('');
	const currentWordIndex = track(0);
	const currentCharIndex = track(0);
	const phase = track('typing');
	const isInView = track(false);

	// The DOM node we attach inView detection to.
	const nodeRef = track(null);

	// Wire inView detection when the element mounts (or immediately when
	// startOnView is false — same logic as the Svelte `watch(elementRef, …)`).
	effect(() => {
		const el = nodeRef.value;
		if (!startOnView) {
			isInView.value = true;
			return;
		}
		if (!el) return;
		const stop = inView(
			el,
			() => {
				isInView.value = true;
			},
			{ amount: 0.3 },
		);
		return stop;
	});

	// Main animation loop — (re)starts whenever `isInView` flips to true.
	effect(() => {
		if (!isInView.value) return;
		const list = wordsToAnimate.value;
		if (list.length === 0) return;

		// Reset all state so a re-trigger (e.g. re-entering viewport) starts fresh.
		displayedText.value = '';
		currentWordIndex.value = 0;
		currentCharIndex.value = 0;
		phase.value = 'typing';

		let timeoutId: any;

		function runAnimation() {
			const list = wordsToAnimate.value;
			const word = list[currentWordIndex.value] ?? '';
			const graphemes = splitGraphemes(word);

			const baseDelay =
				delay > 0 && displayedText.value === ''
					? delay
					: phase.value === 'typing'
						? typingSpeed.value
						: phase.value === 'deleting'
							? deletingSpeed.value
							: pauseDelay;

			timeoutId = setTimeout(() => {
				switch (phase.value) {
					case 'typing':
						if (currentCharIndex.value < graphemes.length) {
							displayedText.value = graphemes.slice(0, currentCharIndex.value + 1).join('');
							currentCharIndex.value += 1;
							runAnimation();
						} else {
							// Finished typing current word.
							if (hasMultipleWords.value || loop) {
								const isLast = currentWordIndex.value === list.length - 1;
								if (!isLast || loop) {
									phase.value = 'pause';
									runAnimation();
								}
							}
						}
						break;

					case 'pause':
						phase.value = 'deleting';
						runAnimation();
						break;

					case 'deleting':
						if (currentCharIndex.value > 0) {
							displayedText.value = graphemes.slice(0, currentCharIndex.value - 1).join('');
							currentCharIndex.value -= 1;
							runAnimation();
						} else {
							// Finished deleting — advance to the next word.
							currentWordIndex.value = (currentWordIndex.value + 1) % list.length;
							phase.value = 'typing';
							runAnimation();
						}
						break;
				}
			}, baseDelay);
		}

		runAnimation();
		return () => clearTimeout(timeoutId);
	});

	// Derived display flags.
	const currentWordGraphemes = track(() =>
		splitGraphemes(wordsToAnimate.value[currentWordIndex.value] ?? ''),
	);

	// Animation is "complete" once the last word is fully typed and we're not looping.
	const isComplete = track(
		() =>
			!loop &&
			currentWordIndex.value === wordsToAnimate.value.length - 1 &&
			currentCharIndex.value >= currentWordGraphemes.value.length &&
			phase.value !== 'deleting',
	);

	// Show cursor while still animating.
	const shouldShowCursor = track(
		() =>
			showCursor &&
			!isComplete.value &&
			(hasMultipleWords.value ||
				loop ||
				currentCharIndex.value < currentWordGraphemes.value.length),
	);

	function getCursorChar() {
		if (cursorStyle === 'block') return '▌';
		if (cursorStyle === 'underscore') return '_';
		return '|';
	}

	<>
	<style>
		@keyframes ta-blink-cursor {
			0%, 100% { opacity: 1; }
			50% { opacity: 0; }
		}
		.ta-blink { animation: ta-blink-cursor 1s step-start infinite; }
	</style>
	<span
		ref={(el) => { nodeRef.value = el; }}
		class={cn('leading-[1.25] tracking-[-0.02em]', className)}
	>
		{displayedText.value}
		@if (shouldShowCursor.value) {
			<span class={cn('inline-block', blinkCursor && 'ta-blink')}>
				{getCursorChar()}
			</span>
		}
	</span>
	</>
}
