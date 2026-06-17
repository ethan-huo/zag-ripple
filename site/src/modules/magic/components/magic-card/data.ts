import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './magic-card.tsrx?raw';

export const data: ComponentEntry = {
	id: 'magic-card',
	title: 'Magic Card',
	description: 'A card that reveals a glowing radial gradient border and overlay as the cursor moves across it.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'magic-card.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children' },
		{ name: 'class', type: 'string', description: 'Extra CSS classes applied to the card wrapper.' },
		{ name: 'gradientSize', type: 'number', default: '200', description: 'Radius (px) of the radial gradient circle.' },
		{ name: 'gradientColor', type: 'string', default: '"#262626"', description: 'Fill color of the overlay gradient center.' },
		{ name: 'gradientOpacity', type: 'number', default: '0.8', description: 'Opacity of the overlay gradient layer.' },
		{ name: 'gradientFrom', type: 'string', default: '"#9E7AFF"', description: 'Start color of the border gradient.' },
		{ name: 'gradientTo', type: 'string', default: '"#FE8BBB"', description: 'End color of the border gradient.' },
	],
};
