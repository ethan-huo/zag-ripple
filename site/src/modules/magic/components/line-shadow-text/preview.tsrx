import { LineShadowText } from './line-shadow-text.tsrx';

export function Preview() @{
	<>
	<div class="flex min-h-64 items-center justify-center px-8 text-center">
		<h3 class="text-5xl font-semibold leading-none tracking-tight text-foreground sm:text-6xl">
			Ship{' '}
			<LineShadowText
				content="faster"
				class="italic"
				shadowColor="currentColor"
			/>
		</h3>
	</div>
	</>
}
