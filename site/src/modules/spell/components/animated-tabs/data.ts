import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-tabs.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-tabs',
	title: 'Animated Tabs',
	description: 'A tab bar that slides a clipped primary-color highlight over the active tab via CSS clip-path.',
	group: 'Navigation',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-tabs.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'tabs', type: 'string[]', required: true, description: 'Ordered list of tab labels.' },
		{ name: 'value', type: 'string', description: 'Controlled active tab label.' },
		{ name: 'onChange', type: '(tab: string) => void', description: 'Called when the user selects a tab.' },
		{ name: 'class', type: 'string', description: 'Extra classes for the root element.' },
	],
};
