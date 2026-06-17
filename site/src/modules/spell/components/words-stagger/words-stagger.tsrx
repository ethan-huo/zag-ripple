import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';
import { animate, stagger, useInView } from '@/lib/motion';
import { segmentText } from '@/lib/text-utils';

// Animates each word in `text` with an opacity/y/blur stagger. The Svelte source
// used motion-sv `containerVariants` with `staggerChildren`; we replicate that by
// querying the rendered word spans after mount and driving them through a single
// `animate(els, keyframes, { delay: stagger(…) })` call — one motion engine path.
export function WordsStagger({
	text = '',
	class: className,
	as: Tag = 'div',
	delay = 0,
	stagger: staggerDelay = 0.1,
	speed = 0.5,
	trigger = true,
	triggerOnView = false,
	once = true,
	onStart,
	onComplete,
	...rest
}: any) @{
	const safeDelay = Math.max(delay ?? 0, 0);
	const safeStagger = Math.max(staggerDelay ?? 0.1, 0);
	const safeSpeed = Math.max(speed ?? 0.5, 0.01);

	// Token list derived from plain text — pure, SSR-safe.
	const tokens = track(() => {
		let wordIndex = 0;
		return segmentText(String(text ?? '')).map((token, i) => {
			if (token.kind === 'whitespace') {
				return { kind: 'whitespace' as const, id: `ws-${i}`, value: token.value };
			}
			const word = { kind: 'word' as const, id: `w-${i}`, content: token.value, index: wordIndex };
			wordIndex += 1;
			return word;
		});
	});

	const root = track<HTMLElement | null>(null);
	const inView = useInView({ once, amount: 0.2 });

	const wordCount = track(() => tokens.value.filter((t) => t.kind === 'word').length);

	const shouldAnimate = track(() => {
		if (wordCount.value === 0 || !trigger) return false;
		return triggerOnView ? inView.visible.value : true;
	});

	// Animate when shouldAnimate flips true; snap hidden on false so re-triggers
	// always start from the correct initial state (mirrors Svelte source's cycle logic).
	// A plain (non-tracked) variable is intentional: writing a tracked value inside
	// an effect that reads it causes an infinite reactive loop. The effect already
	// re-runs whenever `shouldAnimate` or `root` changes — that's the only reactivity
	// we need; `prevShould` is just a guard against calling onStart on every re-run.
	let prevShould = false;
	effect(() => {
		const host = root.value;
		const active = shouldAnimate.value;
		if (!host) {
			prevShould = active;
			return;
		}

		const wordEls = host.querySelectorAll<HTMLElement>('.words-stagger-word');
		if (wordEls.length === 0) {
			prevShould = active;
			return;
		}

		if (active && !prevShould) {
			onStart?.();
			// Snap to hidden first so there's no flash of the rest state before entry.
			animate(wordEls, { opacity: 0, y: 10, filter: 'blur(10px)' }, { duration: 0 });
			animate(
				wordEls,
				{ opacity: [0, 1], y: [10, 0], filter: ['blur(10px)', 'blur(0px)'] },
				{
					delay: stagger(safeStagger, { from: 'first', startDelay: safeDelay } as any),
					duration: safeSpeed,
					ease: 'easeOut',
				},
			).then(() => onComplete?.());
		} else if (!active) {
			// Snap back to hidden so a subsequent trigger re-animates from scratch.
			animate(wordEls, { opacity: 0, y: 10, filter: 'blur(10px)' }, { duration: 0 });
		}

		prevShould = active;
	});

	<>
	<{Tag}
		ref={(el: HTMLElement | null) => {
			root.value = el;
			if (triggerOnView) inView.ref(el);
		}}
		class={cn('whitespace-nowrap', className)}
		{...rest}
	>
		{/* Accessible plain-text for screen readers */}
		<span class="sr-only">{text}</span>

		<span aria-hidden="true">
			@for (const token of tokens.value; ) {
				@if (token.kind === 'word') {
					<span class="words-stagger-word inline-block">{token.content}</span>
				} @else {
					<span class="whitespace-pre-wrap">{token.value}</span>
				}
			}
		</span>
	</{Tag}>
	</>
}
