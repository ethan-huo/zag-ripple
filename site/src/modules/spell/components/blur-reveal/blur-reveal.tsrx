import { effect, track } from 'ripple';
import { animate, stagger, useInView } from '@/lib/motion';
import { splitGraphemes } from '@/lib/text-utils';
import { cn } from '@/lib/utils';

// Animates text character-by-character: each character fades in from blurred +
// shifted to clear, staggered across the whole string. Mirrors the speed-based
// API of the Svelte source (speedReveal / speedSegment convert to concrete
// timing values). triggerOnView wires IntersectionObserver via useInView so it
// never touches the DOM at SSR time.

type CharacterUnit = { value: string; index: number };

type RenderToken =
	| { kind: 'word'; id: string; characters: CharacterUnit[] }
	| { kind: 'space'; id: string; value: string; index: number };

function buildTokens(text: string): RenderToken[] {
	const entries = text.match(/\S+|\s+/g) ?? [];
	const renderTokens: RenderToken[] = [];
	let cursor = 0;

	for (const [tokenIndex, token] of entries.entries()) {
		if (/^\s+$/.test(token)) {
			renderTokens.push({ kind: 'space', id: `space-${tokenIndex}`, value: token, index: cursor });
			cursor += 1;
			continue;
		}
		const characters = splitGraphemes(token).map((value, i) => ({ value, index: cursor + i }));
		cursor += characters.length;
		renderTokens.push({ kind: 'word', id: `word-${tokenIndex}`, characters });
	}

	return renderTokens;
}

export function BlurReveal({
	text,
	as: Tag = 'p',
	delay = 0,
	speedReveal = 1.5,
	speedSegment = 0.5,
	stagger: staggerProp,
	duration: durationProp,
	trigger = true,
	triggerOnView = false,
	once = true,
	letterSpacing,
	class: className,
	onStart,
	onComplete,
	...rest
}: any) @{
	// Speed params converted to concrete timing values, matching the source's API.
	const safeDelay = Math.max(delay ?? 0, 0);
	const safeSpeedReveal = Math.max(speedReveal ?? 1.5, 0.01);
	const safeSpeedSegment = Math.max(speedSegment ?? 0.5, 0.01);
	const resolvedStagger = staggerProp === undefined
		? 0.03 / safeSpeedReveal
		: Math.max(staggerProp, 0);
	const resolvedDuration = durationProp === undefined
		? 0.3 / safeSpeedSegment
		: Math.max(durationProp, 0.01);
	const letterSpacingValue = letterSpacing === undefined
		? undefined
		: typeof letterSpacing === 'number' ? `${letterSpacing}px` : String(letterSpacing);

	// Tokens computed from plain text — pure, SSR-safe.
	const tokens = track(() => buildTokens(String(text ?? '')));

	const root = track<HTMLElement | null>(null);

	// useInView is SSR-safe (effect-guarded internally); ref is attached at render.
	const inView = useInView({ once, amount: 0.2 });

	const shouldAnimate = track(() => {
		const count = tokens.value.reduce(
			(n, t) => n + (t.kind === 'word' ? t.characters.length : 1),
			0,
		);
		if (count === 0 || !trigger) return false;
		return triggerOnView ? inView.visible.value : true;
	});

	// Drive the staggered blur → clear animation whenever shouldAnimate flips.
	effect(() => {
		const host = root.value;
		const active = shouldAnimate.value;
		if (!host) return;

		const chars = host.querySelectorAll<HTMLElement>('.blur-reveal-char');
		if (chars.length === 0) return;

		if (active) {
			onStart?.();
			animate(
				chars,
				{ opacity: [0, 1], filter: ['blur(12px)', 'blur(0px)'], y: [10, 0] },
				{
					delay: stagger(resolvedStagger, { from: 'first', startDelay: safeDelay } as any),
					duration: resolvedDuration,
					ease: 'easeOut',
				},
			).then(() => {
				onComplete?.();
			});
		} else {
			// Snap hidden so re-triggers start from the correct initial state.
			animate(chars, { opacity: 0, filter: 'blur(12px)', y: 10 }, { duration: 0 });
		}
	});

	<>
	<{Tag}
		ref={(el: HTMLElement | null) => {
			root.value = el;
			if (triggerOnView) inView.ref(el);
		}}
		class={cn('whitespace-pre-wrap', className)}
		{...rest}
	>
		{/* Accessible text for screen readers */}
		<span class="sr-only">{text}</span>

		{/* Aria-hidden character-by-character render */}
		<span aria-hidden="true">
			@for (const token of tokens.value; ) {
				@if (token.kind === 'word') {
					<span class="inline-block whitespace-nowrap">
						@for (const char of token.characters; ) {
							<span
								class="blur-reveal-char inline-block"
								style={letterSpacingValue ? `margin-right: ${letterSpacingValue}` : undefined}
							>{char.value}</span>
						}
					</span>
				} @else {
					<span
						class="blur-reveal-char inline-block whitespace-pre"
					>{token.value}</span>
				}
			}
		</span>
	</{Tag}>
	</>
}
