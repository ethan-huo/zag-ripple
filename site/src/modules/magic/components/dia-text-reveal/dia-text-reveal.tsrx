import { effect, track } from 'ripple';
import { animate, useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Ported from SikandarJODD/animations (motion-sv) → Ripple.
//
// motion-sv's useMotionValue + useTransform pipeline is replaced by motion's
// value-animate overload: animate(number, [from, to], { onUpdate }) fires on
// every frame and lets us write the computed gradient directly to the element's
// inline style — no MotionValue abstraction needed.

const DEFAULT_COLORS = ['#c679c4', '#fa3d1d', '#ffb005', '#e1e1fe', '#0358f7'];
const BAND_HALF = 17;
const SWEEP_START = -BAND_HALF;
const SWEEP_END = 100 + BAND_HALF;

// Custom cubic ease: ease-in-out-cubic (matches source sweepEase).
const sweepEase = (t: number) => (t < 0.5 ? 4 * t ** 3 : 1 - (-2 * t + 2) ** 3 / 2);

function buildGradient(pos: number, colors: string[], textColor: string): string {
	const bandStart = pos - BAND_HALF;
	const bandEnd = pos + BAND_HALF;

	if (bandStart >= 100) {
		return `linear-gradient(90deg, ${textColor}, ${textColor})`;
	}

	const count = colors.length;
	const parts: string[] = [];

	if (bandStart > 0) {
		parts.push(`${textColor} 0%`, `${textColor} ${bandStart.toFixed(2)}%`);
	}

	colors.forEach((color, index) => {
		const pct = count === 1 ? pos : bandStart + (index / (count - 1)) * BAND_HALF * 2;
		parts.push(`${color} ${pct.toFixed(2)}%`);
	});

	if (bandEnd < 100) {
		parts.push(`transparent ${bandEnd.toFixed(2)}%`, 'transparent 100%');
	}

	return `linear-gradient(90deg, ${parts.join(', ')})`;
}

// Measures the pixel width of each text string using a hidden ghost clone of
// the span element. Must only be called from within an effect (DOM access).
function measureWidths(element: HTMLElement, texts: string[]): number[] {
	const ghost = element.cloneNode() as HTMLElement;
	Object.assign(ghost.style, {
		position: 'absolute',
		visibility: 'hidden',
		pointerEvents: 'none',
		width: 'auto',
		whiteSpace: 'nowrap',
	});
	element.parentElement?.appendChild(ghost);
	const widths = texts.map((t) => {
		ghost.textContent = t;
		return ghost.getBoundingClientRect().width;
	});
	ghost.remove();
	return widths;
}

export function DiaTextReveal({
	text,
	colors = DEFAULT_COLORS,
	textColor = 'var(--foreground)',
	duration = 1.5,
	delay = 0,
	repeat = false,
	repeatDelay = 0.5,
	triggerOnView = true,
	once = true,
	fixedWidth = false,
	class: className,
	...props
}: any) @{
	const texts = track(() => (Array.isArray(text) ? text : [text]));
	const isMulti = track(() => texts.value.length > 1);

	const activeIndex = track(0);
	const measuredWidths = track<number[]>([]);

	// Ripple equivalent of useInView. When triggerOnView is false the element
	// is always "visible" — we simulate that by using once=false and triggering
	// immediately via a separate flag instead.
	const { ref: inViewRef, visible } = useInView({ once, amount: 0.1 });

	let spanNode = track<HTMLSpanElement | null>(null);

	// Mutable refs (not tracked) — animation loop bookkeeping that should not
	// trigger reactive re-renders when they change.
	let indexRef = 0;
	let hasPlayed = false;
	let timerRef: ReturnType<typeof setTimeout> | undefined;
	let controls: { stop(): void } | undefined;

	function clearCycle() {
		controls?.stop();
		controls = undefined;
		clearTimeout(timerRef);
		timerRef = undefined;
	}

	// Sets the sweep gradient on the element imperatively on each frame.
	// Using direct style writes avoids an extra tracked dependency that would
	// re-render the component on every animation tick.
	function applyGradient(el: HTMLElement, pos: number) {
		el.style.backgroundImage = buildGradient(pos, colors, textColor);
	}

	function play(el: HTMLElement) {
		clearCycle();
		// Reset to starting position before each sweep.
		applyGradient(el, SWEEP_START);

		// animate(value, keyframes, options) — value-animate overload from motion.
		// onUpdate fires on each rAF; onComplete handles the repeat loop.
		controls = animate(SWEEP_START, [SWEEP_START, SWEEP_END], {
			duration,
			delay,
			ease: sweepEase,
			onUpdate(pos: number) {
				applyGradient(el, pos);
			},
			onComplete() {
				if (!repeat || texts.value.length === 0) return;
				timerRef = setTimeout(() => {
					const next = (indexRef + 1) % texts.value.length;
					indexRef = next;
					activeIndex.value = next;
					// Re-read the span after the reactive text swap.
					const freshEl = spanNode.value;
					if (freshEl) play(freshEl);
				}, repeatDelay * 1000);
			},
		} as any);
	}

	// Measure widths of all text variants so we can animate the span's width
	// during cycling (prevents layout jumps) or lock it to the maximum.
	effect(() => {
		const el = spanNode.value;
		if (!el || !isMulti.value) {
			measuredWidths.value = [];
			return;
		}
		// Consume texts.value so this effect re-runs when the text list changes.
		const ts = texts.value;
		measuredWidths.value = measureWidths(el, ts);
	});

	// Apply fixed-width imperatively once measurements land (DOM-only, effect-safe).
	effect(() => {
		if (!isMulti.value || !fixedWidth) return;
		const el = spanNode.value;
		const ws = measuredWidths.value;
		if (!el || ws.length === 0) return;
		el.style.width = `${Math.max(...ws)}px`;
	});

	// Animate the span's width when cycling through multi-text (non-fixed mode).
	effect(() => {
		if (!isMulti.value || fixedWidth) return;
		const el = spanNode.value;
		const w = measuredWidths.value[activeIndex.value];
		if (!el || w == null) return;
		animate(el, { width: w }, { duration: 0.4, ease: [0.4, 0, 0.2, 1] });
	});

	// Main trigger: start the sweep when the element enters the viewport (or
	// immediately when triggerOnView is false).
	effect(() => {
		const el = spanNode.value;
		if (!el) return;

		const isVisible = triggerOnView ? visible.value : true;
		if (!isVisible) {
			if (!once) hasPlayed = false;
			return;
		}
		if (once && hasPlayed) return;
		hasPlayed = true;
		play(el);
		return clearCycle;
	});

	// Structural inline styles that must be present from first render (SSR-safe).
	// backgroundImage starts at SWEEP_START (transparent band at -17%) and is
	// overwritten per-frame by applyGradient once the animation runs client-side.
	// Width for multi-text is handled imperatively in effects above.
	const baseStyle = [
		'color: transparent',
		'background-clip: text',
		'-webkit-background-clip: text',
		'background-size: 100% 100%',
		`background-image: ${buildGradient(SWEEP_START, colors, textColor)}`,
		'transform: translateY(-2px)',
		// Multi-text needs block formatting so the element has an explicit width to animate.
		...(isMulti.value ? ['display: inline-block', 'overflow: hidden', 'white-space: nowrap', 'vertical-align: text-bottom'] : []),
	].join('; ');

	<>
	<span
		ref={(el) => {
			spanNode.value = el;
			inViewRef(el);
		}}
		class={cn('align-bottom leading-[100%] text-inherit', className)}
		style={baseStyle}
		{...props}
	>
		{texts.value[activeIndex.value]}
	</span>
	</>
}
