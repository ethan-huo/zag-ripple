import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './glare-hover.tsrx?raw';

export const data: ComponentEntry = {
	id: 'glare-hover',
	title: 'Glare Hover',
	description: 'A hover card with a sweeping glare effect driven by CSS transitions and custom properties.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'glare-hover.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', description: 'Content rendered inside the card.' },
		{ name: 'background', type: 'string', default: '"#000"', description: 'Card background color.' },
		{ name: 'color', type: '`#${string}`', default: '"#ffffff"', description: 'Glare highlight color (hex).' },
		{ name: 'opacity', type: 'number', default: '0.5', description: 'Opacity of the glare highlight.' },
		{ name: 'angle', type: 'number', default: '-45', description: 'Gradient angle of the glare sweep in degrees.' },
		{ name: 'size', type: 'number', default: '250', description: 'Size of the glare spot as a percentage.' },
		{ name: 'duration', type: 'number', default: '650', description: 'Transition duration in milliseconds.' },
		{ name: 'playOnce', type: 'boolean', default: 'false', description: 'When true, the glare only animates in on hover (no reverse transition).' },
		{ name: 'width', type: 'string', description: 'Explicit width override.' },
		{ name: 'height', type: 'string', description: 'Explicit height override.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the root element.' },
	],
};
