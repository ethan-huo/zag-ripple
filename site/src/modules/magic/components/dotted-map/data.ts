import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './dotted-map.tsrx?raw';

export const data: ComponentEntry = {
	id: 'dotted-map',
	title: 'Dotted Map',
	description: 'An SVG world map rendered as a grid of dots, with optional geo-coordinate markers.',
	group: 'Patterns',
	preview: Preview,
	previewCode,
	source: [{ filename: 'dotted-map.tsrx', code: source, lang: 'tsx' }],
	packages: ['piri'],
	props: [
		{ name: 'width', type: 'number', default: '150', description: 'SVG viewBox width (dot-grid columns).' },
		{ name: 'height', type: 'number', default: '75', description: 'SVG viewBox height (dot-grid rows).' },
		{ name: 'mapSamples', type: 'number', default: '5000', description: 'Number of sample points used to generate the world outline.' },
		{ name: 'dotRadius', type: 'number', default: '0.2', description: 'Radius of each map dot.' },
		{ name: 'dotColor', type: 'string', default: '"currentColor"', description: 'Fill color of the dots. Accepts any CSS color.' },
		{ name: 'markerColor', type: 'string', default: '"#FF6900"', description: 'Fill color for geo markers.' },
		{ name: 'markers', type: 'Marker[]', default: '[]', description: 'Array of {lat, lng, size?} objects to pin on the map.' },
		{ name: 'stagger', type: 'boolean', default: 'true', description: 'Use diagonal grid layout when true, vertical when false.' },
	],
};
