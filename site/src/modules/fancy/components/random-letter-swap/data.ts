import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './random-letter-swap.tsrx?raw';

export const data: ComponentEntry = {
	id: 'random-letter-swap',
	title: 'Random Letter Swap',
	description:
		'Letters slide out and back in a randomised order on hover, creating an organic shuffle effect.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'random-letter-swap.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'label', type: 'string', required: true, description: 'Text to animate.' },
		{
			name: 'reverse',
			type: 'boolean',
			default: 'true',
			description: 'When true letters slide down; false slides up.',
		},
		{
			name: 'transition',
			type: 'AnimationOptions',
			default: '{ type: "spring", duration: 0.8 }',
			description: 'Motion transition options for each letter.',
		},
		{
			name: 'staggerDuration',
			type: 'number',
			default: '0.02',
			description: 'Delay (seconds) between each letter in the shuffle order.',
		},
	],
};
