import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './typing-animation.tsrx?raw';

export const data: ComponentEntry = {
	id: 'typing-animation',
	title: 'Typing Animation',
	description:
		'Types and optionally deletes text, cycling through a list of words with a blinking cursor.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'typing-animation.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'content', type: 'string', description: 'Single string to type.' },
		{ name: 'words', type: 'string[]', description: 'List of words to cycle through.' },
		{ name: 'duration', type: 'number', default: '100', description: 'Base character delay (ms).' },
		{ name: 'typeSpeed', type: 'number', description: 'Override typing speed (ms). Defaults to duration.' },
		{ name: 'deleteSpeed', type: 'number', description: 'Override delete speed (ms). Defaults to typeSpeed / 2.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Initial delay before the first character is typed (ms).' },
		{ name: 'pauseDelay', type: 'number', default: '1000', description: 'Pause at end of word before deleting (ms).' },
		{ name: 'loop', type: 'boolean', default: 'false', description: 'Restart from the first word after completing the list.' },
		{ name: 'startOnView', type: 'boolean', default: 'true', description: 'Wait until the element enters the viewport.' },
		{ name: 'showCursor', type: 'boolean', default: 'true', description: 'Show the cursor while typing.' },
		{ name: 'blinkCursor', type: 'boolean', default: 'true', description: 'Animate the cursor with a blink.' },
		{ name: 'cursorStyle', type: '"line" | "block" | "underscore"', default: '"line"', description: 'Cursor character style.' },
		{ name: 'class', type: 'string' },
	],
};
