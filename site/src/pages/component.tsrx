import { Layout } from '@/Layout.tsrx';
import { Component } from '@/Component.tsrx';

export function ComponentPage({ params }: { params: { id: string } }) @{
	<>
	<Layout>
		<Component id={params.id} />
	</Layout>
	</>
}
