import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './striped-pattern.tsrx?raw';

export const data: ComponentEntry = {
	id: 'striped-pattern',
	title: 'Striped Pattern',
	description: 'An SVG diagonal stripe pattern that tiles to fill its container, with left or right direction.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'striped-pattern.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'direction', type: '"left" | "right"', default: '"left"', description: 'Direction the stripes slant.' },
		{ name: 'width', type: 'number', default: '10', description: 'Width of each pattern tile in pixels.' },
		{ name: 'height', type: 'number', default: '10', description: 'Height of each pattern tile in pixels.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the SVG element (controls stripe color via currentColor).' },
	],
};
