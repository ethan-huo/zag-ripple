import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './scroll-progress.tsrx?raw';

export const data: ComponentEntry = {
	id: 'scroll-progress',
	title: 'Scroll Progress',
	description: 'A fixed top bar that fills left-to-right as the user scrolls the page.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'scroll-progress.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'class',
			type: 'string',
			description: 'Extra CSS classes forwarded to the progress bar element.',
		},
	],
};
