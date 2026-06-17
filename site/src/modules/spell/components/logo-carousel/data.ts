import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './logo-carousel.tsrx?raw';

export const data: ComponentEntry = {
	id: 'logo-carousel',
	title: 'Logo Carousel',
	description: 'Cycles through groups of logos with a staggered blur-and-slide animation.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'logo-carousel.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'items', type: 'T[]', required: true, description: 'Array of items to display.' },
		{ name: 'renderItem', type: '(item: T, index: number) => JSX', required: true, description: 'Render function for each item.' },
		{ name: 'count', type: 'number', description: 'Items per group. Defaults to all items (single group, no looping).' },
		{ name: 'stagger', type: 'number', default: '0.14', description: 'Delay between item animations in seconds.' },
		{ name: 'duration', type: 'number', default: '600', description: 'Animation duration in milliseconds.' },
		{ name: 'interval', type: 'number', default: '2500', description: 'Milliseconds between group transitions.' },
		{ name: 'initialDelay', type: 'number', default: '500', description: 'Delay before the first transition starts.' },
		{ name: 'class', type: 'string', description: 'Extra classes applied to each row wrapper.' },
	],
};
