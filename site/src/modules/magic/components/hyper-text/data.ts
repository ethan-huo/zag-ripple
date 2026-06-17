import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './hyper-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'hyper-text',
	title: 'Hyper Text',
	description:
		'Characters scramble through random glyphs and progressively settle to the real text, triggered on mount, scroll-into-view, or hover.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'hyper-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'The text to animate.' },
		{ name: 'duration', type: 'number', default: '800', description: 'Scramble animation duration in ms.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Delay before animation starts (ms).' },
		{ name: 'as', type: '"div" | "span" | "p" | "h1" | "h2" | "h3" | "h4" | "h5" | "h6"', default: '"div"', description: 'HTML tag to render.' },
		{ name: 'startOnView', type: 'boolean', default: 'false', description: 'Trigger animation when scrolled into view.' },
		{ name: 'animateOnHover', type: 'boolean', default: 'true', description: 'Re-trigger scramble on mouse enter.' },
		{ name: 'characterSet', type: 'string[]', default: 'A–Z', description: 'Pool of characters used during scramble.' },
	],
};
