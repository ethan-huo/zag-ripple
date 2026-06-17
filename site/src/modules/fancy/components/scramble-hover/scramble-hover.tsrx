import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';
import { splitGraphemes } from '@/lib/text-utils';

// On hover, unrevealed characters cycle through random glyphs and progressively
// settle to the real text. Pure interval logic — no motion engine needed.
const DEFAULT_CHARACTERS =
	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()_+';

const isWhitespace = (segment: string) => /^\s+$/.test(segment);

function shuffleArray<T>(items: T[]) {
	for (let i = items.length - 1; i > 0; i -= 1) {
		const r = Math.floor(Math.random() * (i + 1));
		[items[i], items[r]] = [items[r], items[i]];
	}
	return items;
}

export function ScrambleHover({
	text,
	scrambleSpeed = 50,
	maxIterations = 10,
	sequential = false,
	revealDirection = 'start',
	useOriginalCharsOnly = false,
	characters = DEFAULT_CHARACTERS,
	class: className,
	scrambledClass,
	...props
}: any) @{
	const sourceSegments = track(() => splitGraphemes(text));
	const availableCharacters = track(() => {
		if (useOriginalCharsOnly) {
			return Array.from(new Set(sourceSegments.value.filter((s) => !isWhitespace(s))));
		}
		const provided = splitGraphemes(characters).filter((s) => !isWhitespace(s));
		if (provided.length > 0) return provided;
		return Array.from(new Set(sourceSegments.value.filter((s) => !isWhitespace(s))));
	});

	const displaySegments = track<string[]>([]);
	const isHovering = track(false);
	const isScrambling = track(false);
	const revealed = new Set<number>();
	const rendered = track(() => (isScrambling.value ? displaySegments.value : sourceSegments.value));

	let intervalId: ReturnType<typeof setInterval> | null = null;
	const clearTick = () => {
		if (intervalId !== null) {
			clearInterval(intervalId);
			intervalId = null;
		}
	};

	const pickRandom = (pool: string[], fallback: string) =>
		pool.length === 0 ? fallback : pool[Math.floor(Math.random() * pool.length)] ?? fallback;

	function getNextRevealIndex(length: number) {
		switch (revealDirection) {
			case 'end':
				return length - 1 - revealed.size;
			case 'center': {
				const middle = Math.floor(length / 2);
				const offset = Math.floor(revealed.size / 2);
				const next = revealed.size % 2 === 0 ? middle + offset : middle - offset - 1;
				if (next >= 0 && next < length && !revealed.has(next)) return next;
				for (let i = 0; i < length; i += 1) if (!revealed.has(i)) return i;
				return 0;
			}
			default:
				return revealed.size;
		}
	}

	function scrambleSegments(segments: string[], pool: string[], originalOnly: boolean) {
		if (originalOnly) {
			const positions = segments.map((segment, index) => ({
				segment,
				index,
				ws: isWhitespace(segment),
				rev: revealed.has(index),
			}));
			const scrambled = shuffleArray(
				positions.filter((p) => !p.ws && !p.rev).map((p) => p.segment),
			);
			let n = 0;
			return positions.map((p) => {
				if (p.ws) return p.segment;
				if (p.rev) return segments[p.index];
				const c = scrambled[n];
				n += 1;
				return c ?? p.segment;
			});
		}
		return segments.map((segment, index) => {
			if (isWhitespace(segment)) return segment;
			if (revealed.has(index)) return segments[index];
			return pickRandom(pool, segment);
		});
	}

	function isCharacterScrambled(index: number) {
		const segment = sourceSegments.value[index];
		if (!segment || isWhitespace(segment)) return false;
		return isHovering.value && isScrambling.value && !revealed.has(index);
	}

	effect(() => {
		const segments = sourceSegments.value;
		const pool = availableCharacters.value;

		if (segments.length === 0 || !isHovering.value) {
			clearTick();
			revealed.clear();
			isScrambling.value = false;
			displaySegments.value = [...segments];
			return;
		}

		revealed.clear();
		displaySegments.value = [...segments];
		isScrambling.value = true;

		if (!sequential && maxIterations <= 0) {
			isScrambling.value = false;
			return;
		}

		let iteration = 0;
		intervalId = setInterval(() => {
			if (sequential) {
				if (revealed.size < segments.length) {
					revealed.add(getNextRevealIndex(segments.length));
					displaySegments.value = scrambleSegments(segments, pool, useOriginalCharsOnly);
					if (revealed.size >= segments.length) {
						clearTick();
						isScrambling.value = false;
					}
					return;
				}
				clearTick();
				isScrambling.value = false;
				displaySegments.value = [...segments];
				return;
			}

			displaySegments.value = scrambleSegments(segments, pool, useOriginalCharsOnly);
			iteration += 1;
			if (iteration >= maxIterations) {
				clearTick();
				isScrambling.value = false;
				displaySegments.value = [...segments];
			}
		}, scrambleSpeed);

		return () => clearTick();
	});

	<>
	<span
		class={cn('inline-block whitespace-pre-wrap', className)}
		onMouseEnter={() => (isHovering.value = true)}
		onMouseLeave={() => {
			isHovering.value = false;
		}}
		{...props}
	>
		<span class="sr-only">{text}</span>
		<span aria-hidden="true">
			@for (const segment of rendered.value; index i) {
				<span class={isCharacterScrambled(i) ? scrambledClass : undefined}>{segment}</span>
			}
		</span>
	</span>
	</>
}
