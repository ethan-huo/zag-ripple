import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-list.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-list',
	title: 'Animated List',
	description:
		'Progressively reveals list items one by one with a spring entrance, prepending each new item at the top.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-list.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{
			name: 'items',
			type: 'any[]',
			required: true,
			description: 'Array of items to display. Each item should have a stable `id` field.',
		},
		{
			name: 'delay',
			type: 'number',
			default: '1000',
			description: 'Milliseconds between each item being prepended.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra class names for the outer container.',
		},
		{
			name: 'children',
			type: '(item: any, index: number) => JSX',
			required: true,
			description: 'Render function called for each visible item.',
		},
	],
};
