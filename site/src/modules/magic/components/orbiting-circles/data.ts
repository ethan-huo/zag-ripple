import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './orbiting-circles.tsrx?raw';

export const data: ComponentEntry = {
	id: 'orbiting-circles',
	title: 'Orbiting Circles',
	description: 'Icons orbit a center element at configurable radius, speed, and direction.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'orbiting-circles.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'reverse', type: 'boolean', default: 'false', description: 'Reverse the orbit direction.' },
		{ name: 'duration', type: 'number', default: '20', description: 'Base orbit duration in seconds.' },
		{ name: 'radius', type: 'number', default: '160', description: 'Orbit radius in pixels.' },
		{ name: 'path', type: 'boolean', default: 'false', description: 'Show a dashed circular guide path.' },
		{ name: 'iconSize', type: 'number', default: '30', description: 'Diameter of the orbiting element in pixels.' },
		{ name: 'speed', type: 'number', default: '1', description: 'Speed multiplier (divides duration).' },
		{ name: 'angle', type: 'number', default: '0', description: 'Starting angle in degrees.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Animation start delay in seconds (negative values start mid-orbit).' },
	],
};
