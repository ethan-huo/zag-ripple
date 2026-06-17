import { track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';
import { segmentText, splitGraphemes } from '@/lib/text-utils';

// Each character lives in a 3D "charbox" — two faces that share the same slot.
// On hover the front face rotates away (staggered), snapping the element to its
// rest transform so the second face is ready for the next hover cycle.
// We accept a `text` prop instead of children + MutationObserver to stay
// SSR-safe and avoid the scope-probe pattern from the Svelte original.

export type RotateDirection = 'top' | 'right' | 'bottom' | 'left';

// Derive per-direction CSS transform strings at render time (pure, SSR-safe).
function getOuterTransform(dir: RotateDirection): string {
	if (dir === 'top' || dir === 'bottom') return 'translateZ(-0.5lh)';
	return 'rotateY(90deg) translateX(50%) rotateY(-90deg)';
}

function getFrontFaceTransform(dir: RotateDirection): string {
	if (dir === 'top' || dir === 'bottom') return 'translateZ(0.5lh)';
	if (dir === 'left') return 'rotateY(90deg) translateX(50%) rotateY(-90deg)';
	return 'rotateY(-90deg) translateX(50%) rotateY(90deg)';
}

function getSecondFaceTransform(dir: RotateDirection): string {
	switch (dir) {
		case 'top':
			return 'rotateX(-90deg) translateZ(0.5lh)';
		case 'right':
			return 'rotateY(90deg) translateX(50%) rotateY(-90deg) translateX(-50%) rotateY(-90deg) translateX(50%)';
		case 'bottom':
			return 'rotateX(90deg) translateZ(0.5lh)';
		case 'left':
			return 'rotateY(90deg) translateX(50%) rotateY(-90deg) translateX(50%) rotateY(-90deg) translateX(50%)';
		default:
			return 'rotateY(90deg) translateZ(1ch)';
	}
}

// The transform applied while hovering (chars fly away).
function getRotationTransform(dir: RotateDirection): string {
	switch (dir) {
		case 'top':
			return 'rotateX(90deg)';
		case 'bottom':
			return 'rotateX(-90deg)';
		case 'left':
		case 'right':
		default:
			return 'rotateY(90deg)';
	}
}

// The resting transform after the hover animation — chars park here, ready for
// the next cycle. Must match `outerTransform` on CharBox.
function getRestTransform(dir: RotateDirection): string {
	if (dir === 'top' || dir === 'bottom') return 'translateZ(-0.5lh)';
	return 'rotateY(90deg) translateX(50%) rotateY(-90deg)';
}

function getStaggerDelay(
	index: number,
	total: number,
	staggerFrom: 'first' | 'last' | 'center' | 'random' | number,
	staggerDuration: number,
): number {
	if (staggerFrom === 'first') return index * staggerDuration;
	if (staggerFrom === 'last') return (total - 1 - index) * staggerDuration;
	if (staggerFrom === 'center') {
		const center = Math.floor(total / 2);
		return Math.abs(center - index) * staggerDuration;
	}
	if (staggerFrom === 'random') {
		const r = Math.floor(Math.random() * total);
		return Math.abs(r - index) * staggerDuration;
	}
	return Math.abs((staggerFrom as number) - index) * staggerDuration;
}

// Individual CharBox sub-component (inlined — not a separate file).
// Manages the two-face 3D structure for one grapheme.
function CharBox({
	char,
	dir,
	frontFaceClass,
	secondFaceClass,
}: {
	char: string;
	dir: RotateDirection;
	frontFaceClass?: string;
	secondFaceClass?: string;
}) @{
	const outer = getOuterTransform(dir);
	const front = getFrontFaceTransform(dir);
	const second = getSecondFaceTransform(dir);

	<>
	<span
		class="letter-3d-swap-char-box-item relative align-top"
		style={`transform: ${outer}; transform-style: preserve-3d;`}
	>
		<span
			class={cn('relative h-lh backface-hidden', frontFaceClass)}
			style={`transform: ${front};`}
		>
			{char}
		</span>
		<span
			class={cn('absolute top-0 left-0 h-lh backface-hidden', secondFaceClass)}
			style={`transform: ${second};`}
		>
			{char}
		</span>
	</span>
	</>
}

export function Letter3DSwap({
	text,
	mainClass,
	frontFaceClass,
	secondFaceClass,
	staggerDuration = 0.05,
	staggerFrom = 'first',
	transition = { type: 'spring', damping: 30, stiffness: 300 },
	rotateDirection = 'right',
	class: className,
	...props
}: any) @{
	// Segment text at render time — pure, SSR-safe.
	const tokens = track(() => segmentText(text ?? ''));

	// Compute per-token character arrays (only for text tokens).
	const tokenChars = track(() =>
		tokens.value.map((tok) =>
			tok.kind === 'text' ? splitGraphemes(tok.value) : null,
		),
	);

	// Total grapheme count for stagger index calculation.
	const totalChars = track(() =>
		tokenChars.value.reduce(
			(sum, chars) => sum + (chars ? chars.length : 0),
			0,
		),
	);

	const rotationTransform = track(() => getRotationTransform(rotateDirection));
	const restTransform = track(() => getRestTransform(rotateDirection));

	let scope = track<HTMLElement | null>(null);
	let isAnimating = false;

	const handleHoverStart = async () => {
		const root = scope.value;
		if (!root || isAnimating || totalChars.value === 0) return;
		isAnimating = true;

		const items = root.querySelectorAll('.letter-3d-swap-char-box-item');
		const n = totalChars.value;
		const delays = Array.from({ length: n }, (_, i) =>
			getStaggerDelay(i, n, staggerFrom, staggerDuration),
		);

		// motion's NodeList overload doesn't accept a per-index delay fn, so fire
		// individual animations and wrap each thenable in a real Promise.
		const wait = (controls: any): Promise<void> =>
			new Promise((resolve) => controls.then(resolve));

		const animations = Array.from(items).map((el, i) =>
			animate(
				el as HTMLElement,
				{ transform: rotationTransform.value },
				{ ...transition, delay: delays[i] },
			),
		);
		await Promise.all(animations.map(wait));

		// Snap all items to rest transform so the second face is now "front".
		Array.from(items).forEach((el) => {
			(el as HTMLElement).style.transform = restTransform.value;
		});

		isAnimating = false;
	};

	const handleHoverEnd = () => {
		// Nothing to reset — the snapped rest state is the next cycle's start.
	};

	<>
	<p
		ref={(el) => {
			scope.value = el;
		}}
		class={cn('relative flex flex-wrap', mainClass, className)}
		onMouseEnter={handleHoverStart}
		onMouseLeave={handleHoverEnd}
		{...props}
	>
		<span class="sr-only">{text}</span>

		@for (const tok of tokens.value; index ti) {
			@if (tok.kind === 'whitespace') {
				<span class="whitespace-pre">{tok.value}</span>
			} @else {
				<span class="inline-flex">
					@for (const char of (tokenChars.value[ti] ?? []); index ci) {
						<CharBox
							char={char}
							dir={rotateDirection}
							frontFaceClass={frontFaceClass}
							secondFaceClass={secondFaceClass}
						/>
					}
				</span>
			}
		}
	</p>
	</>
}
