import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './motion-grid.tsrx?raw';

export const data: ComponentEntry = {
	id: 'motion-grid',
	title: 'Motion Grid',
	description:
		'A CSS grid that cycles through pixel-art frames, animating individual cells between active and inactive states.',
	group: 'Patterns',
	preview: Preview,
	previewCode,
	source: [{ filename: 'motion-grid.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{
			name: 'gridSize',
			type: '[number, number]',
			required: true,
			description: 'Number of [columns, rows] in the grid.',
		},
		{
			name: 'frames',
			type: 'Array<Array<[number, number]>>',
			required: true,
			description:
				'Sequence of frames. Each frame is an array of [x, y] coordinates marking active cells.',
		},
		{
			name: 'duration',
			type: 'number',
			default: '200',
			description: 'Milliseconds between frame advances.',
		},
		{
			name: 'animate',
			type: 'boolean',
			default: 'true',
			description: 'Pause the animation loop when false.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra classes for the grid wrapper (e.g. gap-0.5).',
		},
	],
};
