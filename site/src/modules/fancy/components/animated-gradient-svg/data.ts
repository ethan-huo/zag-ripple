import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-gradient-svg.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-gradient-svg',
	title: 'Animated Gradient SVG',
	description:
		'An animated multi-color gradient background built from blurred SVG circles that drift with per-blob seeded motion paths.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-gradient-svg.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'colors',
			type: 'string[]',
			required: true,
			description: 'List of blob colors used to generate the animated gradient field.',
		},
		{
			name: 'speed',
			type: 'number',
			default: '5',
			description: 'Animation duration in seconds shared by each SVG blob.',
		},
		{
			name: 'blur',
			type: '"light" | "medium" | "heavy"',
			default: '"light"',
			description: 'Controls the blur strength applied to the full gradient layer.',
		},
		{
			name: 'class',
			type: 'string',
			default: 'undefined',
			description: 'Classes merged onto the outer absolute-positioned wrapper.',
		},
	],
};
