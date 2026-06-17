import { Layout } from '@/Layout.tsrx';
import { ComponentDocPage } from '@/components/docs/component-doc-page.tsrx';

export function MagicComponentPage({ params }: { params: { id: string } }) @{
	<>
	<Layout>
		<ComponentDocPage module="magic" id={params.id} />
	</Layout>
	</>
}
