import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './perspective-book.tsrx?raw';

export const data: ComponentEntry = {
	id: 'perspective-book',
	title: 'Perspective Book',
	description: 'A CSS-only 3D book that opens on hover with a perspective transform.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'perspective-book.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', description: 'Content rendered on the front cover.' },
		{
			name: 'size',
			type: '"sm" | "default" | "lg"',
			default: '"default"',
			description: 'Controls the book width and spine offset.',
		},
		{
			name: 'class',
			type: 'string',
			description:
				'Override the cover colour classes. Omit to use the built-in light/dark default.',
		},
		{
			name: 'textured',
			type: 'boolean',
			default: 'false',
			description:
				'Overlay a paper-grain texture (requires /perspective-book-texture.avif in /public).',
		},
		{ name: 'style', type: 'string', description: 'Inline style applied to the outer wrapper.' },
	],
};
