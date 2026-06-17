import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-shiny-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-shiny-text',
	title: 'Animated Shiny Text',
	description: 'A shine that sweeps across muted text — great for pills and announcements.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-shiny-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', required: true },
		{ name: 'shimmerWidth', type: 'number', default: '100', description: 'Shine width in pixels.' },
		{ name: 'duration', type: 'number', default: '8', description: 'Seconds per sweep.' },
	],
};
