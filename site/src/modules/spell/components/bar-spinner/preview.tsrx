import { BarSpinner } from './bar-spinner.tsrx';

export function Preview() @{
	<>
	<div class="flex items-center gap-8 text-foreground">
		<BarSpinner size={20} />
		<BarSpinner size={32} />
		<BarSpinner size={44} color="var(--primary)" />
	</div>
	</>
}
