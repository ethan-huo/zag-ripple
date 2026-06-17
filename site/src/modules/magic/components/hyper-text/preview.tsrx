import { HyperText } from './hyper-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6">
		<HyperText
			text="Hyper Text"
			class="cursor-pointer text-foreground"
		/>
		<HyperText
			text="Hover Me"
			class="cursor-pointer text-muted-foreground text-2xl"
			animateOnHover
			startOnView={false}
			delay={500}
		/>
	</div>
	</>
}
