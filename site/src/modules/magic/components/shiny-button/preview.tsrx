import { ShinyButton } from './shiny-button.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-4">
		<ShinyButton>{'Shiny Button'}</ShinyButton>
		<ShinyButton class="rounded-full px-8">{'Get Started'}</ShinyButton>
	</div>
	</>
}
