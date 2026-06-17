import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './backlight.tsrx?raw';

export const data: ComponentEntry = {
	id: 'backlight',
	title: 'Backlight',
	description: 'Wraps any children in an SVG bloom filter — blur + saturate + composite — for a vivid backlight glow effect.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'backlight.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'blur', type: 'number', default: '10', description: 'Gaussian blur radius for the glow spread.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the outer wrapper.' },
		{ name: 'children', type: 'ReactNode', required: true, description: 'Content to apply the backlight effect to.' },
	],
};
