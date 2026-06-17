import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './marquee.tsrx?raw';

export const data: ComponentEntry = {
	id: 'marquee',
	title: 'Marquee',
	description: 'An infinite scrolling ticker with optional reverse direction, vertical mode, and pause-on-hover.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'marquee.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', required: true, description: 'Content repeated across the strip.' },
		{ name: 'repeat', type: 'number', default: '4', description: 'How many times the children block is repeated.' },
		{ name: 'duration', type: 'number', default: '40', description: 'Seconds per full scroll cycle.' },
		{ name: 'gap', type: 'string', default: '"1rem"', description: 'Gap between repeated strips (CSS value).' },
		{ name: 'reverse', type: 'boolean', default: 'false', description: 'Scroll in the opposite direction.' },
		{ name: 'vertical', type: 'boolean', default: 'false', description: 'Scroll vertically instead of horizontally.' },
		{ name: 'pauseOnHover', type: 'boolean', default: 'false', description: 'Pause the animation while hovered.' },
	],
};
