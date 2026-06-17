import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// AnimatePresence is not available in the motion adapter, so enter/exit are
// coordinated manually: `isVisible` keeps the overlay in the DOM until the
// exit animation resolves, while `isOpen` holds the logical intent.
// Two separate tracked nodes (overlay backdrop + dialog panel) let us apply
// independent animation variants to each layer.

type AnimationStyle =
	| 'from-bottom'
	| 'from-center'
	| 'from-top'
	| 'from-left'
	| 'from-right'
	| 'fade'
	| 'top-in-bottom-out'
	| 'left-in-right-out';

const animationVariants: Record<
	AnimationStyle,
	{ initial: Record<string, unknown>; enter: Record<string, unknown>; exit: Record<string, unknown> }
> = {
	'from-bottom': {
		initial: { y: '100%', opacity: 0 },
		enter: { y: '0%', opacity: 1 },
		exit: { y: '100%', opacity: 0 },
	},
	'from-center': {
		initial: { scale: 0.5, opacity: 0 },
		enter: { scale: 1, opacity: 1 },
		exit: { scale: 0.5, opacity: 0 },
	},
	'from-top': {
		initial: { y: '-100%', opacity: 0 },
		enter: { y: '0%', opacity: 1 },
		exit: { y: '-100%', opacity: 0 },
	},
	'from-left': {
		initial: { x: '-100%', opacity: 0 },
		enter: { x: '0%', opacity: 1 },
		exit: { x: '-100%', opacity: 0 },
	},
	'from-right': {
		initial: { x: '100%', opacity: 0 },
		enter: { x: '0%', opacity: 1 },
		exit: { x: '100%', opacity: 0 },
	},
	fade: {
		initial: { opacity: 0 },
		enter: { opacity: 1 },
		exit: { opacity: 0 },
	},
	'top-in-bottom-out': {
		initial: { y: '-100%', opacity: 0 },
		enter: { y: '0%', opacity: 1 },
		exit: { y: '100%', opacity: 0 },
	},
	'left-in-right-out': {
		initial: { x: '-100%', opacity: 0 },
		enter: { x: '0%', opacity: 1 },
		exit: { x: '100%', opacity: 0 },
	},
};

export function HeroVideoDialog({
	animationStyle = 'from-center',
	videoSrc,
	thumbnailSrc,
	thumbnailAlt = 'Video thumbnail',
	class: className,
}: any) @{
	const isOpen = track(false);
	// stays true until exit animation finishes so the DOM element is animatable
	const isVisible = track(false);

	let backdropNode = track<HTMLElement | null>(null);
	let panelNode = track<HTMLElement | null>(null);

	const variant = track(() => animationVariants[animationStyle as AnimationStyle] ?? animationVariants['from-center']);

	// When open transitions true → false, run exit then hide.
	effect(() => {
		const open = isOpen.value;
		const backdrop = backdropNode.value;
		const panel = panelNode.value;
		const v = variant.value;

		if (open) {
			// Snap both to initial then animate in.
			if (backdrop) {
				animate(backdrop, { opacity: 0 }, { duration: 0 });
				animate(backdrop, { opacity: 1 }, { duration: 0.3, ease: 'easeOut' });
			}
			if (panel) {
				animate(panel, v.initial, { duration: 0 });
				animate(panel, v.enter, { type: 'spring', damping: 30, stiffness: 300 } as any);
			}
		} else if (isVisible.value) {
			// Run exit, then unmount.
			const exitPanel = panel
				? animate(panel, v.exit, { type: 'spring', damping: 30, stiffness: 300 } as any)
				: Promise.resolve();
			const exitBackdrop = backdrop
				? animate(backdrop, { opacity: 0 }, { duration: 0.2 })
				: Promise.resolve();
			Promise.all([exitPanel, exitBackdrop]).then(() => {
				isVisible.value = false;
			});
		}
	});

	function open() {
		isVisible.value = true;
		// isOpen must flip in the next microtask so the DOM nodes are mounted
		// and backdropNode/panelNode refs are populated before the effect fires.
		Promise.resolve().then(() => {
			isOpen.value = true;
		});
	}

	function close() {
		isOpen.value = false;
	}

	function handleKeyDown(e: KeyboardEvent) {
		if (e.key === 'Escape' || e.key === 'Enter' || e.key === ' ') {
			close();
		}
	}

	<>
	<div class={cn('relative', className)}>
		<button
			type="button"
			aria-label="Play video"
			class="group relative cursor-pointer border-0 bg-transparent p-0"
			onClick={open}
		>
			<img
				src={thumbnailSrc}
				alt={thumbnailAlt}
				width={1920}
				height={1080}
				class="w-full rounded-md border shadow-lg transition-all duration-200 ease-out group-hover:brightness-[0.8]"
			/>
			<div class="absolute inset-0 flex scale-[0.9] items-center justify-center rounded-2xl transition-all duration-200 ease-out group-hover:scale-100">
				<div class="bg-primary/10 flex size-28 items-center justify-center rounded-full backdrop-blur-md">
					<div class="from-primary/30 to-primary relative flex size-20 scale-100 items-center justify-center rounded-full bg-gradient-to-b shadow-md transition-all duration-200 ease-out group-hover:scale-[1.2]">
						<svg
							class="size-8 scale-100 fill-white text-white transition-transform duration-200 ease-out group-hover:scale-105"
							style="filter: drop-shadow(0 4px 3px rgb(0 0 0 / 0.07)) drop-shadow(0 2px 2px rgb(0 0 0 / 0.06));"
							xmlns="http://www.w3.org/2000/svg"
							viewBox="0 0 24 24"
						>
							<polygon points="5 3 19 12 5 21 5 3" />
						</svg>
					</div>
				</div>
			</div>
		</button>

		@if (isVisible.value) {
			<div
				ref={(el) => { backdropNode.value = el; }}
				role="button"
				tabIndex={0}
				aria-label="Close video"
				onKeyDown={handleKeyDown}
				onClick={close}
				class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-md"
				style="opacity: 0;"
			>
				<div
					ref={(el) => { panelNode.value = el; }}
					class="relative mx-4 aspect-video w-full max-w-4xl md:mx-0"
					onClick={(e: MouseEvent) => e.stopPropagation()}
				>
					<button
						type="button"
						onClick={close}
						aria-label="Close video"
						class="absolute -top-16 right-0 rounded-full bg-neutral-900/50 p-2 text-xl text-white ring-1 backdrop-blur-md dark:bg-neutral-100/50 dark:text-black"
					>
						<svg
							class="size-5"
							xmlns="http://www.w3.org/2000/svg"
							viewBox="0 0 24 24"
							fill="none"
							stroke="currentColor"
							stroke-width="2"
							stroke-linecap="round"
							stroke-linejoin="round"
						>
							<line x1="18" y1="6" x2="6" y2="18" />
							<line x1="6" y1="6" x2="18" y2="18" />
						</svg>
					</button>
					<div class="relative isolate z-[1] size-full overflow-hidden rounded-2xl border-2 border-white">
						<iframe
							src={videoSrc}
							title="Hero Video player"
							class="size-full rounded-2xl"
							allowFullScreen
							allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
						/>
					</div>
				</div>
			</div>
		}
	</div>
	</>
}
