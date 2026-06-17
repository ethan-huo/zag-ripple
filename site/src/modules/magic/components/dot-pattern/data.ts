import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './dot-pattern.tsrx?raw';

export const data: ComponentEntry = {
	id: 'dot-pattern',
	title: 'Dot Pattern',
	description: 'An SVG dot grid that fills its container, with optional per-dot glow animations.',
	group: 'Backgrounds',
	preview: Preview,
	previewCode,
	source: [{ filename: 'dot-pattern.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'width', type: 'number', default: '16', description: 'Horizontal spacing between dots.' },
		{ name: 'height', type: 'number', default: '16', description: 'Vertical spacing between dots.' },
		{ name: 'cx', type: 'number', default: '1', description: 'X-offset of each dot within its cell.' },
		{ name: 'cy', type: 'number', default: '1', description: 'Y-offset of each dot within its cell.' },
		{ name: 'cr', type: 'number', default: '1', description: 'Radius of each dot.' },
		{ name: 'x', type: 'number', default: '0', description: 'X-offset of the SVG viewBox.' },
		{ name: 'y', type: 'number', default: '0', description: 'Y-offset of the SVG viewBox.' },
		{ name: 'glow', type: 'boolean', default: 'false', description: 'Enable pulsing glow animation on each dot.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the SVG element (controls dot color via currentColor).' },
	],
};
