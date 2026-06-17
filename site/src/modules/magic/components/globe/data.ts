import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './globe.tsrx?raw';

export const data: ComponentEntry = {
	id: 'globe',
	title: 'Globe',
	description: 'An interactive WebGL globe rendered with cobe, draggable with spring-physics release.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'globe.tsrx', code: source, lang: 'tsx' }],
	packages: ['cobe'],
	props: [
		{
			name: 'config',
			type: 'Partial<COBEOptions>',
			default: '{}',
			description: 'Passed directly to cobe createGlobe — overrides any default (phi, theta, dark, markers, etc.).',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra classes on the container div.',
		},
	],
};
