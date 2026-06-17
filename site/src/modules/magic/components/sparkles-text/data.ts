import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './sparkles-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'sparkles-text',
	title: 'Sparkles Text',
	description:
		'Wraps text in a shower of animated star sparkles that continuously regenerate around the content.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'sparkles-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Component', required: true, description: 'Text or elements to sparkle.' },
		{ name: 'sparklesCount', type: 'number', default: '10', description: 'Number of sparkle particles.' },
		{
			name: 'colors',
			type: '{ first: string; second: string }',
			default: '{ first: "#9E7AFF", second: "#FE8BBB" }',
			description: 'Two alternating sparkle colours.',
		},
		{ name: 'class', type: 'string' },
		{ name: 'style', type: 'string' },
	],
};
