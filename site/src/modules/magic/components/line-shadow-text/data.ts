import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './line-shadow-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'line-shadow-text',
	title: 'Line Shadow Text',
	description: 'Text with an animated diagonal hatched shadow that scrolls infinitely.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'line-shadow-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'content', type: 'string', required: true, description: 'The text to display.' },
		{
			name: 'shadowColor',
			type: 'string',
			default: '"black"',
			description: 'CSS color value for the hatched shadow lines.',
		},
		{
			name: 'as',
			type: '"span" | "div" | "p" | "h1" | "h2" | "h3" | "h4" | "h5" | "h6"',
			default: '"span"',
			description: 'HTML element to render.',
		},
		{ name: 'class', type: 'string' },
	],
};
