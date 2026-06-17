import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './retro-grid.tsrx?raw';

export const data: ComponentEntry = {
	id: 'retro-grid',
	title: 'Retro Grid',
	description: 'A perspective-scrolling grid background that creates a retro infinite-horizon effect.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'retro-grid.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'angle',
			type: 'number',
			default: '65',
			description: 'Rotation angle of the grid plane in degrees.',
		},
		{
			name: 'cellSize',
			type: 'number',
			default: '60',
			description: 'Size of each grid cell in pixels.',
		},
		{
			name: 'opacity',
			type: 'number',
			default: '0.5',
			description: 'Overall opacity of the grid (0–1).',
		},
		{
			name: 'lightLineColor',
			type: 'string',
			default: '"gray"',
			description: 'Grid line color in light mode.',
		},
		{
			name: 'darkLineColor',
			type: 'string',
			default: '"gray"',
			description: 'Grid line color in dark mode.',
		},
	],
};
