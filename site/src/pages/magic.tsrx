import { Layout } from '@/Layout.tsrx';
import { ModuleLanding } from '@/components/docs/module-landing.tsrx';

export function MagicPage() @{
	<>
	<Layout>
		<ModuleLanding module="magic" />
	</Layout>
	</>
}
