import { track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';
import { splitGraphemes } from '@/lib/text-utils';

// Each character is a clipped column with two stacked copies: original (y=0) and
// a duplicate parked below (translateY(100%)). On hover both slide to y=-100%,
// which moves the original out the top and brings the duplicate to y=0 — giving
// the illusion of text scrolling through a slot. Delay is distance-from-hover so
// the animation fans out from the touched letter.
//
// We drive animation imperatively via motion's `animate()` so we can compute
// per-character delays at event time without needing a tracked array of Motion
// components (which would re-mount on every hover change).

export function StaggerText({
	text = 'text',
	as: Tag = 'h3',
	class: className,
	...rest
}: any) @{
	// Grapheme-safe split so emoji and multi-codepoint chars are one cell.
	const chars = track(() => splitGraphemes(text as string));

	const containerRef = track<HTMLElement | null>(null);

	// Animate all character-column spans relative to hoverIndex.
	// `direction` 'in'  → slide to y=-100% (enter hover state)
	//             'out' → slide back to y=0  (leave hover state)
	function animateChars(hoverIndex: number, direction: 'in' | 'out') {
		const container = containerRef.value;
		if (!container) return;
		const columns = container.querySelectorAll<HTMLElement>('[data-char-col]');
		columns.forEach((col, i) => {
			const delay = direction === 'in'
				? Math.abs(hoverIndex - i) * 0.04
				: i * 0.02;
			const inner = col.querySelectorAll<HTMLElement>('[data-char-inner]');
			inner.forEach((span) => {
				animate(span, { y: direction === 'in' ? '-100%' : '0%' }, {
					duration: direction === 'in' ? 0.4 : 0.3,
					ease: 'easeInOut',
					delay,
				});
			});
		});
	}

	// Clipboard: expose the plain text while aria hides the duplicated spans.
	function handleCopy(e: ClipboardEvent) {
		e.preventDefault();
		e.clipboardData?.setData('text/plain', text as string);
	}

	<>
	{/* Screen-reader anchor — the duplicated spans are aria-hidden below. */}
	<h1 class="sr-only">{text}</h1>
	<{Tag}
		ref={(el: HTMLElement | null) => { containerRef.value = el; }}
		class={cn('overflow-clip tracking-wide select-text', className)}
		aria-label={text}
		onCopy={handleCopy}
		{...rest}
	>
		@for (const char of chars.value; index i) {
			<span
				data-char-col
				class="relative inline-flex flex-col overflow-hidden"
				role="presentation"
				onMouseEnter={() => animateChars(i, 'in')}
				onMouseLeave={() => animateChars(i, 'out')}
			>
				{/* Original — starts at y=0, exits upward on hover. */}
				<span data-char-inner aria-hidden="true" class="h-fit select-none">
					{char === ' ' ? ' ' : char}
				</span>
				{/* Copy — parked below the clip via CSS `translate` (independent of `transform`),
					 so motion's y animation via WAAPI/transform does not clobber the baseline offset. */}
				<span
					data-char-inner
					aria-hidden="true"
					class="absolute top-0 left-0 h-fit w-full select-text"
					style="translate: 0 100%;"
				>
					{char === ' ' ? ' ' : char}
				</span>
			</span>
		}
	</{Tag}>
	</>
}
