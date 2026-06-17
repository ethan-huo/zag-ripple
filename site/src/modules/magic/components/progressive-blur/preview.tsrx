import { ProgressiveBlur } from './progressive-blur.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full max-w-sm overflow-hidden rounded-xl border border-border bg-card">
		{/* Scrollable text content that the blur overlays */}
		<div class="h-full overflow-hidden p-6 text-sm leading-relaxed text-foreground select-none">
			{'The quick brown fox jumps over the lazy dog. '}
			{'Pack my box with five dozen liquor jugs. '}
			{'How vexingly quick daft zebras jump! '}
			{'The five boxing wizards jump quickly. '}
			{'Sphinx of black quartz, judge my vow. '}
			{'Jackdaws love my big sphinx of quartz. '}
			{'The quick brown fox jumps over the lazy dog. '}
			{'Pack my box with five dozen liquor jugs. '}
			{'How vexingly quick daft zebras jump! '}
		</div>
		{/* Bottom progressive blur fades out the text */}
		<ProgressiveBlur position="bottom" height="40%" />
	</div>
	</>
}
