import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './progressive-blur.tsrx?raw';

export const data: ComponentEntry = {
	id: 'progressive-blur',
	title: 'Progressive Blur',
	description: 'A stacked backdrop-filter overlay that ramps blur intensity across its height for a smooth glass-fade effect.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'progressive-blur.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'height', type: 'string', default: '"30%"', description: 'Height of the blur overlay. Ignored when position is "both".' },
		{ name: 'position', type: '"top" | "bottom" | "both"', default: '"bottom"', description: 'Which edge (or full height) the blur covers.' },
		{ name: 'blurLevels', type: 'number[]', default: '[0.5,1,2,4,8,16,32,64]', description: 'Array of blur radii (px) from transparent edge to opaque edge. Length determines band count.' },
		{ name: 'class', type: 'string', description: 'Additional CSS classes.' },
	],
};
