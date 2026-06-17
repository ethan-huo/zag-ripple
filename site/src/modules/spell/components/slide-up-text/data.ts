import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './slide-up-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'slide-up-text',
	title: 'Slide Up Text',
	description: 'Reveals text by sliding each word, character, or line up from below a clipping mask.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'slide-up-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'Plain text content to animate. Alternatively, pass a plain string as children.' },
		{ name: 'split', type: '"words" | "characters" | "lines"', default: '"words"', description: 'Unit of animation.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Initial delay in seconds before any unit starts.' },
		{ name: 'stagger', type: 'number', default: '0.1', description: 'Delay added between consecutive units.' },
		{ name: 'from', type: '"first" | "last" | "center"', default: '"first"', description: 'Direction from which stagger spreads.' },
		{ name: 'duration', type: 'number', default: '0.5', description: 'Duration of the slide animation per unit in seconds.' },
		{ name: 'ease', type: 'EasingDefinition', default: '[0.625, 0.05, 0, 1]', description: 'Easing curve for the slide.' },
		{ name: 'autoStart', type: 'boolean', default: 'true', description: 'Play animation automatically on mount.' },
		{ name: 'triggerOnView', type: 'boolean', default: 'false', description: 'Delay start until the element scrolls into the viewport.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'When triggerOnView is true, play only on the first intersection.' },
		{ name: 'wordClass', type: 'string', description: 'Extra classes applied to each word/group wrapper.' },
		{ name: 'charClass', type: 'string', description: 'Extra classes applied to each character overflow wrapper.' },
		{ name: 'onStart', type: '() => void', description: 'Called when the animation begins.' },
		{ name: 'onComplete', type: '() => void', description: 'Called when all units have finished animating.' },
	],
};
