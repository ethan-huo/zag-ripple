import { WarpBackground } from './warp-background.tsrx';

export function Preview() @{
	<>
	<WarpBackground
		class="flex min-h-[280px] w-full max-w-md items-center justify-center rounded-xl border border-border bg-background text-center"
		beamsPerSide={4}
		beamSize={5}
		beamDuration={3}
		perspective={200}
	>
		<div class="flex flex-col items-center gap-3 px-8 py-6">
			<p class="text-xl font-semibold tracking-tight text-foreground">
				{'Warp Background'}
			</p>
			<p class="text-sm text-muted-foreground">
				{'Perspective grid with animated light beams on all four sides.'}
			</p>
		</div>
	</WarpBackground>
	</>
}
