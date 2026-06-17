import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './shiny-button.tsrx?raw';

export const data: ComponentEntry = {
	id: 'shiny-button',
	title: 'Shiny Button',
	description: 'A button with an infinite shimmer sweep driven by a CSS custom property animation.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'shiny-button.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'children', type: 'ReactNode', required: true, description: 'Button label content.' },
		{ name: 'class', type: 'string', description: 'Extra Tailwind classes on the button.' },
	],
};
