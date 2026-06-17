import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './ripple.tsrx?raw';

export const data: ComponentEntry = {
	id: 'ripple',
	title: 'Ripple',
	description: 'Concentric pulsing rings radiating from the center as a calm background accent.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'ripple.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'mainCircleSize', type: 'number', default: '210' },
		{ name: 'mainCircleOpacity', type: 'number', default: '0.24' },
		{ name: 'numCircles', type: 'number', default: '8' },
	],
};
