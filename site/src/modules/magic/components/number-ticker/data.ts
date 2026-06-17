import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './number-ticker.tsrx?raw';

export const data: ComponentEntry = {
	id: 'number-ticker',
	title: 'Number Ticker',
	description: 'Animates a number to its target with a spring when it scrolls into view.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'number-ticker.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'value', type: 'number', required: true },
		{ name: 'startValue', type: 'number', default: '0' },
		{ name: 'direction', type: '"up" | "down"', default: '"up"' },
		{ name: 'decimalPlaces', type: 'number', default: '0' },
		{ name: 'delay', type: 'number', default: '0', description: 'Milliseconds before counting.' },
		{ name: 'prefix', type: 'string', default: '""' },
		{ name: 'suffix', type: 'string', default: '""' },
	],
};
