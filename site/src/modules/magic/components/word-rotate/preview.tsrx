import { WordRotate } from './word-rotate.tsrx';

export function Preview() @{
	<>
	<div class="text-center text-4xl font-bold tracking-tight text-foreground">
		<WordRotate words={['Ripple', 'Reactive', 'Effortless', 'Fast']} class="text-primary" />
	</div>
	</>
}
