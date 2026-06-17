import { Meteors } from './meteors.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full max-w-xl overflow-hidden rounded-xl border border-border bg-card">
		<Meteors number={18} />
		<div class="flex h-full items-center justify-center text-lg font-semibold text-foreground">
			{'Meteors'}
		</div>
	</div>
	</>
}
