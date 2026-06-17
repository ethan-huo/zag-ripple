import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './smooth-cursor.tsrx?raw';

export const data: ComponentEntry = {
	id: 'smooth-cursor',
	title: 'Smooth Cursor',
	description:
		'A spring-physics custom cursor that follows the mouse with velocity-driven rotation and squish on movement.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'smooth-cursor.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{
			name: 'cursor',
			type: 'ReactNode',
			description: 'Custom cursor element. Defaults to the built-in arrow SVG.',
		},
		{
			name: 'springConfig',
			type: '{ damping: number; stiffness: number; mass: number; restDelta: number }',
			default: '{ damping: 45, stiffness: 400, mass: 1, restDelta: 0.001 }',
			description: 'Spring physics config shared across position, rotation, and scale springs.',
		},
	],
};
