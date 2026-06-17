import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './scroll-and-swap.tsrx?raw';

export const data: ComponentEntry = {
	id: 'scroll-and-swap',
	title: 'Scroll And Swap',
	description: 'Two stacked text spans swap via a spring-smoothed scroll-progress value as the element travels through the viewport.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'scroll-and-swap.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'Text content to animate. Pass children instead to derive text from slot content.' },
		{ name: 'as', type: 'string', default: '"span"', description: 'HTML tag to render as the root element.' },
		{ name: 'scrollContainer', type: 'HTMLElement | null', default: 'null', description: 'Scroll container element; defaults to the document scroll element.' },
		{ name: 'offset', type: 'string[]', default: '["0 0", "0 1"]', description: 'Scroll offset — when progress starts and ends.' },
		{ name: 'springConfig', type: '{ stiffness: number; damping: number }', default: '{ stiffness: 200, damping: 30 }', description: 'Spring parameters for smoothing the raw scroll progress.' },
	],
};
