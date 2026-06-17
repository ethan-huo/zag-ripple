import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './interactive-hover-button.tsrx?raw';

export const data: ComponentEntry = {
	id: 'interactive-hover-button',
	title: 'Interactive Hover Button',
	description:
		'A pill button with an expanding dot fill and sliding label reveal on hover — pure Tailwind CSS transitions.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'interactive-hover-button.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'ReactNode', required: true, description: 'Button label rendered in both idle and hover states.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the <button> element.' },
	],
};
