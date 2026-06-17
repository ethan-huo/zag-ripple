import { effect, track } from 'ripple';
import { animate, useInView } from '@/lib/motion';
import { segmentText, splitGraphemes } from '@/lib/text-utils';
import { cn } from '@/lib/utils';

// Each unit (word, character, or line) is clipped by an overflow-hidden wrapper
// and animated from y="100%" to y=0 — the classic "slide up from below the fold"
// reveal. The hidden <span> holds the original text for screen readers; the
// visible span is aria-hidden and built from split tokens. We use the
// `animate(NodeList, ...)` path (like blur-reveal) rather than per-element
// <Motion> wrappers so stagger config stays in one place and isn't duplicated
// across potentially hundreds of character nodes.

type SplitMode = 'words' | 'characters' | 'lines';
type StaggerFrom = 'first' | 'last' | 'center';

type CharacterUnit = { id: string; value: string; index: number };
type RenderItem =
	| { kind: 'group'; id: string; characters: CharacterUnit[] }
	| { kind: 'whitespace'; id: string; value: string; index: number };

const defaultEase = [0.625, 0.05, 0, 1] as const;

function buildItems(text: string, split: SplitMode): RenderItem[] {
	if (!text) return [];

	if (split === 'lines') {
		return text.split('\n').map((line, index) => ({
			kind: 'group' as const,
			id: `line-${index}`,
			characters: [{ id: `line-${index}-0`, value: line || ' ', index }],
		}));
	}

	const items: RenderItem[] = [];
	let cursor = 0;

	for (const [tokenIndex, token] of segmentText(text).entries()) {
		if (token.kind === 'whitespace') {
			items.push({ kind: 'whitespace', id: `ws-${tokenIndex}`, value: token.value, index: cursor });
			cursor += 1;
			continue;
		}

		const characters =
			split === 'characters'
				? splitGraphemes(token.value).map((value, i) => ({
						id: `t${tokenIndex}-c${i}`,
						value,
						index: cursor + i,
					}))
				: [{ id: `t${tokenIndex}-c0`, value: token.value, index: cursor }];

		cursor += characters.length;
		items.push({ kind: 'group', id: `g-${tokenIndex}`, characters });
	}

	return items;
}

function computeStaggerDelay(index: number, total: number, from: StaggerFrom, staggerStep: number) {
	if (from === 'last') return Math.max(0, total - 1 - index) * staggerStep;
	if (from === 'center') return Math.abs(Math.floor(total / 2) - index) * staggerStep;
	return index * staggerStep;
}

export function SlideUpText({
	children,
	text,
	split = 'words',
	delay = 0,
	stagger: staggerStep = 0.1,
	from = 'first',
	duration = 0.5,
	ease = defaultEase,
	wordClass,
	charClass,
	autoStart = true,
	triggerOnView = false,
	once = true,
	onStart,
	onComplete,
	class: className,
	...rest
}: any) @{
	// When the caller passes a string via `text`, use it directly.
	// When `children` is a plain string (static render), use that.
	// We resolve to a plain string — no MutationObserver needed because
	// Ripple re-renders deterministically when reactive props change.
	const resolvedText = track(() => {
		if (typeof text === 'string') return text;
		if (typeof children === 'string') return children;
		return '';
	});

	const items = track(() => buildItems(resolvedText.value, split));

	const totalUnits = track(() =>
		items.value.reduce((n, item) => n + (item.kind === 'group' ? item.characters.length : 1), 0),
	);

	// Root node ref — used both as the viewport anchor (triggerOnView) and to
	// query all animated character nodes imperatively after render.
	const root = track<HTMLElement | null>(null);

	// useInView is effect-guarded internally; safe to call unconditionally here.
	const inViewHook = useInView({ once, amount: 0.2 });

	// Whether the reveal animation should currently be playing.
	const isAnimating = track(false);

	const shouldAnimate = track(
		() => totalUnits.value > 0 && isAnimating.value,
	);

	// Auto-start (non-view-triggered path).
	effect(() => {
		if (!autoStart || triggerOnView || !resolvedText.value) return;
		isAnimating.value = true;
	});

	// View-triggered path — mirrors the Svelte source's `$effect` on `isInView`.
	effect(() => {
		if (!triggerOnView) return;
		const visible = inViewHook.visible.value;
		if (visible && resolvedText.value) {
			isAnimating.value = true;
		} else if (!visible && !once) {
			isAnimating.value = false;
		}
	});

	// Drive the actual DOM animation imperatively so stagger delay per unit can
	// be computed in JS without creating one Motion element per character node.
	effect(() => {
		const host = root.value;
		const active = shouldAnimate.value;
		if (!host) return;

		const nodes = host.querySelectorAll<HTMLElement>('.slide-up-text-unit');
		if (nodes.length === 0) return;

		const total = totalUnits.value;

		if (active) {
			onStart?.();
			// Animate each node with its own computed stagger delay because the
			// `stagger()` helper works from an index-0 basis and can't express
			// "from last" / "from center" directly. We issue one animate() call per
			// node to keep delay-per-unit exact. The cost is acceptable for typical
			// text lengths.
			const promises: Promise<unknown>[] = [];
			nodes.forEach((node) => {
				const index = Number(node.dataset.index ?? 0);
				const unitDelay = delay + computeStaggerDelay(index, total, from, staggerStep);
				promises.push(
					animate(node, { y: ['100%', '0%'] }, { duration, ease, delay: unitDelay }),
				);
			});
			Promise.all(promises).then(() => onComplete?.());
		} else {
			// Snap every unit back behind its overflow-hidden clip so replays
			// always start from a clean hidden state.
			animate(nodes, { y: '100%' }, { duration: 0 });
		}
	});

	<>
	<span
		ref={(el: HTMLElement | null) => {
			root.value = el;
			if (triggerOnView) inViewHook.ref(el);
		}}
		class={cn(
			split === 'lines' ? 'inline-flex flex-col items-start' : 'whitespace-nowrap',
			className,
		)}
		{...rest}
	>
		{/* Screen-reader text — holds original children/text unchanged */}
		<span class="sr-only">{children ?? text}</span>

		{/* Aria-hidden: the visually animated layer */}
		<span aria-hidden="true">
			@for (const item of items.value; ) {
				@if (item.kind === 'group') {
					<span class={cn('inline-flex overflow-hidden whitespace-pre-wrap', wordClass)}>
						@for (const char of item.characters; ) {
							<span class={cn('relative overflow-hidden whitespace-pre-wrap', charClass)}>
								<span
									class="slide-up-text-unit inline-block whitespace-pre-wrap"
									data-index={String(char.index)}
									style="transform: translateY(100%)"
								>{char.value}</span>
							</span>
						}
					</span>
				} @else {
					<span class="relative overflow-hidden whitespace-pre-wrap">
						<span
							class="slide-up-text-unit inline-block whitespace-pre-wrap"
							data-index={String(item.index)}
							style="transform: translateY(100%)"
						>{item.value}</span>
					</span>
				}
			}
		</span>
	</span>
	</>
}
