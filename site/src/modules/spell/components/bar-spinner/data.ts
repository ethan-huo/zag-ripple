import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './bar-spinner.tsrx?raw';

export const data: ComponentEntry = {
	id: 'bar-spinner',
	title: 'Bar Spinner',
	description: 'A twelve-bar fading spinner rendered purely with CSS.',
	group: 'Loaders',
	preview: Preview,
	previewCode,
	source: [{ filename: 'bar-spinner.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'size', type: 'number', default: '20', description: 'Width/height in pixels.' },
		{ name: 'color', type: 'string', default: '"currentColor"' },
		{ name: 'class', type: 'string' },
	],
};
