import { effect, track } from 'ripple';
import { inView as observeInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Two-phase scramble-then-reveal animation. Phase 1 grows a column of random
// chars; phase 2 locks in real characters left-to-right while the rest jitter.
// The MutationObserver (children path) only runs inside effect — SSR-safe.

const RANDOM_CHARS = '_!X$0-+*#';
const NBSP = ' ';

function blankText(length: number) {
	return NBSP.repeat(length);
}

function getRandomChar(previousChar?: string) {
	let char = RANDOM_CHARS[Math.floor(Math.random() * RANDOM_CHARS.length)];
	while (char === previousChar) {
		char = RANDOM_CHARS[Math.floor(Math.random() * RANDOM_CHARS.length)];
	}
	return char;
}

export function SpecialText({
	children,
	text,
	speed = 20,
	delay = 0,
	class: className,
	inView = false,
	once = true,
	...props
}: any) @{
	// When `text` is not passed we probe the hidden children span for its
	// textContent. The probe ref is needed because TSRX children are opaque
	// render functions, not readable strings at component setup time.
	const containerRef = track<HTMLSpanElement | null>(null);
	const probeRef = track<HTMLSpanElement | null>(null);

	const slottedText = track('');
	const isInViewport = track(false);
	const hasStarted = track(false);
	const displayText = track('');
	const currentPhase = track<'phase1' | 'phase2'>('phase1');
	const animationStep = track(0);

	const sourceText = track(() => text ?? slottedText.value);

	// --- helpers ---

	let intervalId: ReturnType<typeof setInterval> | null = null;
	let startTimeoutId: ReturnType<typeof setTimeout> | null = null;

	function clearStartTimeout() {
		if (startTimeoutId === null) return;
		clearTimeout(startTimeoutId);
		startTimeoutId = null;
	}

	function clearAnimationInterval() {
		if (intervalId === null) return;
		clearInterval(intervalId);
		intervalId = null;
	}

	function resetAnimation(opts?: { clearDisplay?: boolean }) {
		clearStartTimeout();
		clearAnimationInterval();
		hasStarted.value = false;
		currentPhase.value = 'phase1';
		animationStep.value = 0;

		if (opts?.clearDisplay) {
			displayText.value = '';
			return;
		}

		displayText.value = blankText(sourceText.value.length);
	}

	// --- effects ---

	// Probe children DOM text (client-only — MutationObserver is browser API).
	effect(() => {
		if (text) {
			slottedText.value = '';
			return;
		}

		const probe = probeRef.value;
		if (!probe) return;

		const syncText = () => {
			slottedText.value = probe.textContent?.replace(/\r?\n/g, '') ?? '';
		};

		syncText();

		const observer = new MutationObserver(() => syncText());
		observer.observe(probe, { childList: true, characterData: true, subtree: true });
		return () => observer.disconnect();
	});

	// IntersectionObserver for the optional inView trigger.
	effect(() => {
		const el = containerRef.value;

		if (!el || !inView) {
			isInViewport.value = !inView;
			return;
		}

		const stop = observeInView(
			el,
			() => {
				isInViewport.value = true;

				if (!once) {
					return () => {
						isInViewport.value = false;
					};
				}
			},
			{ margin: '-100px' },
		);

		return () => stop();
	});

	// Keep displayText length in sync when text changes before animation starts.
	effect(() => {
		const src = sourceText.value;

		if (!src) {
			resetAnimation({ clearDisplay: true });
			return;
		}

		if (displayText.value.length !== src.length && !hasStarted.value) {
			displayText.value = blankText(src.length);
		}
	});

	// Restart animation when sourceText changes.
	effect(() => {
		// Accessed for reactivity; the comparison is done via a closure variable.
		const src = sourceText.value;
		if (!src) return;
		// Unconditionally reset so a new text value re-triggers from blank.
		resetAnimation();
	});

	// Watch isInViewport to start/stop the animation.
	effect(() => {
		const src = sourceText.value;
		if (!src) return;

		if (!isInViewport.value) {
			if (!once) resetAnimation();
			return;
		}

		if (hasStarted.value) return;

		if (delay <= 0) {
			hasStarted.value = true;
			return;
		}

		startTimeoutId = setTimeout(() => {
			startTimeoutId = null;
			hasStarted.value = true;
		}, delay * 1000);

		return () => clearStartTimeout();
	});

	// Drive the interval-based two-phase animation.
	effect(() => {
		if (!hasStarted.value || !sourceText.value) return;

		clearAnimationInterval();

		intervalId = setInterval(() => {
			const src = sourceText.value;

			if (currentPhase.value === 'phase1') {
				// Phase 1: grow random chars from left to right.
				const maxSteps = src.length * 2;
				const currentLength = Math.min(animationStep.value + 1, src.length);
				const chars: string[] = [];

				for (let i = 0; i < currentLength; i += 1) {
					chars.push(getRandomChar(i > 0 ? chars[i - 1] : undefined));
				}
				for (let i = currentLength; i < src.length; i += 1) {
					chars.push(NBSP);
				}

				displayText.value = chars.join('');

				if (animationStep.value < maxSteps - 1) {
					animationStep.value += 1;
					return;
				}

				currentPhase.value = 'phase2';
				animationStep.value = 0;
				return;
			}

			// Phase 2: lock in real chars from left, jitter the rest.
			const revealedCount = Math.floor(animationStep.value / 2);
			const chars: string[] = [];

			for (let i = 0; i < revealedCount && i < src.length; i += 1) {
				chars.push(src[i]);
			}

			if (revealedCount < src.length) {
				chars.push(animationStep.value % 2 === 0 ? '_' : getRandomChar());
			}

			for (let i = chars.length; i < src.length; i += 1) {
				chars.push(getRandomChar());
			}

			displayText.value = chars.join('');

			if (animationStep.value < src.length * 2 - 1) {
				animationStep.value += 1;
				return;
			}

			displayText.value = src;
			clearAnimationInterval();
		}, speed);

		return () => clearAnimationInterval();
	});

	<>
	<span
		ref={(el: HTMLSpanElement | null) => { containerRef.value = el; }}
		class={cn('inline-flex h-[1.125rem] font-mono text-sm leading-5 font-medium whitespace-pre', className)}
		{...props}
	>
		<span aria-hidden="true">{displayText.value}</span>
		<span class="sr-only">{sourceText.value}</span>

		@if (!text) {
			<span
				ref={(el: HTMLSpanElement | null) => { probeRef.value = el; }}
				class="sr-only"
			>
				{children}
			</span>
		}
	</span>
	</>
}
