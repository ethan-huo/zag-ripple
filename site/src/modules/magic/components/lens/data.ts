import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './lens.tsrx?raw';

export const data: ComponentEntry = {
	id: 'lens',
	title: 'Lens',
	description: 'A magnifying lens that zooms in on content as you hover over it.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'lens.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'zoomFactor',
			type: 'number',
			default: '1.3',
			description: 'Scale multiplier applied inside the lens. Must be ≥ 1.',
		},
		{
			name: 'lensSize',
			type: 'number',
			default: '170',
			description: 'Diameter of the circular lens in pixels.',
		},
		{
			name: 'isStatic',
			type: 'boolean',
			default: 'false',
			description: 'When true, the lens is always visible at the given `position`.',
		},
		{
			name: 'position',
			type: '{ x: number; y: number }',
			default: '{ x: 0, y: 0 }',
			description: 'Explicit lens position used when `isStatic` is true.',
		},
		{
			name: 'defaultPosition',
			type: '{ x: number; y: number } | undefined',
			description: 'Fallback position shown when the pointer is outside the container.',
		},
		{
			name: 'duration',
			type: 'number',
			default: '0.1',
			description: 'Enter/exit transition duration in seconds.',
		},
		{
			name: 'lensColor',
			type: 'string',
			default: '"black"',
			description: 'Mask fill color (any CSS color). Controls the visible region.',
		},
		{
			name: 'ariaLabel',
			type: 'string',
			default: '"Zoom Area"',
			description: 'Accessible label for the lens container region.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra Tailwind classes applied to the outer wrapper.',
		},
	],
};
