import { Layout } from '@/Layout.tsrx';
import { ComponentDocPage } from '@/components/docs/component-doc-page.tsrx';

export function FancyComponentPage({ params }: { params: { id: string } }) @{
	<>
	<Layout>
		<ComponentDocPage module="fancy" id={params.id} />
	</Layout>
	</>
}
