import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './meteors.tsrx?raw';

export const data: ComponentEntry = {
	id: 'meteors',
	title: 'Meteors',
	description: 'A randomized shower of diagonal meteors for hero backgrounds.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'meteors.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'number', type: 'number', default: '20' },
		{ name: 'angle', type: 'number', default: '215' },
		{ name: 'minDelay', type: 'number', default: '0.2' },
		{ name: 'maxDelay', type: 'number', default: '1.2' },
		{ name: 'minDuration', type: 'number', default: '2' },
		{ name: 'maxDuration', type: 'number', default: '10' },
	],
};
