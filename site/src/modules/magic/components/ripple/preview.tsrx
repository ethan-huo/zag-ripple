import { Ripple } from './ripple.tsrx';

export function Preview() @{
	<>
	<div class="relative flex h-72 w-full max-w-xl items-center justify-center overflow-hidden rounded-xl border border-border bg-card">
		<p class="z-10 text-center text-xl font-semibold text-foreground">{'Ripple'}</p>
		<Ripple />
	</div>
	</>
}
