import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './highlighted-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'highlighted-text',
	title: 'Highlighted Text',
	description: 'A highlight bar that slides in behind text from any edge.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'highlighted-text.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'children', type: 'Children', required: true },
		{
			name: 'from',
			type: '"left" | "right" | "top" | "bottom"',
			default: '"bottom"',
			description: 'Edge the highlight slides in from.',
		},
		{ name: 'delay', type: 'number', default: '0' },
		{ name: 'triggerOnView', type: 'boolean', default: 'false' },
		{ name: 'once', type: 'boolean', default: 'true' },
	],
};
