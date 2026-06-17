import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './border-beam.tsrx?raw';

export const data: ComponentEntry = {
	id: 'border-beam',
	title: 'Border Beam',
	description: 'A gradient beam that travels around a container border via offset-path.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'border-beam.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'size', type: 'number', default: '50', description: 'Beam length in pixels.' },
		{ name: 'duration', type: 'number', default: '6' },
		{ name: 'delay', type: 'number', default: '0' },
		{ name: 'colorFrom', type: 'string', default: '"#ffaa40"' },
		{ name: 'colorTo', type: 'string', default: '"#9c40ff"' },
		{ name: 'reverse', type: 'boolean', default: 'false' },
		{ name: 'borderWidth', type: 'number', default: '1' },
	],
};
