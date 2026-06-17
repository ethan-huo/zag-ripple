import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './kbd.tsrx?raw';

export const data: ComponentEntry = {
	id: 'kbd',
	title: 'Keyboard Key',
	description: 'A Mac-style keycap that maps modifier names to glyphs and can react to real keypresses.',
	group: 'Keyboard',
	preview: Preview,
	previewCode,
	source: [{ filename: 'kbd.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'keys', type: '(string | { display: string; key: string })[]', default: '[]' },
		{ name: 'active', type: 'boolean', default: 'false' },
		{ name: 'listenToKeyboard', type: 'boolean', default: 'false' },
		{ name: 'class', type: 'string' },
	],
};
