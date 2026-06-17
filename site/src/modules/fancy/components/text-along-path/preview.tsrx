import { TextAlongPath } from './text-along-path.tsrx';

// Circular path: a full circle inscribed in the 100×100 viewBox.
// Using two arcs that meet at (50,5) and (50,95) to form a closed ring.
const CIRCLE_PATH =
	'M 50,5 A 45,45 0 0 1 95,50 A 45,45 0 0 1 50,95 A 45,45 0 0 1 5,50 A 45,45 0 0 1 50,5';

// Wave path that spans the viewBox horizontally with a gentle S-curve.
const WAVE_PATH = 'M 0,50 C 25,20 75,80 100,50';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-8 py-4">
		<div class="relative flex items-center justify-center">
			<TextAlongPath
				path={CIRCLE_PATH}
				text="Text Along Path • Text Along Path • "
				width={200}
				height={200}
				viewBox="0 0 100 100"
				svgClass="text-primary text-[6px] font-medium tracking-wider"
				duration={8}
			/>
		</div>

		<div class="relative flex w-full max-w-xs items-center justify-center overflow-hidden rounded-xl border border-border bg-card py-6">
			<TextAlongPath
				path={WAVE_PATH}
				text="Fancy wave text animation —"
				width="100%"
				height={60}
				viewBox="0 0 100 60"
				svgClass="text-muted-foreground text-[8px] font-semibold tracking-widest"
				duration={5}
				textAnchor="start"
			/>
		</div>
	</div>
	</>
}
