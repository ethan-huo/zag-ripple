import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './fallback-avatar.tsrx?raw';

export const data: ComponentEntry = {
	id: 'fallback-avatar',
	title: 'Fallback Avatar',
	description: 'A canvas avatar that generates a unique animated gradient from any name string, with WebGL and 2D canvas fallback.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'fallback-avatar.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'name', type: 'string', required: true, description: 'Seed string — same name always produces the same colors and pattern.' },
		{ name: 'size', type: 'number', default: '32', description: 'CSS width and height of the canvas in pixels.' },
		{ name: 'animated', type: 'boolean', default: 'true', description: 'Enables hover-driven animation. Set to false to render a static frame.' },
		{ name: 'class', type: 'string', description: 'Extra CSS classes forwarded to the canvas element.' },
		{ name: 'style', type: 'string', description: 'Inline style string merged with the component own styles.' },
	],
};
