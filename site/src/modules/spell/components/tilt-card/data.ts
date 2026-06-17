import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './tilt-card.tsrx?raw';

export const data: ComponentEntry = {
	id: 'tilt-card',
	title: 'Tilt Card',
	description: 'A pointer-reactive 3D tilt surface with a cursor-following spotlight.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'tilt-card.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children' },
		{ name: 'tiltLimit', type: 'number', default: '15', description: 'Max tilt in degrees.' },
		{ name: 'scale', type: 'number', default: '1.05' },
		{ name: 'perspective', type: 'number', default: '1200' },
		{ name: 'effect', type: '"gravitate" | "evade"', default: '"evade"' },
		{ name: 'spotlight', type: 'boolean', default: 'true' },
	],
};
