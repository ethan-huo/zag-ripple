import { StaggerText } from './stagger-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6 text-foreground">
		<StaggerText
			text="Hover over me!"
			as="h2"
			class="text-4xl font-bold tracking-tight"
		/>
		<StaggerText
			text="Stagger Text"
			as="h3"
			class="text-2xl font-semibold text-muted-foreground"
		/>
	</div>
	</>
}
