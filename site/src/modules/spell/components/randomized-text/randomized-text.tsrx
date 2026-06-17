import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';
import { splitGraphemes, segmentText } from '@/lib/text-utils';

// Each text segment (word or char) fades in independently with a staggered
// delay derived from a deterministic hash so re-renders produce the same order.
// The source component reads text from children via MutationObserver; here we
// accept a `text` prop instead — simpler and SSR-safe (no DOM read at render).

type SplitType = 'words' | 'chars';

type RandomizedToken =
	| { kind: 'segment'; id: string; content: string; delay: number }
	| { kind: 'whitespace'; id: string; value: string };

function hashString(value: string, seed: number): number {
	let hash = seed >>> 0;
	for (let i = 0; i < value.length; i += 1) {
		hash ^= value.charCodeAt(i);
		hash = Math.imul(hash, 16777619);
	}
	return hash >>> 0;
}

function normalizedHash(value: string, seed: number): number {
	return hashString(value, seed) / 4294967295;
}

function createStableDelay(signature: string, baseDelay: number): number {
	return baseDelay + normalizedHash(signature, 2166136261) * 0.2 + normalizedHash(signature, 2654435761) * 0.03;
}

// expoOut easing as a cubic-bezier approximation accepted by motion's ease option.
const expoOut = (t: number) => (t === 1 ? 1 : 1 - Math.pow(2, -10 * t));

function buildTokens(sourceText: string, split: SplitType, baseDelay: number): RandomizedToken[] {
	if (!sourceText) return [];

	if (split === 'chars') {
		let segIdx = 0;
		return splitGraphemes(sourceText).map((seg, i) => {
			if (/^\s+$/.test(seg)) {
				return { kind: 'whitespace', id: `space-${i}`, value: seg };
			}
			const token: RandomizedToken = {
				kind: 'segment',
				id: `char-${i}`,
				content: seg,
				delay: createStableDelay(`chars:${segIdx}:${seg}:${sourceText}`, baseDelay),
			};
			segIdx += 1;
			return token;
		});
	}

	let segIdx = 0;
	return segmentText(sourceText).map((tok, i) => {
		if (tok.kind === 'whitespace') {
			return { kind: 'whitespace', id: `space-${i}`, value: tok.value };
		}
		const token: RandomizedToken = {
			kind: 'segment',
			id: `word-${i}`,
			content: tok.value,
			delay: createStableDelay(`words:${segIdx}:${tok.value}:${sourceText}`, baseDelay),
		};
		segIdx += 1;
		return token;
	});
}

export function RandomizedText({
	text = '',
	split = 'words',
	delay = 0.2,
	duration = 1.2,
	trigger = true,
	triggerOnView = false,
	once = true,
	class: className,
	style,
}: any) @{
	const safeDelay = track(() => Math.max(delay, 0));
	const safeDuration = track(() => Math.max(duration, 0.01));
	const tokens = track(() => buildTokens(text, split, safeDelay.value));
	const segmentCount = track(() => tokens.value.filter((t) => t.kind === 'segment').length);

	// useInView returns a {ref, visible} pair; we only wire it when triggerOnView
	// is true, otherwise visible is treated as always-true.
	const { ref: inViewRef, visible: inViewVisible } = useInView({ once, amount: 0.2 });

	// nodeRefs maps token id -> DOM node so we can animate each span individually.
	const nodeRefs: Record<string, HTMLElement | null> = {};
	const containerRef = track<HTMLElement | null>(null);

	// Track which token ids have been animated to avoid replaying on reactive re-runs.
	let animatedSet = new Set<string>();

	const shouldAnimate = track(() => {
		if (segmentCount.value === 0 || !trigger) return false;
		return triggerOnView ? inViewVisible.value : true;
	});

	effect(() => {
		if (!shouldAnimate.value) return;

		// Animate each segment span from opacity 0 → 1 with its computed delay.
		for (const token of tokens.value) {
			if (token.kind !== 'segment') continue;
			if (animatedSet.has(token.id)) continue;
			const el = nodeRefs[token.id];
			if (!el) continue;
			animatedSet.add(token.id);
			animate(
				el,
				{ opacity: [0, 1] },
				{ duration: safeDuration.value, delay: token.delay, ease: expoOut },
			);
		}
	});

	// Reset animation state when trigger turns off so re-trigger works.
	effect(() => {
		if (shouldAnimate.value) return;
		animatedSet = new Set<string>();
		for (const token of tokens.value) {
			if (token.kind !== 'segment') continue;
			const el = nodeRefs[token.id];
			if (el) {
				animate(el, { opacity: [0] }, { duration: 0 });
			}
		}
	});

	<>
	<span
		ref={(el) => {
			containerRef.value = el;
			// Also wire the inView ref so intersection fires when triggerOnView is on.
			if (triggerOnView) inViewRef(el);
		}}
		class={cn('inline-block break-words whitespace-pre-line', className)}
		style={style}
	>
		{/* Hidden accessible copy for screen readers */}
		<span class="sr-only">{text}</span>

		{/* Visible animated spans, aria-hidden so SR reads only the copy above */}
		<span aria-hidden="true" class="inline">
			@for (const token of tokens.value; index i) {
				@if (token.kind === 'segment') {
					<span
						ref={(el) => {
							nodeRefs[token.id] = el;
						}}
						class={cn(
							'inline-block',
							split === 'words' ? 'whitespace-nowrap' : undefined,
						)}
						style="opacity: 0;"
					>
						{token.content}
					</span>
				} @else {
					<span aria-hidden="true" class="whitespace-nowrap">{token.value}</span>
				}
			}
		</span>
	</span>
	</>
}
