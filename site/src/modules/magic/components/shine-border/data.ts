import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './shine-border.tsrx?raw';

export const data: ComponentEntry = {
	id: 'shine-border',
	title: 'Shine Border',
	description: 'A radial-gradient shine that sweeps continuously around a container border.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'shine-border.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'borderWidth', type: 'number', default: '1', description: 'Border thickness in pixels.' },
		{ name: 'duration', type: 'number', default: '14', description: 'Animation cycle duration in seconds.' },
		{
			name: 'shineColor',
			type: 'string | string[]',
			default: '"#000000"',
			description: 'One or more colors for the shine gradient. Pass an array for a multi-color sweep.',
		},
	],
};
