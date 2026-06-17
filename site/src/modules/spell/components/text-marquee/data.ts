import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './text-marquee.tsrx?raw';

export const data: ComponentEntry = {
	id: 'text-marquee',
	title: 'Text Marquee',
	description: 'A vertical slot-machine ticker that cycles through text items with a smooth mask fade.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'text-marquee.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'items', type: 'any[]', required: true, description: 'Array of items to cycle through.' },
		{ name: 'renderItem', type: '(item: any, index: number) => Children', description: 'Render function for each item. Falls back to rendering the item as a string.' },
		{ name: 'prefix', type: 'Children', description: 'Static content rendered before the scrolling viewport.' },
		{ name: 'speed', type: 'number', default: '1', description: 'Seconds per item in the cycle.' },
		{ name: 'height', type: 'number', default: '200', description: 'Visible viewport height in pixels.' },
		{ name: 'itemHeight', type: 'number', default: '40', description: 'Height of each individual item in pixels.' },
	],
};
