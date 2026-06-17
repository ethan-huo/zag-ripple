import { effect, track } from 'ripple';
import { MotionGrid, MotionGridCells } from './motion-grid.tsrx';

// Frame sets from upstream examples — searching and syncing animations on a 5×5 grid.
type FrameDot = [number, number];
type Frames = FrameDot[][];

const searchingFrames: Frames = [
	[[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]],
	[[2, 0], [1, 1], [2, 1], [3, 1], [2, 2]],
	[[3, 0], [2, 1], [3, 1], [4, 1], [3, 2]],
	[[3, 1], [2, 2], [3, 2], [4, 2], [3, 3]],
	[[3, 2], [2, 3], [3, 3], [4, 3], [3, 4]],
	[[1, 2], [0, 3], [1, 3], [2, 3], [1, 4]],
	[[0, 0], [0, 1], [0, 2], [1, 0], [1, 2], [2, 0], [2, 1], [2, 2]],
	[],
];

const syncingFrames: Frames = [
	[[2, 0]],
	[[1, 0], [2, 0], [3, 0], [2, 1]],
	[[2, 0], [1, 1], [2, 1], [3, 1], [2, 2]],
	[[2, 0], [2, 1], [1, 2], [2, 2], [3, 2], [2, 3]],
	[[2, 1], [2, 2], [1, 3], [2, 3], [3, 3], [2, 4]],
	[[2, 2], [2, 3], [1, 4], [2, 4], [3, 4]],
	[[2, 3], [2, 4]],
	[[2, 4]],
	[],
	[[2, 4]],
	[[1, 4], [2, 4], [3, 4], [2, 3]],
	[[2, 4], [1, 3], [2, 3], [3, 3], [2, 2]],
	[[2, 4], [2, 3], [1, 2], [2, 2], [3, 2], [2, 1]],
	[[2, 3], [2, 2], [1, 1], [2, 1], [3, 1], [2, 0]],
	[[2, 2], [2, 1], [1, 0], [2, 0], [3, 0]],
	[[2, 1], [2, 0]],
	[[2, 0]],
	[],
];

const states = [
	{ label: 'Searching', frames: searchingFrames },
	{ label: 'Syncing', frames: syncingFrames },
];

export function Preview() @{
	const stateIndex = track(0);

	// Cycle through named states every 3 s. Client-only (inside effect).
	effect(() => {
		const id = setInterval(() => {
			stateIndex.value = (stateIndex.value + 1) % states.length;
		}, 3000);
		return () => clearInterval(id);
	});

	const current = track(() => states[stateIndex.value]!);

	<>
	<div class="flex flex-col items-center justify-center gap-6 p-8">
		<div class="inline-flex h-11 items-center justify-center gap-3 rounded-lg bg-primary px-4 shadow-md">
			<MotionGrid
				gridSize={[5, 5]}
				frames={current.value.frames}
				duration={220}
				class="gap-0.5"
				renderCells={(ctx: any) =>
					<MotionGridCells
						cols={ctx.cols}
						rows={ctx.rows}
						frames={ctx.frames}
						frameIndex={ctx.frameIndex}
						transitionDuration={ctx.transitionDuration}
						class="aspect-square size-[3px] rounded-full bg-primary-foreground/20 data-[active=true]:bg-primary-foreground/80"
					/>
				}
			/>
			<span class="text-sm font-medium text-primary-foreground">{current.value.label}</span>
		</div>

		<p class="text-xs text-muted-foreground">{'Pixel grid animation cycling states'}</p>
	</div>
	</>
}
