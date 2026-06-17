import { BorderBeam } from './border-beam.tsrx';

export function Preview() @{
	<>
	<div class="relative h-48 w-80 overflow-hidden rounded-xl border border-border bg-card">
		<div class="flex h-full items-center justify-center text-sm text-muted-foreground">
			{'Hover-free animated border'}
		</div>
		<BorderBeam size={60} duration={6} />
		<BorderBeam size={60} duration={6} delay={3} colorFrom="#40c9ff" colorTo="#40ff9c" />
	</div>
	</>
}
