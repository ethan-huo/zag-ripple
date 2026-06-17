import { HighlightedText } from './highlighted-text.tsrx';

export function Preview() @{
	<>
	<div class="text-2xl font-semibold tracking-tight md:text-3xl">
		{'Build interfaces that feel '}
		<HighlightedText from="left">{'alive'}</HighlightedText>
		{' and '}
		<HighlightedText from="bottom" delay={0.15}>{'effortless'}</HighlightedText>
	</div>
	</>
}
