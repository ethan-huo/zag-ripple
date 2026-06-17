import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './randomized-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'randomized-text',
	title: 'Randomized Text',
	description: 'Words or characters fade in with staggered, deterministic delays for a randomized entrance.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'randomized-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'The text to animate.' },
		{ name: 'split', type: '"words" | "chars"', default: '"words"', description: 'Split into words or individual characters.' },
		{ name: 'delay', type: 'number', default: '0.2', description: 'Base stagger delay (seconds) applied to each segment.' },
		{ name: 'duration', type: 'number', default: '1.2', description: 'Fade-in duration per segment (seconds).' },
		{ name: 'trigger', type: 'boolean', default: 'true', description: 'Start animation immediately when true.' },
		{ name: 'triggerOnView', type: 'boolean', default: 'false', description: 'Delay animation until the element scrolls into view.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'When triggerOnView is set, animate only the first time.' },
	],
};
