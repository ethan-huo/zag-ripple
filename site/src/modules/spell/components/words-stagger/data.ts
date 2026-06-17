import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './words-stagger.tsrx?raw';

export const data: ComponentEntry = {
	id: 'words-stagger',
	title: 'Words Stagger',
	description: 'Animates each word with a staggered opacity, vertical drift, and blur reveal.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'words-stagger.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'Text to animate.' },
		{ name: 'as', type: 'string', default: '"div"', description: 'HTML tag for the container.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Delay in seconds before the stagger starts.' },
		{ name: 'stagger', type: 'number', default: '0.1', description: 'Delay in seconds between each word.' },
		{ name: 'speed', type: 'number', default: '0.5', description: 'Duration in seconds for each word animation.' },
		{ name: 'trigger', type: 'boolean', default: 'true', description: 'When false, the animation is held.' },
		{ name: 'triggerOnView', type: 'boolean', default: 'false', description: 'Animate when scrolled into view.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'Only animate once on first intersection.' },
		{ name: 'onStart', type: '() => void', description: 'Called when the animation begins.' },
		{ name: 'onComplete', type: '() => void', description: 'Called when the last word finishes animating.' },
	],
};
