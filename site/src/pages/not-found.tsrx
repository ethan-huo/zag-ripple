import { Layout } from '@/Layout.tsrx';
import { Navigation } from '@/components/navigation.tsrx';
import { NotFound } from '@/NotFound.tsrx';

export function NotFoundPage() @{
	<>
	<Layout>
		<Navigation />
		<NotFound />
	</Layout>
	</>
}
