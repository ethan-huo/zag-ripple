import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './signature.tsrx?raw';

export const data: ComponentEntry = {
	id: 'signature',
	title: 'Signature',
	description:
		'Renders text as animated SVG paths drawn with a stroke-reveal effect using the Lastoria Bold font via opentype.js.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'signature.tsrx', code: source, lang: 'tsx' }],
	packages: ['opentype.js'],
	props: [
		{ name: 'text', type: 'string', default: '"Signature"', description: 'Text to render as an animated signature.' },
		{ name: 'color', type: 'string', default: '"currentColor"', description: 'Stroke and fill color of the paths.' },
		{ name: 'fontSize', type: 'number', default: '14', description: 'Font size in SVG units.' },
		{ name: 'duration', type: 'number', default: '1.5', description: 'Duration in seconds for the stroke-draw animation.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Initial delay in seconds before the animation starts.' },
		{ name: 'inView', type: 'boolean', default: 'false', description: 'Trigger the animation only when the element scrolls into view.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'When inView is true, only animate once on first intersection.' },
		{ name: 'class', type: 'string', description: 'Extra CSS classes applied to the SVG element.' },
	],
};
