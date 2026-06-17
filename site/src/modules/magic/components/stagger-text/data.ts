import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './stagger-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'stagger-text',
	title: 'Stagger Text',
	description:
		'Hover any character to trigger a distance-based stagger that scrolls each letter through a clipped slot.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'stagger-text.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'The text to display.' },
		{
			name: 'as',
			type: 'string',
			default: '"h3"',
			description: 'HTML tag rendered as the wrapper element.',
		},
		{ name: 'class', type: 'string', description: 'Extra classes on the wrapper.' },
	],
};
