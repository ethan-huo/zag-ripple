import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './shimmer-button.tsrx?raw';

export const data: ComponentEntry = {
	id: 'shimmer-button',
	title: 'Shimmer Button',
	description: 'A button with a travelling shimmer arc driven entirely by CSS animations.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'shimmer-button.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'shimmerColor', type: 'string', default: '"#ffffff"', description: 'Color of the shimmer arc.' },
		{ name: 'shimmerSize', type: 'string', default: '"0.05em"', description: 'Thickness of the inner backdrop cutout, controls how wide the shimmer ring appears.' },
		{ name: 'shimmerDuration', type: 'string', default: '"3s"', description: 'Duration of one full shimmer cycle.' },
		{ name: 'borderRadius', type: 'string', default: '"100px"', description: 'Border radius of the button.' },
		{ name: 'background', type: 'string', default: '"rgba(0, 0, 0, 1)"', description: 'Background color of the button face.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the button element.' },
	],
};
