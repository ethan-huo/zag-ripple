import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './flickering-grid.tsrx?raw';

export const data: ComponentEntry = {
	id: 'flickering-grid',
	title: 'Flickering Grid',
	description: 'A canvas-drawn grid of squares whose opacities flicker independently at random intervals.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'flickering-grid.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'squareSize', type: 'number', default: '4', description: 'Side length of each square in CSS pixels.' },
		{ name: 'gridGap', type: 'number', default: '6', description: 'Gap between squares in CSS pixels.' },
		{ name: 'flickerChance', type: 'number', default: '0.3', description: 'Probability per square per second of re-randomising opacity.' },
		{ name: 'color', type: 'string', default: '"rgb(0,0,0)"', description: 'CSS color for the squares (any valid CSS color string).' },
		{ name: 'maxOpacity', type: 'number', default: '0.3', description: 'Maximum opacity a square can reach.' },
		{ name: 'width', type: 'number', description: 'Fixed canvas width in pixels; defaults to container width.' },
		{ name: 'height', type: 'number', description: 'Fixed canvas height in pixels; defaults to container height.' },
	],
};
