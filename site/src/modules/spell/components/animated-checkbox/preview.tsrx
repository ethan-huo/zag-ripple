import { AnimatedCheckbox } from './animated-checkbox.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-start gap-4 p-6">
		<AnimatedCheckbox title="Design system tokens" />
		<AnimatedCheckbox title="Implement Checkbox" defaultChecked={true} />
		<AnimatedCheckbox title="Write unit tests" />
		<AnimatedCheckbox title="Ship to production" />
	</div>
	</>
}
