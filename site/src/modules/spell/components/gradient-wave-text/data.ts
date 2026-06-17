import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './gradient-wave-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'gradient-wave-text',
	title: 'Gradient Wave Text',
	description: 'A gradient that sweeps upward through text on a requestAnimationFrame loop.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'gradient-wave-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children', required: true },
		{ name: 'speed', type: 'number', default: '1' },
		{ name: 'repeat', type: 'boolean', default: 'false' },
		{ name: 'radial', type: 'boolean', default: 'true' },
		{ name: 'triggerOnView', type: 'boolean', default: 'false' },
		{ name: 'customColors', type: 'string[]', description: 'Override the default band colors.' },
		{ name: 'bandCount', type: 'number', default: '8' },
		{ name: 'bandGap', type: 'number', default: '4' },
	],
};
