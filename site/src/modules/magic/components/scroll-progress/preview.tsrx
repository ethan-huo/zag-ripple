import { ScrollProgress } from './scroll-progress.tsrx';

// Preview wraps the bar in a fixed-height scrollable container so the effect
// is self-contained without relying on real page scroll.
export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card">
		<div class="flex h-full flex-col items-center justify-center gap-3 text-sm text-muted-foreground">
			<span class="text-base font-medium text-foreground">{'Scroll Progress Bar'}</span>
			<span class="text-xs">{'Scroll the page to see the bar fill'}</span>
			<div class="mt-2 h-2 w-48 rounded-full bg-muted overflow-hidden">
				<div
					class="h-full rounded-full bg-linear-to-r from-[#A97CF8] via-[#F38CB8] to-[#FDCC92]"
					style="width: 60%"
				/>
			</div>
		</div>
		<ScrollProgress />
	</div>
	</>
}
