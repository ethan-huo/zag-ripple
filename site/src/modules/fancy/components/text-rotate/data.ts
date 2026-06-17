import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './text-rotate.tsrx?raw';

export const data: ComponentEntry = {
	id: 'text-rotate',
	title: 'Text Rotate',
	description: 'Cycles through an array of texts with per-character staggered enter/exit animations.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'text-rotate.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'texts', type: 'string[]', required: true, description: 'Array of strings to rotate through.' },
		{ name: 'rotationInterval', type: 'number', default: '2000', description: 'Milliseconds between rotations.' },
		{ name: 'auto', type: 'boolean', default: 'true', description: 'Whether to auto-rotate on an interval.' },
		{ name: 'loop', type: 'boolean', default: 'true', description: 'Whether to loop back to the first text.' },
		{ name: 'splitBy', type: '"characters" | "words" | "lines" | string', default: '"characters"', description: 'How to split each text for animation.' },
		{ name: 'staggerDuration', type: 'number', default: '0', description: 'Seconds of stagger between each element.' },
		{ name: 'staggerFrom', type: '"first" | "last" | "center" | "random" | number', default: '"first"', description: 'Starting point for stagger delay calculation.' },
		{ name: 'initial', type: 'object', default: '{ y: "100%", opacity: 0 }', description: 'Motion keyframe for the initial (hidden) state.' },
		{ name: 'animate', type: 'object', default: '{ y: 0, opacity: 1 }', description: 'Motion keyframe for the visible state.' },
		{ name: 'exit', type: 'object', default: '{ y: "-120%", opacity: 0 }', description: 'Motion keyframe for the exit state.' },
		{ name: 'transition', type: 'object', default: '{ type: "spring", damping: 25, stiffness: 300 }', description: 'Motion transition options.' },
		{ name: 'onNext', type: '(index: number) => void', description: 'Called after each rotation with the new index.' },
		{ name: 'mainClassName', type: 'string', description: 'Class applied to the outer wrapper span.' },
		{ name: 'splitLevelClassName', type: 'string', description: 'Class applied to each word/line group span.' },
		{ name: 'elementLevelClassName', type: 'string', description: 'Class applied to each character wrapper span.' },
	],
};
