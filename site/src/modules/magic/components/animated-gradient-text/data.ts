import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-gradient-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-gradient-text',
	title: 'Animated Gradient Text',
	description: 'Inline text that cycles through a colour gradient via a CSS background-position animation.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-gradient-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'ComponentChildren', required: true },
		{ name: 'colorFrom', type: 'string', default: "'#ffaa40'", description: 'Start and repeat colour of the gradient.' },
		{ name: 'colorTo', type: 'string', default: "'#9c40ff'", description: 'Middle (via) colour of the gradient.' },
		{ name: 'speed', type: 'number', default: '1', description: 'Gradient background-size multiplier; higher = slower apparent movement per cycle.' },
		{ name: 'class', type: 'string' },
	],
};
