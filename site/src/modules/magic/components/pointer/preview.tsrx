import { Pointer } from './pointer.tsrx';

export function Preview() @{
	<>
	<div class="relative flex h-64 w-full items-center justify-center overflow-hidden rounded-xl border border-border bg-card select-none">
		<Pointer />
		<div class="text-center">
			<p class="text-sm text-muted-foreground">{'Move your cursor here'}</p>
			<p class="mt-1 text-xs text-muted-foreground/60">{'Custom pointer replaces the default cursor'}</p>
		</div>
	</div>
	</>
}
