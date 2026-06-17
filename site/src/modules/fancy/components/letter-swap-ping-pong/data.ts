import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './letter-swap-ping-pong.tsrx?raw';

export const data: ComponentEntry = {
	id: 'letter-swap-ping-pong',
	title: 'Letter Swap Ping Pong',
	description:
		'Bidirectional letter swap — letters slide out on hover and reverse back on mouse leave, ping-ponging between states.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'letter-swap-ping-pong.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'label', type: 'string', required: true },
		{ name: 'reverse', type: 'boolean', default: 'true', description: 'Direction letters slide out — true slides down, false slides up.' },
		{ name: 'staggerDuration', type: 'number', default: '0.03', description: 'Delay between each letter animation in seconds.' },
		{ name: 'staggerFrom', type: '"first" | "last" | "center" | number', default: '"first"', description: 'Which end of the word the stagger starts from.' },
		{ name: 'transition', type: 'AnimationOptions', default: '{ type: "spring", duration: 0.7 }', description: 'Motion transition options passed to each letter animation.' },
	],
};
