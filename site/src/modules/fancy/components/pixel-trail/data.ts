import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './pixel-trail.tsrx?raw';

export const data: ComponentEntry = {
	id: 'pixel-trail',
	title: 'Pixel Trail',
	description: 'A grid of pixels that light up and fade as the cursor moves over them.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'pixel-trail.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'pixelSize', type: 'number', default: '20', description: 'Size of each pixel cell in pixels.' },
		{ name: 'fadeDuration', type: 'number', default: '500', description: 'Time in ms for each pixel to fade out after flashing.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Delay in ms before the fade starts.' },
		{ name: 'class', type: 'string', description: 'Additional classes for the container.' },
		{ name: 'pixelClassName', type: 'string', description: 'Classes applied to each individual pixel dot.' },
	],
};
