import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './random-letter-swap-ping-pong.tsrx?raw';

export const data: ComponentEntry = {
	id: 'random-letter-swap-ping-pong',
	title: 'Random Letter Swap Ping Pong',
	description:
		'Letters slide in and out in a random order on hover, then reverse back on mouse leave.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'random-letter-swap-ping-pong.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'label', type: 'string', required: true },
		{
			name: 'reverse',
			type: 'boolean',
			default: 'true',
			description: 'Direction letters slide out — true slides down, false slides up.',
		},
		{
			name: 'staggerDuration',
			type: 'number',
			default: '0.02',
			description: 'Delay in seconds between each letter in the random animation order.',
		},
		{
			name: 'transition',
			type: 'AnimationOptions',
			default: '{ type: "spring", duration: 0.8 }',
			description: 'Motion transition options passed to each letter animation.',
		},
	],
};
