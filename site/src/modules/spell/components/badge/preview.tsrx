import { Badge } from './badge.tsrx';

const colors = ['red', 'blue', 'green', 'yellow', 'purple', 'pink', 'cyan', 'amber', 'emerald', 'sky'];

export function Preview() @{
	<>
	<div class="flex max-w-md flex-wrap items-center justify-center gap-2">
		<Badge>{'Default'}</Badge>
		<Badge variant="secondary">{'Secondary'}</Badge>
		<Badge variant="outline">{'Outline'}</Badge>
		<Badge variant="destructive">{'Destructive'}</Badge>
		@for (const color of colors) {
			<Badge variant={color}>{color}</Badge>
		}
	</div>
	</>
}
