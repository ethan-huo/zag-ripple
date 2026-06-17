import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './light-rays.tsrx?raw';

export const data: ComponentEntry = {
	id: 'light-rays',
	title: 'Light Rays',
	description: 'Randomised volumetric light beams that pulse and swing over a container.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'light-rays.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'count', type: 'number', default: '7', description: 'Number of ray beams.' },
		{
			name: 'color',
			type: 'string',
			default: '"rgba(160, 210, 255, 0.2)"',
			description: 'Base rgba color of the rays.',
		},
		{ name: 'blur', type: 'number', default: '36', description: 'Blur radius in pixels.' },
		{
			name: 'speed',
			type: 'number',
			default: '14',
			description: 'Base cycle duration in seconds (scales all ray timings).',
		},
		{
			name: 'length',
			type: 'string',
			default: '"70vh"',
			description: 'CSS length for how far each ray extends from the top.',
		},
		{ name: 'class', type: 'string', description: 'Extra classes applied to the root element.' },
		{ name: 'style', type: 'string', description: 'Inline styles appended to the root element.' },
	],
};
