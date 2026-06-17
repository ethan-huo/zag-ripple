import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './scramble-hover.tsrx?raw';

export const data: ComponentEntry = {
	id: 'scramble-hover',
	title: 'Scramble Hover',
	description: 'Characters cycle through random glyphs on hover and settle back to the real text.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'scramble-hover.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true },
		{ name: 'scrambleSpeed', type: 'number', default: '50' },
		{ name: 'maxIterations', type: 'number', default: '10' },
		{ name: 'sequential', type: 'boolean', default: 'false' },
		{ name: 'revealDirection', type: '"start" | "end" | "center"', default: '"start"' },
		{ name: 'useOriginalCharsOnly', type: 'boolean', default: 'false' },
		{ name: 'scrambledClass', type: 'string', description: 'Class applied to scrambling characters.' },
	],
};
