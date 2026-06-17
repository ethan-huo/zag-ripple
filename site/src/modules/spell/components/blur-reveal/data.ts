import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './blur-reveal.tsrx?raw';

export const data: ComponentEntry = {
	id: 'blur-reveal',
	title: 'Blur Reveal',
	description: 'Reveals text character by character, each letter fading in from blurred to crisp.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'blur-reveal.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'The text to animate.' },
		{ name: 'as', type: '"span" | "div" | "p" | "h1" | "h2" | "h3" | "h4" | "h5" | "h6"', default: '"p"', description: 'HTML tag to render.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Seconds to wait before the reveal starts.' },
		{ name: 'speedReveal', type: 'number', default: '1.5', description: 'Controls the stagger speed across characters.' },
		{ name: 'speedSegment', type: 'number', default: '0.5', description: 'Controls how fast each character animates.' },
		{ name: 'stagger', type: 'number', description: 'Explicit stagger seconds (overrides speedReveal).' },
		{ name: 'duration', type: 'number', description: 'Explicit per-character duration in seconds (overrides speedSegment).' },
		{ name: 'trigger', type: 'boolean', default: 'true', description: 'Set false to hold the hidden state.' },
		{ name: 'triggerOnView', type: 'boolean', default: 'false', description: 'Animate when the element scrolls into view.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'With triggerOnView: animate only the first time.' },
		{ name: 'letterSpacing', type: 'string | number', description: 'Extra spacing after each character (px if number).' },
		{ name: 'onStart', type: '() => void', description: 'Called when the reveal animation begins.' },
		{ name: 'onComplete', type: '() => void', description: 'Called when the last character finishes animating.' },
		{ name: 'class', type: 'string' },
	],
};
