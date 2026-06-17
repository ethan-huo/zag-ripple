import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';
import { splitGraphemes } from '@/lib/text-utils';

// Rotates through an array of text strings on an interval, animating each
// character in/out with stagger. The Svelte source used AnimatePresence from
// motion-sv; we replicate the enter/exit sequencing manually via animate()
// and querySelectorAll('[data-char]') on a stable scope element — same
// technique as letter-3d-swap.

type StaggerFrom = 'first' | 'last' | 'center' | 'random' | number;

interface RenderGroup {
	characters: string[];
	needsSpace: boolean;
	offset: number;
	key: string;
}

function buildRenderGroups(text: string, seed: number, splitBy: string): RenderGroup[] {
	if (!text) return [];

	if (splitBy === 'characters') {
		const words = text.split(' ');
		let offset = 0;
		return words.map((word, i) => {
			const characters = splitGraphemes(word);
			const g = { characters, needsSpace: i !== words.length - 1, offset, key: `${seed}-${i}-${word}` };
			offset += characters.length;
			return g;
		});
	}

	const segments =
		splitBy === 'words'
			? text.split(' ')
			: splitBy === 'lines'
				? text.replace(/\r\n?/g, '\n').split('\n')
				: text.split(splitBy);

	let offset = 0;
	return segments.map((seg, i) => {
		const g = {
			characters: [seg],
			needsSpace: splitBy === 'words' && i !== segments.length - 1,
			offset,
			key: `${seed}-${i}-${seg}`,
		};
		offset += 1;
		return g;
	});
}

function getStaggerDelay(
	index: number,
	total: number,
	staggerFrom: StaggerFrom,
	staggerDuration: number,
): number {
	const n = Math.max(total, 1);
	if (staggerFrom === 'first') return index * staggerDuration;
	if (staggerFrom === 'last') return (n - 1 - index) * staggerDuration;
	if (staggerFrom === 'center') {
		const center = Math.floor(n / 2);
		return Math.abs(center - index) * staggerDuration;
	}
	if (staggerFrom === 'random') {
		const r = Math.floor(Math.random() * n);
		return Math.abs(r - index) * staggerDuration;
	}
	return Math.abs((staggerFrom as number) - index) * staggerDuration;
}

// Convert spring params to motion/dom easing options. The `motion` library
// from npm ("motion" v11+) supports spring via `type: 'spring'` in AnimationOptions.
function makeTransitionOpts(base: any, delay: number) {
	return { ...base, delay };
}

export function TextRotate({
	texts,
	rotationInterval = 2000,
	initial = { y: '100%', opacity: 0 },
	animate: animateTo = { y: 0, opacity: 1 },
	exit = { y: '-120%', opacity: 0 },
	staggerDuration = 0,
	staggerFrom = 'first',
	transition = { type: 'spring', damping: 25, stiffness: 300 },
	loop = true,
	auto = true,
	splitBy = 'characters',
	onNext,
	mainClassName,
	splitLevelClassName,
	elementLevelClassName,
	class: className,
	...props
}: any) @{
	const currentIndex = track(0);
	// `displayIndex` is what's actually rendered; it lags behind `currentIndex`
	// by one exit animation so the old chars can fly out before new ones fly in.
	const displayIndex = track(0);
	const scope = track<HTMLElement | null>(null);
	// Prevent overlapping transitions.
	let busy = false;

	const currentGroups = track(() =>
		buildRenderGroups(texts[displayIndex.value] ?? '', displayIndex.value, splitBy),
	);

	// Animate all data-char spans found inside `scope` using the given keyframes.
	// Returns a Promise that resolves when the last animation finishes.
	async function animateChars(keyframes: any, baseTransition: any, fromStagger: StaggerFrom) {
		const el = scope.value;
		if (!el) return;
		const chars = el.querySelectorAll('[data-char]');
		const n = chars.length;
		if (n === 0) return;
		const waits = Array.from(chars).map((node, i) => {
			const delay = getStaggerDelay(i, n, fromStagger, staggerDuration);
			const ctrl = animate(node as HTMLElement, keyframes, makeTransitionOpts(baseTransition, delay));
			return new Promise<void>((res) => ctrl.then(res));
		});
		await Promise.all(waits);
	}

	// Run enter animation on newly mounted chars. We snap to `initial` first so
	// there's no flash of the resting state before the entrance plays.
	async function enterChars() {
		const el = scope.value;
		if (!el) return;
		const chars = el.querySelectorAll('[data-char]');
		const n = chars.length;
		if (n === 0) return;
		// Snap all to initial without duration.
		Array.from(chars).forEach((node) => {
			if (initial) animate(node as HTMLElement, initial, { duration: 0 });
		});
		// Then staggered entrance.
		const waits = Array.from(chars).map((node, i) => {
			const delay = getStaggerDelay(i, n, staggerFrom, staggerDuration);
			const ctrl = animate(node as HTMLElement, animateTo, makeTransitionOpts(transition, delay));
			return new Promise<void>((res) => ctrl.then(res));
		});
		await Promise.all(waits);
	}

	async function advance(nextIndex: number) {
		if (busy) return;
		busy = true;
		// 1. Exit current chars.
		await animateChars(exit, transition, staggerFrom);
		// 2. Swap the rendered text.
		displayIndex.value = nextIndex;
		currentIndex.value = nextIndex;
		onNext?.(nextIndex);
		// 3. Let Ripple flush the DOM, then enter new chars.
		//    queueMicrotask ensures we read refs after the re-render.
		await new Promise<void>((res) => queueMicrotask(res));
		await enterChars();
		busy = false;
	}

	// Kick off the entrance animation on first mount.
	effect(() => {
		// Run once on mount — scope.value becoming non-null triggers this.
		const el = scope.value;
		if (!el) return;
		// Small tick to let children render.
		queueMicrotask(() => enterChars());
	});

	// Auto-rotation interval.
	effect(() => {
		if (!auto || !texts || texts.length < 2) return;
		const id = setInterval(() => {
			const ci = currentIndex.value;
			const nextRaw = ci === texts.length - 1 ? (loop ? 0 : ci) : ci + 1;
			if (nextRaw !== ci) advance(nextRaw);
		}, Math.max(0, rotationInterval));
		return () => clearInterval(id);
	});

	<>
	<span
		ref={(el: HTMLElement | null) => {
			scope.value = el;
		}}
		class={cn('relative inline-flex flex-wrap whitespace-pre-wrap', mainClassName, className)}
		{...props}
	>
		<span class="sr-only">{texts[displayIndex.value] ?? ''}</span>

		<span
			aria-hidden="true"
			class={cn('flex flex-wrap', splitBy === 'lines' && 'w-full flex-col')}
		>
			@for (const group of currentGroups.value) {
				<span
					class={cn(
						'inline-flex',
						splitBy === 'lines' && 'w-full',
						splitLevelClassName,
					)}
				>
					@for (const char of group.characters) {
						<span class={cn('overflow-hidden', elementLevelClassName)}>
							<span
								data-char
								class="inline-block"
								style="will-change: transform, opacity;"
							>
								{char}
							</span>
						</span>
					}
					@if (group.needsSpace) {
						<span aria-hidden="true" class="whitespace-pre"> </span>
					}
				</span>
			}
		</span>
	</span>
	</>
}
