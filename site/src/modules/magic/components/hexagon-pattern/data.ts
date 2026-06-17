import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './hexagon-pattern.tsrx?raw';

export const data: ComponentEntry = {
	id: 'hexagon-pattern',
	title: 'Hexagon Pattern',
	description: 'A tiling SVG hexagon pattern with optional highlighted cells and dashed-edge support.',
	group: 'Patterns',
	preview: Preview,
	previewCode,
	source: [{ filename: 'hexagon-pattern.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'radius', type: 'number', default: '40', description: 'Hex circumradius in pixels.' },
		{ name: 'gap', type: 'number', default: '0', description: 'Gap between hexagon tiles.' },
		{ name: 'x', type: 'number', default: '-1', description: 'Pattern x offset.' },
		{ name: 'y', type: 'number', default: '-1', description: 'Pattern y offset.' },
		{ name: 'direction', type: '"horizontal" | "vertical"', default: '"horizontal"', description: 'Flat-top (horizontal) or pointy-top (vertical) orientation.' },
		{ name: 'strokeDasharray', type: 'string', default: '"0"', description: 'SVG stroke-dasharray; empty/"0" renders solid edges, a dash pattern renders individual dashed segments.' },
		{ name: 'hexagons', type: 'Array<[col: number, row: number]>', description: 'Grid coordinates of highlighted (filled) hexagons.' },
		{ name: 'class', type: 'string', description: 'Additional CSS classes applied to the root <svg>.' },
	],
};
