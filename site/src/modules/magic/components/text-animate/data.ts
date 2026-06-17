import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './text-animate.tsrx?raw';

export const data: ComponentEntry = {
	id: 'text-animate',
	title: 'Text Animate',
	description:
		'Animates text word-by-word, character-by-character, or line-by-line with a suite of built-in entrance presets.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'text-animate.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'content', type: 'string', required: true, description: 'The text to animate.' },
		{
			name: 'by',
			type: '"text" | "word" | "character" | "line"',
			default: '"word"',
			description: 'Granularity at which the text is split into animated segments.',
		},
		{
			name: 'animation',
			type: '"fadeIn" | "blurIn" | "blurInUp" | "blurInDown" | "slideUp" | "slideDown" | "slideLeft" | "slideRight" | "scaleUp" | "scaleDown"',
			default: '"fadeIn"',
			description: 'Entrance animation preset.',
		},
		{
			name: 'startOnView',
			type: 'boolean',
			default: 'true',
			description: 'Start animation when the element enters the viewport.',
		},
		{
			name: 'once',
			type: 'boolean',
			default: 'false',
			description: 'When true, animate only the first time it enters view.',
		},
		{
			name: 'delay',
			type: 'number',
			default: '0',
			description: 'Seconds to wait before the animation begins.',
		},
		{
			name: 'duration',
			type: 'number',
			default: '0.3',
			description: 'Total animation duration distributed as stagger across all segments.',
		},
		{ name: 'class', type: 'string', description: 'Class applied to the container element.' },
		{
			name: 'segmentClass',
			type: 'string',
			description: 'Class applied to each animated segment span.',
		},
		{
			name: 'accessible',
			type: 'boolean',
			default: 'true',
			description: 'Adds a screen-reader-only copy and aria-hidden on the visual segments.',
		},
	],
};
