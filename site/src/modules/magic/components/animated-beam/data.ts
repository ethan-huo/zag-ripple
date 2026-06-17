import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-beam.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-beam',
	title: 'Animated Beam',
	description: 'Draws an animated gradient beam between two DOM elements along a curved SVG path.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-beam.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'containerRef', type: 'Tracked<HTMLElement | null>', required: true, description: 'Ref to the positioned container element.' },
		{ name: 'fromRef', type: 'Tracked<HTMLElement | null>', required: true, description: 'Ref to the beam start element.' },
		{ name: 'toRef', type: 'Tracked<HTMLElement | null>', required: true, description: 'Ref to the beam end element.' },
		{ name: 'curvature', type: 'number', default: '0', description: 'Vertical curvature of the path in pixels.' },
		{ name: 'reverse', type: 'boolean', default: 'false', description: 'Animate gradient from end to start.' },
		{ name: 'duration', type: 'number', default: 'random 4-7', description: 'Animation cycle duration in seconds.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Animation start delay in seconds.' },
		{ name: 'pathColor', type: 'string', default: '"gray"', description: 'Color of the background path.' },
		{ name: 'pathWidth', type: 'number', default: '2', description: 'Stroke width of the path.' },
		{ name: 'pathOpacity', type: 'number', default: '0.2', description: 'Opacity of the background path.' },
		{ name: 'gradientStartColor', type: 'string', default: '"#ffaa40"', description: 'Gradient start color.' },
		{ name: 'gradientStopColor', type: 'string', default: '"#9c40ff"', description: 'Gradient end color.' },
		{ name: 'startXOffset', type: 'number', default: '0', description: 'Horizontal offset from the start element center.' },
		{ name: 'startYOffset', type: 'number', default: '0', description: 'Vertical offset from the start element center.' },
		{ name: 'endXOffset', type: 'number', default: '0', description: 'Horizontal offset from the end element center.' },
		{ name: 'endYOffset', type: 'number', default: '0', description: 'Vertical offset from the end element center.' },
	],
};
