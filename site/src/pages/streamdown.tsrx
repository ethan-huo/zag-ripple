import { Layout } from '@/Layout.tsrx';
import { ClientOnly } from '@/components/client-only.tsrx';
import { StreamdownPlayground } from '@/extensions/streamdown-playground.tsrx';

// Streamdown brings mermaid/shiki and heavy interactive state — render it
// client-only so SSR doesn't execute browser-only code at render time.
export function StreamdownPage() @{
	<>
	<Layout>
		<ClientOnly fallback={<div class="flex min-h-screen items-center justify-center text-muted-foreground">{'Loading playground…'}</div>}>
			<StreamdownPlayground />
		</ClientOnly>
	</Layout>
	</>
}
