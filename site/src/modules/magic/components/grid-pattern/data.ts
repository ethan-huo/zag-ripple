import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './grid-pattern.tsrx?raw';

export const data: ComponentEntry = {
	id: 'grid-pattern',
	title: 'Grid Pattern',
	description: 'An SVG tiling grid that fills its container, with optional highlighted squares.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'grid-pattern.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'width', type: 'number', default: '40', description: 'Width of each grid cell in pixels.' },
		{ name: 'height', type: 'number', default: '40', description: 'Height of each grid cell in pixels.' },
		{ name: 'x', type: 'number', default: '-1', description: 'X-offset of the pattern origin.' },
		{ name: 'y', type: 'number', default: '-1', description: 'Y-offset of the pattern origin.' },
		{ name: 'strokeDashArray', type: 'string', default: '"0"', description: 'SVG stroke-dasharray for dashed grid lines.' },
		{ name: 'squares', type: 'Array<[number, number]>', description: 'Array of [col, row] coordinates for highlighted (filled) squares.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the SVG element.' },
	],
};
