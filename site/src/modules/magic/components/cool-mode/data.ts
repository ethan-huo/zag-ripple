import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './cool-mode.tsrx?raw';

export const data: ComponentEntry = {
	id: 'cool-mode',
	title: 'Cool Mode',
	description: 'Wraps any element and spawns colorful particles while the user presses or drags over it.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'cool-mode.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'options.particle',
			type: 'string',
			default: '"circle"',
			description: '"circle" for SVG circles, an emoji/character, or an image URL.',
		},
		{
			name: 'options.size',
			type: 'number',
			description: 'Fixed particle size in px. Defaults to a random pick from [15, 20, 25, 35, 45].',
		},
		{
			name: 'options.speedHorz',
			type: 'number',
			description: 'Horizontal drift speed. Randomised per-particle when omitted.',
		},
		{
			name: 'options.speedUp',
			type: 'number',
			description: 'Upward launch speed. Randomised per-particle when omitted.',
		},
	],
};
