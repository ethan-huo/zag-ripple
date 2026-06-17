import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './letter-3d-swap.tsrx?raw';

export const data: ComponentEntry = {
	id: 'letter-3d-swap',
	title: 'Letter 3D Swap',
	description: 'Each character flips in 3D on hover, swapping to a second face with a spring-staggered animation.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'letter-3d-swap.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'text', type: 'string', required: true, description: 'Text content to animate.' },
		{ name: 'rotateDirection', type: '"top" | "right" | "bottom" | "left"', default: '"right"', description: 'Axis and direction of the 3D flip.' },
		{ name: 'staggerFrom', type: '"first" | "last" | "center" | "random" | number', default: '"first"', description: 'Which character triggers the stagger origin.' },
		{ name: 'staggerDuration', type: 'number', default: '0.05', description: 'Delay between each staggered character (seconds).' },
		{ name: 'transition', type: 'object', default: '{ type: "spring", damping: 30, stiffness: 300 }', description: 'Motion transition options passed to the flip animation.' },
		{ name: 'frontFaceClass', type: 'string', description: 'Class applied to the front face of each character.' },
		{ name: 'secondFaceClass', type: 'string', description: 'Class applied to the second (back) face of each character.' },
		{ name: 'mainClass', type: 'string', description: 'Class applied to the wrapper element.' },
	],
};
