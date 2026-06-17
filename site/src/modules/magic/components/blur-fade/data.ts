import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './blur-fade.tsrx?raw';

export const data: ComponentEntry = {
	id: 'blur-fade',
	title: 'Blur Fade',
	description:
		'Fades children in with a soft blur and directional slide when they enter the viewport.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'blur-fade.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'children', type: 'Component', required: true },
		{ name: 'class', type: 'string' },
		{
			name: 'duration',
			type: 'number',
			default: '0.4',
			description: 'Animation duration in seconds.',
		},
		{
			name: 'delay',
			type: 'number',
			default: '0',
			description: 'Extra delay added on top of the built-in 0.04 s base delay.',
		},
		{
			name: 'offset',
			type: 'number',
			default: '6',
			description: 'Pixels of directional slide on entrance.',
		},
		{
			name: 'direction',
			type: '"up" | "down" | "left" | "right"',
			default: '"down"',
			description: 'Direction from which the element slides in.',
		},
		{
			name: 'blur',
			type: 'string',
			default: '"6px"',
			description: 'Starting blur radius.',
		},
		{
			name: 'triggerOnView',
			type: 'boolean',
			default: 'true',
			description: 'Delay animation until the element is scrolled into view.',
		},
		{
			name: 'inViewMargin',
			type: 'string',
			default: '"-50px"',
			description: 'Root margin passed to IntersectionObserver.',
		},
		{
			name: 'once',
			type: 'boolean',
			default: 'true',
			description: 'Only play the animation the first time the element enters view.',
		},
		{
			name: 'variant',
			type: '{ hidden: object; visible: object }',
			description: 'Override the default hidden/visible keyframe shapes.',
		},
	],
};
