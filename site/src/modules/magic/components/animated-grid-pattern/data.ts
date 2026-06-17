import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-grid-pattern.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-grid-pattern',
	title: 'Animated Grid Pattern',
	description: 'An SVG grid where random cells pulse in and out, creating a living background texture.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-grid-pattern.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'width', type: 'number', default: '40', description: 'Grid cell width in pixels.' },
		{ name: 'height', type: 'number', default: '40', description: 'Grid cell height in pixels.' },
		{ name: 'x', type: 'number', default: '-1', description: 'Pattern x offset.' },
		{ name: 'y', type: 'number', default: '-1', description: 'Pattern y offset.' },
		{ name: 'strokeDasharray', type: 'number', default: '0', description: 'Stroke dash array for grid lines.' },
		{ name: 'numSquares', type: 'number', default: '50', description: 'Number of animated squares.' },
		{ name: 'maxOpacity', type: 'number', default: '0.5', description: 'Peak opacity of each animated square.' },
		{ name: 'duration', type: 'number', default: '4', description: 'Fade in/out duration in seconds.' },
		{ name: 'repeatDelay', type: 'number', default: '0.5', description: 'Pause between fade-in and fade-out.' },
	],
};
