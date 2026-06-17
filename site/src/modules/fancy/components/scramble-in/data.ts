import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './scramble-in.tsrx?raw';

export const data: ComponentEntry = {
	id: 'scramble-in',
	title: 'Scramble In',
	description: 'Text reveals left-to-right with a short scrambling tail of random glyphs.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'scramble-in.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true },
		{ name: 'scrambleDelay', type: 'number', default: '0' },
		{ name: 'scrambleSpeed', type: 'number', default: '50' },
		{ name: 'scrambledLetterCount', type: 'number', default: '2' },
		{ name: 'autoStart', type: 'boolean', default: 'true' },
		{ name: 'scrambledClass', type: 'string' },
	],
};
