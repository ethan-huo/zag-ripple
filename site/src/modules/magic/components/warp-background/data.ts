import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './warp-background.tsrx?raw';

export const data: ComponentEntry = {
	id: 'warp-background',
	title: 'Warp Background',
	description:
		'A 3-D perspective grid on all four sides that shoots random-hued light beams inward, creating a warp-tunnel framing effect.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'warp-background.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'perspective', type: 'number', default: '100', description: 'CSS perspective depth in pixels. Lower values = more dramatic foreshortening.' },
		{ name: 'beamsPerSide', type: 'number', default: '3', description: 'Number of beams on each of the four grid faces.' },
		{ name: 'beamSize', type: 'number', default: '5', description: 'Beam (and grid cell) width as a percentage of the face width.' },
		{ name: 'beamDelayMin', type: 'number', default: '0', description: 'Minimum random delay before a beam\'s first pass (seconds).' },
		{ name: 'beamDelayMax', type: 'number', default: '3', description: 'Maximum random delay before a beam\'s first pass (seconds).' },
		{ name: 'beamDuration', type: 'number', default: '3', description: 'Time for a beam to travel the full length of a grid face (seconds).' },
		{ name: 'gridColor', type: 'string', default: '"var(--border)"', description: 'CSS color for the perspective grid lines.' },
	],
};
