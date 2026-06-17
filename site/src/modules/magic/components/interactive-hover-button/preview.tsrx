import { InteractiveHoverButton } from './interactive-hover-button.tsrx';

export function Preview() @{
	<>
	<div class="flex items-center justify-center gap-4 p-8">
		<InteractiveHoverButton>{'Hover Me'}</InteractiveHoverButton>
		<InteractiveHoverButton>{'Get Started'}</InteractiveHoverButton>
	</div>
	</>
}
