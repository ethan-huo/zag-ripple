import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './special-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'special-text',
	title: 'Special Text',
	description: 'A two-phase scramble-then-reveal text animation that decodes random characters into the real string.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'special-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', description: 'Text to animate. If omitted, text is read from children.' },
		{ name: 'children', type: 'Children', description: 'Slotted text content (used when `text` is not provided).' },
		{ name: 'speed', type: 'number', default: '20', description: 'Milliseconds per animation tick.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Seconds to wait before starting (used with inView).' },
		{ name: 'inView', type: 'boolean', default: 'false', description: 'Trigger animation when element enters the viewport.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'When inView is true, replay each time the element re-enters.' },
		{ name: 'class', type: 'string', description: 'Additional CSS classes.' },
	],
};
