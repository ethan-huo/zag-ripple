import { Layout } from '@/Layout.tsrx';
import { ComponentDocPage } from '@/components/docs/component-doc-page.tsrx';

export function SpellComponentPage({ params }: { params: { id: string } }) @{
	<>
	<Layout>
		<ComponentDocPage module="spell" id={params.id} />
	</Layout>
	</>
}
