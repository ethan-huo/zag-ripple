import { Backlight } from './backlight.tsrx';

export function Preview() @{
	<>
	<div class="flex h-64 items-center justify-center gap-6 rounded-xl border border-border bg-card p-8">
		<Backlight blur={12}>
			<div class="flex gap-3">
				<div class="h-10 w-10 rounded-full bg-primary" />
				<div class="h-10 w-10 rounded-full bg-purple-500" />
				<div class="h-10 w-10 rounded-full bg-rose-500" />
			</div>
		</Backlight>
		<Backlight blur={8}>
			<span class="text-2xl font-bold text-primary">
				{'Backlight'}
			</span>
		</Backlight>
	</div>
	</>
}
