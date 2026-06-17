import { track } from 'ripple';
import { ColorSelector } from './color-selector.tsrx';

export function Preview() @{
	const selected = track<string>('blue');

	const colors = ['red', 'orange', 'amber', 'green', 'teal', 'blue', 'violet', 'pink', 'rose'];

	<>
	<div class="flex flex-col items-center gap-6">
		<ColorSelector
			colors={colors}
			value={selected.value}
			onColorSelect={(color: string) => { selected.value = color; }}
		/>
		<p class="text-sm text-muted-foreground">
			{'Selected: '}
			<span
				class="font-medium"
				style={`color: var(--color-${selected.value}-500)`}
			>
				{selected.value}
			</span>
		</p>
	</div>
	</>
}
