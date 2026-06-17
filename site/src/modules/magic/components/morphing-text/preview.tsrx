import { MorphingText } from './morphing-text.tsrx';

export function Preview() @{
	<>
	<div class="flex h-40 w-full items-center justify-center">
		<MorphingText
			texts={['Ripple', 'Reactive', 'Seamless', 'Effortless']}
			class="text-foreground"
		/>
	</div>
	</>
}
