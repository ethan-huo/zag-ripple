import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-theme-toggler.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-theme-toggler',
	title: 'Animated Theme Toggler',
	description:
		'A theme toggle button that uses the View Transition API to animate a radial reveal when switching between light and dark modes.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-theme-toggler.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'duration',
			type: 'number',
			default: '400',
			description: 'Duration of the View Transition reveal animation in milliseconds.',
		},
		{ name: 'class', type: 'string', description: 'Additional CSS classes for the button.' },
	],
};
