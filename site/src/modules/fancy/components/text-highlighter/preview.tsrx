import { TextHighlighter } from './text-highlighter.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 px-8 py-4 text-center font-semibold">
		<p class="text-2xl leading-relaxed">
			Build{' '}
			<TextHighlighter highlightColor="hsl(25, 90%, 80%)" triggerType="inView">
				beautiful interfaces
			</TextHighlighter>{' '}
			that users love.
		</p>
		<p class="text-xl leading-relaxed text-foreground/80">
			Animate from{' '}
			<TextHighlighter highlightColor="hsl(142, 76%, 73%)" triggerType="inView" direction="rtl">
				right to left
			</TextHighlighter>{' '}
			or{' '}
			<TextHighlighter highlightColor="hsl(210, 90%, 75%)" triggerType="hover">
				hover to highlight
			</TextHighlighter>
			.
		</p>
		<p class="text-lg leading-relaxed text-muted-foreground">
			Even{' '}
			<TextHighlighter highlightColor="hsl(270, 80%, 80%)" triggerType="auto" direction="ttb">
				top-to-bottom
			</TextHighlighter>{' '}
			fill works out of the box.
		</p>
	</div>
	</>
}
