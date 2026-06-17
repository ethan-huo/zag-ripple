import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './noise-texture.tsrx?raw';

export const data: ComponentEntry = {
	id: 'noise-texture',
	title: 'Noise Texture',
	description: 'An SVG feTurbulence grain overlay that adds film-grain or frosted-glass texture to any container.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'noise-texture.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'frequency',
			type: 'number',
			default: '0.4',
			description: 'baseFrequency for feTurbulence. Higher values yield finer-grained noise.',
		},
		{
			name: 'octaves',
			type: 'number',
			default: '6',
			description: 'numOctaves for feTurbulence. More octaves add detail at smaller scales.',
		},
		{
			name: 'slope',
			type: 'number',
			default: '0.15',
			description: 'Linear slope on each channel after desaturation; adjusts contrast.',
		},
		{
			name: 'noiseOpacity',
			type: 'number',
			default: '0.6',
			description: 'Opacity of the filled noise rect layer.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra classes merged onto the SVG root element.',
		},
	],
};
