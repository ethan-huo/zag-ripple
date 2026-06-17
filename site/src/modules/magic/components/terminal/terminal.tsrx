import { effect, track, type Tracked } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';
import { inView } from 'motion';

// ─── Sequence coordination ──────────────────────────────────────────────────
// Svelte's version uses setContext/getContext to pass the sequence object to
// arbitrary child components. TSRX has no context system, so the sequence is
// an explicit reactive object created by `createTerminalSequence()` and passed
// as a prop to AnimatedSpan / TypingAnimation. Terminal also receives it to
// trigger the sequence once the container scrolls into view.

export type TerminalSequence = {
	activeIndex: Tracked<number>;
	sequenceStarted: Tracked<boolean>;
	completeItem: (index: number) => void;
};

/** Create a shared sequence object and pass it to every AnimatedSpan / TypingAnimation inside the Terminal. */
export function createTerminalSequence(): TerminalSequence {
	const activeIndex = track(0);
	const sequenceStarted = track(false);
	return {
		activeIndex,
		sequenceStarted,
		completeItem: (index: number) => {
			if (activeIndex.value === index) {
				activeIndex.value = index + 1;
			}
		},
	};
}

// ─── Terminal ───────────────────────────────────────────────────────────────
// Renders a macOS-style terminal window. When `sequence` is provided it starts
// the sequence once the container enters the viewport (or immediately when
// `startOnView` is false).
export function Terminal({
	children,
	class: className,
	sequence,
	startOnView = true,
}: any) @{
	let containerNode = track<HTMLElement | null>(null);

	effect(() => {
		const el = containerNode.value;
		if (!el || !sequence) return;

		if (!startOnView) {
			sequence.sequenceStarted.value = true;
			return;
		}

		// Only start the sequence once the terminal scrolls 30% into view.
		// Uses the same 0.3 threshold as the Svelte IntersectionObserver source.
		return inView(
			el,
			() => {
				sequence.sequenceStarted.value = true;
			},
			{ amount: 0.3 },
		) as unknown as () => void;
	});

	<>
	<div
		ref={(el) => { containerNode.value = el; }}
		class={cn(
			'border-border bg-background z-0 h-full max-h-[400px] w-full max-w-lg rounded-xl border',
			className,
		)}
	>
		<div class="border-border flex flex-col gap-y-2 border-b p-4">
			<div class="flex flex-row gap-x-2">
				<div class="h-2 w-2 rounded-full bg-red-500" />
				<div class="h-2 w-2 rounded-full bg-yellow-500" />
				<div class="h-2 w-2 rounded-full bg-green-500" />
			</div>
		</div>
		<pre class="p-4">
			<code class="grid gap-y-1 overflow-auto">{children}</code>
		</pre>
	</div>
	</>
}

// ─── AnimatedSpan ────────────────────────────────────────────────────────────
// Fades and slides in once its turn in the sequence arrives (or immediately
// when no sequence is used). `itemIndex` must match the insertion order.
export function AnimatedSpan({
	children,
	delay = 0,
	class: className,
	startOnView = false,
	itemIndex,
	sequence,
}: any) @{
	let containerNode = track<HTMLElement | null>(null);
	let innerNode = track<HTMLElement | null>(null);
	const hasStarted = track(false);
	const isInView = track(false);

	// Determine whether this item should be visible. Mirrors the Svelte $derived.
	const shouldAnimate = track(() => {
		if (sequence && itemIndex !== undefined) return hasStarted.value;
		if (startOnView) return isInView.value;
		return true;
	});

	effect(() => {
		const el = containerNode.value;
		if (!el) return;

		if (!sequence && startOnView) {
			// IntersectionObserver managed inside effect (SSR-safe).
			return inView(
				el,
				() => { isInView.value = true; },
				{ amount: 0.3 },
			) as unknown as () => void;
		}

		if (!sequence && !startOnView) {
			isInView.value = true;
		}
	});

	// Watch for the sequence to reach this item's turn.
	effect(() => {
		if (!sequence || itemIndex === undefined) return;
		if (!sequence.sequenceStarted.value) return;
		if (hasStarted.value) return;
		if (sequence.activeIndex.value === itemIndex) {
			hasStarted.value = true;
		}
	});

	// Animate the inner element whenever shouldAnimate flips to true.
	effect(() => {
		const el = innerNode.value;
		if (!el) return;

		if (shouldAnimate.value) {
			const delaySeconds = sequence ? 0 : delay / 1000;
			animate(
				el,
				{ opacity: [0, 1], y: [-5, 0] },
				{ duration: 0.3, delay: delaySeconds },
			).then(() => {
				// Notify Terminal that this item finished so the next one starts.
				if (sequence && itemIndex !== undefined) {
					sequence.completeItem(itemIndex);
				}
			});
		} else {
			// Hold at initial state until the sequence reaches this item.
			animate(el, { opacity: 0, y: -5 }, { duration: 0 });
		}
	});

	<>
	<div ref={(el) => { containerNode.value = el; }}>
		<div
			ref={(el) => { innerNode.value = el; }}
			class={cn('grid text-sm font-normal tracking-tight', className)}
		>
			{children}
		</div>
	</div>
	</>
}

// ─── TypingAnimation ─────────────────────────────────────────────────────────
// Types `text` one character at a time. When a `sequence` is provided it waits
// for its `itemIndex` turn; otherwise it can trigger on view or immediately.
export function TypingAnimation({
	text,
	class: className,
	duration = 60,
	delay = 0,
	startOnView = true,
	itemIndex,
	sequence,
}: any) @{
	let containerNode = track<HTMLElement | null>(null);
	const displayedText = track('');
	const started = track(false);
	const isInView = track(false);

	// In-view observer (only when no sequence and startOnView is true).
	effect(() => {
		const el = containerNode.value;
		if (!el || sequence || !startOnView) return;

		return inView(
			el,
			() => { isInView.value = true; },
			{ amount: 0.3 },
		) as unknown as () => void;
	});

	// Trigger `started` when conditions are met.
	effect(() => {
		if (started.value) return;

		if (sequence && itemIndex !== undefined) {
			if (!sequence.sequenceStarted.value) return;
			if (sequence.activeIndex.value !== itemIndex) return;
			started.value = true;
			return;
		}

		if (!startOnView) {
			const t = setTimeout(() => { started.value = true; }, delay);
			return () => clearTimeout(t);
		}

		if (!isInView.value) return;

		const t = setTimeout(() => { started.value = true; }, delay);
		return () => clearTimeout(t);
	});

	// Run the typing interval once started.
	effect(() => {
		if (!started.value) return;

		let i = 0;
		const textToType = text;
		const id = setInterval(() => {
			if (i < textToType.length) {
				displayedText.value = textToType.substring(0, i + 1);
				i++;
			} else {
				clearInterval(id);
				if (sequence && itemIndex !== undefined) {
					sequence.completeItem(itemIndex);
				}
			}
		}, duration);

		return () => clearInterval(id);
	});

	<>
	<div ref={(el) => { containerNode.value = el; }}>
		<span class={cn('text-sm font-normal tracking-tight', className)}>
			{displayedText.value}
		</span>
	</div>
	</>
}
