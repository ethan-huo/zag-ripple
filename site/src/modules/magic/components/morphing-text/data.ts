import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './morphing-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'morphing-text',
	title: 'Morphing Text',
	description: 'Words dissolve and merge into each other via an SVG threshold filter, creating a liquid morph effect.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'morphing-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'texts', type: 'string[]', required: true, description: 'List of words to cycle through.' },
		{ name: 'class', type: 'string', description: 'Additional class names for the container.' },
	],
};
