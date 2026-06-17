import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './marquee.tsrx?raw';

export const data: ComponentEntry = {
	id: 'marquee',
	title: 'Marquee',
	description: 'An infinite, seamless scroller with optional fade and pause-on-hover.',
	group: 'Layout',
	preview: Preview,
	previewCode,
	source: [{ filename: 'marquee.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', required: true },
		{ name: 'duration', type: 'number', default: '20', description: 'Seconds for one loop.' },
		{ name: 'direction', type: '"left" | "right" | "up" | "down"', default: '"left"' },
		{ name: 'pauseOnHover', type: 'boolean', default: 'false' },
		{ name: 'fade', type: 'boolean', default: 'true' },
		{ name: 'fadeAmount', type: 'number', default: '10' },
	],
};
