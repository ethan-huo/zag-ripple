import { effect, track } from 'ripple';
import { animate, stagger, useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Port note: the source uses framer-motion Variants + AnimatePresence. We only
// need the entrance direction (no keyed child swap), so we flatten each variant's
// hidden/show states into a direct [from, to] keyframe pair and drive a single
// staggered `animate(els, keyframes, { delay: stagger(…) })` call. querySelectorAll
// on a stable class is simpler and more GC-friendly than maintaining a ref array.

export type AnimationType = 'text' | 'word' | 'character' | 'line';

export type AnimationVariant =
	| 'fadeIn'
	| 'blurIn'
	| 'blurInUp'
	| 'blurInDown'
	| 'slideUp'
	| 'slideDown'
	| 'slideLeft'
	| 'slideRight'
	| 'scaleUp'
	| 'scaleDown';

type Keyframes = Record<string, unknown[]>;
type Transition = Record<string, unknown>;

const presets: Record<AnimationVariant, { keyframes: Keyframes; transition: Transition }> = {
	fadeIn: {
		keyframes: { opacity: [0, 1], y: [20, 0] },
		transition: { duration: 0.3 },
	},
	blurIn: {
		keyframes: { opacity: [0, 1], filter: ['blur(10px)', 'blur(0px)'] },
		transition: { duration: 0.3 },
	},
	blurInUp: {
		keyframes: { opacity: [0, 1], filter: ['blur(10px)', 'blur(0px)'], y: [20, 0] },
		transition: { duration: 0.4 },
	},
	blurInDown: {
		keyframes: { opacity: [0, 1], filter: ['blur(10px)', 'blur(0px)'], y: [-20, 0] },
		transition: { duration: 0.4 },
	},
	slideUp: {
		keyframes: { y: [20, 0], opacity: [0, 1] },
		transition: { duration: 0.3 },
	},
	slideDown: {
		keyframes: { y: [-20, 0], opacity: [0, 1] },
		transition: { duration: 0.3 },
	},
	slideLeft: {
		keyframes: { x: [20, 0], opacity: [0, 1] },
		transition: { duration: 0.3 },
	},
	slideRight: {
		keyframes: { x: [-20, 0], opacity: [0, 1] },
		transition: { duration: 0.3 },
	},
	scaleUp: {
		keyframes: { scale: [0.5, 1], opacity: [0, 1] },
		transition: { duration: 0.3, scale: { type: 'spring', damping: 15, stiffness: 300 } },
	},
	scaleDown: {
		keyframes: { scale: [1.5, 1], opacity: [0, 1] },
		transition: { duration: 0.3, scale: { type: 'spring', damping: 15, stiffness: 300 } },
	},
};

// Split text into ordered segments. Pure — safe at SSR render time.
function splitText(text: string, by: AnimationType): string[] {
	if (!text) return [];
	switch (by) {
		case 'word':
			// Split preserving whitespace tokens so spaces render naturally between words.
			return text.split(/(\s+)/);
		case 'character':
			return Array.from(text);
		case 'line':
			// Source splits on literal "\n" or real newlines, then trims.
			return text.split(/\\n|\n/).map((l) => l.trim());
		case 'text':
		default:
			return [text];
	}
}

export function TextAnimate({
	content,
	class: className = '',
	segmentClass = '',
	delay = 0,
	duration = 0.3,
	by = 'word',
	startOnView = true,
	once = false,
	animation = 'fadeIn',
	accessible = true,
}: any) @{
	// Segments are pure-computed — SSR safe.
	const segments = track(() => splitText(content ?? '', by));

	const root = track<HTMLElement | null>(null);

	// useInView is effect-guarded internally — safe to call at component setup.
	const inViewState = useInView({ once, amount: 0.2 });

	// Trigger flag: either always-on (startOnView=false) or driven by intersection.
	const shouldAnimate = track(() => {
		if (segments.value.length === 0) return false;
		return startOnView ? inViewState.visible.value : true;
	});

	effect(() => {
		const host = root.value;
		const active = shouldAnimate.value;
		if (!host) return;

		const els = host.querySelectorAll<HTMLElement>('.text-animate-seg');
		if (els.length === 0) return;

		const preset = presets[animation] ?? presets.fadeIn;
		const safeDelay = Math.max(delay ?? 0, 0);
		// Distribute total `duration` evenly as stagger across segments.
		const segStagger = segments.value.length > 1 ? duration / segments.value.length : 0;

		if (active) {
			// Snap every segment to its "hidden" start so there's no flash before
			// the animation fires (especially important with startDelay > 0).
			const hiddenState: Record<string, unknown> = {};
			for (const [key, vals] of Object.entries(preset.keyframes)) {
				hiddenState[key] = vals[0];
			}
			animate(els, hiddenState, { duration: 0 });

			animate(els, preset.keyframes, {
				...preset.transition,
				delay: stagger(segStagger, { from: 'first', startDelay: safeDelay } as any),
				ease: 'easeOut',
			});
		} else {
			// Reset to hidden so a re-trigger (once=false) starts from the initial state.
			const hiddenState: Record<string, unknown> = {};
			for (const [key, vals] of Object.entries(preset.keyframes)) {
				hiddenState[key] = vals[0];
			}
			animate(els, hiddenState, { duration: 0 });
		}
	});

	<>
	<p
		ref={(el: HTMLElement | null) => {
			root.value = el;
			if (startOnView) inViewState.ref(el);
		}}
		class={cn('whitespace-pre-wrap', className)}
		aria-label={accessible ? content : undefined}
	>
		@if (accessible) {
			<span class="sr-only">{content}</span>
		}
		<span aria-hidden={accessible ? true : undefined}>
			@for (const segment of segments.value; ) {
				<span
					class={cn(
						'text-animate-seg',
						by === 'line' ? 'block' : 'inline-block whitespace-pre',
						segmentClass
					)}
				>
					{segment}
				</span>
			}
		</span>
	</p>
	</>
}
