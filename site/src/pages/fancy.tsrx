import { Layout } from '@/Layout.tsrx';
import { ModuleLanding } from '@/components/docs/module-landing.tsrx';

export function FancyPage() @{
	<>
	<Layout>
		<ModuleLanding module="fancy" />
	</Layout>
	</>
}
