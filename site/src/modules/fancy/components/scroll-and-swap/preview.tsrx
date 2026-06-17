import { track } from 'ripple';
import { ScrollAndSwap } from './scroll-and-swap.tsrx';

// The inner overflow div is the scroll container; it's passed as a reactive
// tracked ref so ScrollAndSwap re-wires after the container mounts.
export function Preview() @{
	const containerEl = track<HTMLDivElement | null>(null);

	<>
	<div
		ref={(el: HTMLDivElement | null) => { containerEl.value = el; }}
		class="relative h-[28rem] overflow-y-auto rounded-xl border border-border bg-card"
	>
		<div class="flex flex-col items-center gap-32 px-8 py-16">
			<p class="text-muted-foreground text-sm">↓ scroll down to see the effect</p>

			<ScrollAndSwap
				text="Design"
				scrollContainer={containerEl.value}
				class="text-6xl font-bold tracking-tight text-foreground"
			/>

			<ScrollAndSwap
				text="Systems"
				scrollContainer={containerEl.value}
				class="text-5xl font-semibold text-primary"
			/>

			<ScrollAndSwap
				text="That Move"
				scrollContainer={containerEl.value}
				class="text-4xl font-medium text-muted-foreground"
			/>

			<ScrollAndSwap
				text="Beautifully"
				scrollContainer={containerEl.value}
				class="text-6xl font-bold tracking-tight text-foreground"
			/>

			<p class="text-muted-foreground text-sm">↑ scroll up to reverse</p>
		</div>
	</div>
	</>
}
