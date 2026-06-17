import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './vertical-cut-reveal.tsrx?raw';

export const data: ComponentEntry = {
	id: 'vertical-cut-reveal',
	title: 'Vertical Cut Reveal',
	description: 'Characters rise into view from a clipped track, staggered across the text.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'vertical-cut-reveal.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'children', type: 'Children', required: true },
		{ name: 'splitBy', type: '"words" | "characters" | "lines" | string', default: '"words"' },
		{ name: 'reverse', type: 'boolean', default: 'false' },
		{ name: 'staggerDuration', type: 'number', default: '0.2' },
		{ name: 'staggerFrom', type: '"first" | "last" | "center" | "random" | number', default: '"first"' },
		{ name: 'autoStart', type: 'boolean', default: 'true' },
	],
};
