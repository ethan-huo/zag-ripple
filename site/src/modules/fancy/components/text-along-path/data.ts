import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './text-along-path.tsrx?raw';

export const data: ComponentEntry = {
	id: 'text-along-path',
	title: 'Text Along Path',
	description: 'Animate text along any SVG path — looping auto-scroll or scroll-driven offset.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'text-along-path.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'path', type: 'string', required: true, description: 'SVG path data (d attribute).' },
		{ name: 'text', type: 'string', required: true, description: 'Text to animate along the path.' },
		{ name: 'animationType', type: '"auto" | "scroll"', default: '"auto"', description: 'auto loops continuously; scroll ties offset to page/container scroll progress.' },
		{ name: 'duration', type: 'number', default: '4', description: 'Loop duration in seconds (auto mode).' },
		{ name: 'repeatCount', type: 'number | "indefinite"', default: '"indefinite"', description: 'SVG animate repeatCount.' },
		{ name: 'textAnchor', type: '"start" | "middle" | "end"', default: '"start"' },
		{ name: 'showPath', type: 'boolean', default: 'false', description: 'Render the guide path visibly.' },
		{ name: 'viewBox', type: 'string', default: '"0 0 100 100"' },
		{ name: 'width', type: 'string | number', default: '"100%"' },
		{ name: 'height', type: 'string | number', default: '"100%"' },
		{ name: 'pathId', type: 'string', description: 'Override the auto-generated path ID.' },
		{ name: 'svgClass', type: 'string', description: 'Class applied to the <svg> element.' },
		{ name: 'pathClass', type: 'string', description: 'Class applied to the <path> element.' },
		{ name: 'textClass', type: 'string', description: 'Class applied to the <textPath> elements.' },
		{ name: 'easingFunction', type: '{ calcMode?, keyTimes?, keySplines? }', default: '{}', description: 'SVG SMIL easing overrides.' },
		{ name: 'scrollContainer', type: 'HTMLElement | null', description: 'Scroll source for scroll mode (defaults to window).' },
		{ name: 'scrollTransformValues', type: '[number, number]', default: '[0, 100]', description: 'startOffset % range mapped to [0%, 100%] scroll progress.' },
	],
};
