import { Layout } from '@/Layout.tsrx';
import { ModuleLanding } from '@/components/docs/module-landing.tsrx';

export function SpellPage() @{
	<>
	<Layout>
		<ModuleLanding module="spell" />
	</Layout>
	</>
}
