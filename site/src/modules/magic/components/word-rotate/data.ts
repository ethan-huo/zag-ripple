import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './word-rotate.tsrx?raw';

export const data: ComponentEntry = {
	id: 'word-rotate',
	title: 'Word Rotate',
	description: 'Cycles through a list of words, sliding each out before the next slides in.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'word-rotate.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'words', type: 'string[]', required: true },
		{ name: 'duration', type: 'number', default: '2500', description: 'Milliseconds per word.' },
		{ name: 'class', type: 'string' },
	],
};
