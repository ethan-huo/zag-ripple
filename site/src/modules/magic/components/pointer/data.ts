import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './pointer.tsrx?raw';

export const data: ComponentEntry = {
	id: 'pointer',
	title: 'Pointer',
	description: 'A custom cursor that follows the pointer inside its parent container.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'pointer.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', description: 'Custom cursor content. Defaults to an arrow SVG.' },
		{ name: 'class', type: 'string', description: 'Extra classes applied to the default SVG cursor.' },
	],
};
