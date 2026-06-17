import { track } from 'ripple';
import { Code } from '../code.tsrx';
import { cn } from '@/lib/utils';

// Preview/Code toggle box used for the main demo and each example.
export function ComponentPreview({
	preview: PreviewComp,
	code,
	lang = 'tsx',
	class: className,
}: any) @{
	let tab = track('preview');

	const tabClass = (name: string) =>
		cn(
			'rounded-md px-3 py-1 text-sm transition-colors cursor-pointer',
			tab.value === name
				? 'bg-background font-medium text-foreground shadow-[var(--shadow-1)]'
				: 'text-muted-foreground hover:text-foreground',
		);

	<>
	<div class="overflow-hidden rounded-lg border border-border bg-card">
		<div class="flex items-center gap-1 border-b border-border bg-muted/30 px-2 py-1.5">
			<button type="button" onClick={() => (tab.value = 'preview')} class={tabClass('preview')}>
				{'Preview'}
			</button>
			<button type="button" onClick={() => (tab.value = 'code')} class={tabClass('code')}>
				{'Code'}
			</button>
		</div>

		@if (tab.value === 'preview') {
			<div
				class={cn(
					'flex min-h-[18rem] flex-wrap items-center justify-center gap-6 overflow-hidden p-10',
					className,
				)}
			>
				<{PreviewComp} />
			</div>
		} @else {
			<div class="max-h-[28rem] overflow-auto">
				<Code code={code} language={lang} />
			</div>
		}
	</div>
	</>
}
