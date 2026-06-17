import { AuroraText } from './aurora-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-4 py-8">
		<h2 class="text-5xl font-bold tracking-tight">
			Build <AuroraText>beautiful</AuroraText> apps
		</h2>
		<p class="text-muted-foreground text-sm">
			with <AuroraText colors={['#f97316', '#eab308', '#22c55e']} speed={1.5}>custom colors</AuroraText> and speed
		</p>
	</div>
	</>
}
