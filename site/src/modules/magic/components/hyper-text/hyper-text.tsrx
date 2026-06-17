import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Scrambles each character through a random glyph pool and progressively
// settles to the real letter over `duration` ms. rAF loop + IntersectionObserver
// are client-only — all browser APIs live inside `effect`.
// displayText is a plain writable track (not derived) so the rAF loop can
// write per-frame without hitting the "write inside derived" pitfall.
const DEFAULT_CHARACTER_SET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

export function HyperText({
	text,
	duration = 800,
	delay = 0,
	as: Tag = 'div',
	startOnView = false,
	animateOnHover = true,
	characterSet = DEFAULT_CHARACTER_SET,
	class: className,
	...rest
}: any) @{
	// Plain split — safe on server.
	const sourceChars: string[] = (text as string).split('');

	// Writable display buffer — starts as a copy of source.
	const displayText = track<string[]>(sourceChars.slice());

	const isAnimating = track(false);

	const getRandomInt = (max: number) => Math.floor(Math.random() * max);

	// rAF scramble loop — only runs client-side inside effect.
	effect(() => {
		if (!isAnimating.value) {
			// Snap back to real text when idle.
			displayText.value = sourceChars.slice();
			return;
		}

		const maxIterations = sourceChars.length;
		const startTime = performance.now();
		let rafId: number;

		const step = (currentTime: number) => {
			const elapsed = currentTime - startTime;
			const progress = Math.min(elapsed / duration, 1);
			const revealCount = progress * maxIterations;

			displayText.value = sourceChars.map((letter, index) =>
				letter === ' '
					? letter
					: index <= revealCount
						? sourceChars[index]
						: characterSet[getRandomInt(characterSet.length)],
			);

			if (progress < 1) {
				rafId = requestAnimationFrame(step);
			} else {
				// Settle: reset flag so hover can re-trigger.
				isAnimating.value = false;
			}
		};

		rafId = requestAnimationFrame(step);
		return () => cancelAnimationFrame(rafId);
	});

	// Mount-time trigger: IntersectionObserver for startOnView, or delayed auto-start.
	const containerRef = track<HTMLElement | null>(null);

	effect(() => {
		const el = containerRef.value;
		if (!el) return;

		if (startOnView) {
			const observer = new IntersectionObserver(
				([entry]) => {
					if (entry.isIntersecting) {
						setTimeout(() => {
							isAnimating.value = true;
						}, delay);
						observer.disconnect();
					}
				},
				{ threshold: 0.1, rootMargin: '-30% 0px -30% 0px' },
			);
			observer.observe(el);
			return () => observer.disconnect();
		}

		const timer = setTimeout(() => {
			isAnimating.value = true;
		}, delay);
		return () => clearTimeout(timer);
	});

	const handleMouseEnter = () => {
		if (animateOnHover && !isAnimating.value) {
			isAnimating.value = true;
		}
	};

	<>
	<{Tag}
		ref={(el: HTMLElement | null) => {
			containerRef.value = el;
		}}
		class={cn('overflow-hidden py-2 text-4xl font-medium', className)}
		onMouseEnter={handleMouseEnter}
		{...rest}
	>
		<span class="sr-only">{text}</span>
		<span aria-hidden="true" class="inline-flex">
			@for (const letter of displayText.value; index i) {
				<span class={cn('font-mono', letter === ' ' ? 'w-3' : '')}>
					{letter.toUpperCase()}
				</span>
			}
		</span>
	</{Tag}>
	</>
}
