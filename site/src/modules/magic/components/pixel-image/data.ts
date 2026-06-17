import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './pixel-image.tsrx?raw';

export const data: ComponentEntry = {
	id: 'pixel-image',
	title: 'Pixel Image',
	description: 'Reveals an image as a grid of pixel tiles that fade in from transparent, then transitions from grayscale to color.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'pixel-image.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'src', type: 'string', required: true, description: 'Image URL.' },
		{ name: 'grid', type: "'6x4' | '8x8' | '8x3' | '4x6' | '3x8'", default: '"6x4"', description: 'Predefined grid layout.' },
		{ name: 'customGrid', type: '{ rows: number; cols: number }', description: 'Custom grid (1–16 in each dimension); overrides grid.' },
		{ name: 'grayscaleAnimation', type: 'boolean', default: 'true', description: 'Transition from grayscale to color after colorRevealDelay.' },
		{ name: 'pixelFadeInDuration', type: 'number', default: '1000', description: 'Duration (ms) of each tile fade-in transition.' },
		{ name: 'maxAnimationDelay', type: 'number', default: '1200', description: 'Maximum random delay (ms) applied to each tile.' },
		{ name: 'colorRevealDelay', type: 'number', default: '1300', description: 'Delay (ms) after entering view before color is revealed.' },
		{ name: 'once', type: 'boolean', default: 'false', description: 'If true, the animation plays only on the first viewport entry.' },
		{ name: 'class', type: 'string', description: 'Extra CSS classes for the root wrapper.' },
	],
};
