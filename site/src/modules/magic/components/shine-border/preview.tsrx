import { ShineBorder } from './shine-border.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6">
		<div class="relative overflow-hidden rounded-xl border border-border bg-card p-6 shadow-sm">
			<div class="flex flex-col items-center gap-1 px-4 py-2">
				<span class="text-sm font-medium text-foreground">{'Shine Border'}</span>
				<span class="text-xs text-muted-foreground">{'Single color'}</span>
			</div>
			<ShineBorder shineColor="#a855f7" borderWidth={2} duration={8} />
		</div>

		<div class="relative overflow-hidden rounded-xl border border-border bg-card p-6 shadow-sm">
			<div class="flex flex-col items-center gap-1 px-4 py-2">
				<span class="text-sm font-medium text-foreground">{'Multi-color Shine'}</span>
				<span class="text-xs text-muted-foreground">{'Gradient sweep'}</span>
			</div>
			<ShineBorder shineColor={['#ff6b6b', '#ffd93d', '#6bcb77', '#4d96ff']} borderWidth={2} duration={6} />
		</div>
	</div>
	</>
}
