import { effect, track } from 'ripple';
import { useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Splits an image into a grid of clip-path rectangles that each fade in
// independently with random delays — producing a "pixel reveal" entrance.
// Grayscale-to-color transition fires after a separate colorRevealDelay once
// the container is in view. All DOM access is deferred to effects; pieces
// array is pure math so it's safe to compute at render (SSR).

type Grid = { rows: number; cols: number };

const DEFAULT_GRIDS: Record<string, Grid> = {
	'6x4': { rows: 4, cols: 6 },
	'8x8': { rows: 8, cols: 8 },
	'8x3': { rows: 3, cols: 8 },
	'4x6': { rows: 6, cols: 4 },
	'3x8': { rows: 8, cols: 3 },
};

const MIN_GRID = 1;
const MAX_GRID = 16;

export function PixelImage({
	src,
	grid = '6x4',
	customGrid,
	grayscaleAnimation = true,
	pixelFadeInDuration = 1000,
	maxAnimationDelay = 1200,
	colorRevealDelay = 1300,
	once = false,
	class: className,
}: any) @{
	// Resolve grid dimensions at render — pure math, SSR-safe.
	const isValidGrid = (g?: Grid) =>
		g != null &&
		Number.isInteger(g.rows) &&
		Number.isInteger(g.cols) &&
		g.rows >= MIN_GRID &&
		g.cols >= MIN_GRID &&
		g.rows <= MAX_GRID &&
		g.cols <= MAX_GRID;

	const dimensions: Grid = isValidGrid(customGrid) ? customGrid : DEFAULT_GRIDS[grid] ?? DEFAULT_GRIDS['6x4'];

	// Build pieces at render; delays are randomised once here and stay stable.
	// clip-path polygon tiles the image without needing any DOM measurement.
	const pieces = Array.from({ length: dimensions.rows * dimensions.cols }, (_, index) => {
		const row = Math.floor(index / dimensions.cols);
		const col = index % dimensions.cols;
		const pct = (n: number, total: number) => `${(n / total) * 100}%`;
		const r = dimensions.rows;
		const c = dimensions.cols;
		const clipPath = `polygon(${pct(col, c)} ${pct(row, r)}, ${pct(col + 1, c)} ${pct(row, r)}, ${pct(col + 1, c)} ${pct(row + 1, r)}, ${pct(col, c)} ${pct(row + 1, r)})`;
		const delay = Math.random() * maxAnimationDelay;
		return { clipPath, delay };
	});

	// useInView is effect-guarded internally — safe to call at render.
	// Passing once directly: once=false → visibility toggles on leave (adapter
	// returns a teardown); once=true → latches on first intersection.
	const inView = useInView({ once, amount: 0.2 });

	// showColor drives the grayscale→color CSS transition. It's set inside an
	// effect so the timeout runs only on the client after the element is visible.
	const showColor = track(false);

	effect(() => {
		if (!inView.visible.value) {
			// When element leaves view and `once` is false, reset color state so
			// the animation replays on re-entry.
			if (!once) showColor.value = false;
			return;
		}
		const id = setTimeout(() => {
			showColor.value = true;
		}, colorRevealDelay);
		return () => clearTimeout(id);
	});

	<>
	<div
		ref={inView.ref}
		class={cn('relative h-72 w-72 select-none md:h-96 md:w-96', className)}
	>
		@for (const piece of pieces; index i) {
			<div
				class={cn(
					'absolute inset-0 transition-all ease-out',
					inView.visible.value ? 'opacity-100' : 'opacity-0',
				)}
				style={`clip-path: ${piece.clipPath}; transition-delay: ${piece.delay}ms; transition-duration: ${pixelFadeInDuration}ms;`}
			>
				<img
					src={src}
					alt={`Pixel image piece ${i + 1}`}
					class="absolute inset-0 h-full w-full rounded-[2.5rem] object-cover"
					style={grayscaleAnimation
						? `filter: ${showColor.value ? 'grayscale(0)' : 'grayscale(1)'}; transition: filter ${pixelFadeInDuration}ms cubic-bezier(0.4, 0, 0.2, 1);`
						: ''}
					draggable="false"
				/>
			</div>
		}
	</div>
	</>
}
