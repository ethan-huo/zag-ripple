import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './letter-swap.tsrx?raw';

export const data: ComponentEntry = {
	id: 'letter-swap',
	title: 'Letter Swap',
	description: 'Each letter swaps for a duplicate sliding in from the opposite edge, staggered on hover.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'letter-swap.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'label', type: 'string', required: true },
		{ name: 'reverse', type: 'boolean', default: 'true' },
		{ name: 'staggerDuration', type: 'number', default: '0.03' },
		{ name: 'staggerFrom', type: '"first" | "last" | "center" | number', default: '"first"' },
		{ name: 'transition', type: 'AnimationOptions', default: '{ type: "spring", duration: 0.7 }' },
	],
};
