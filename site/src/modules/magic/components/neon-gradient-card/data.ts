import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './neon-gradient-card.tsrx?raw';

export const data: ComponentEntry = {
	id: 'neon-gradient-card',
	title: 'Neon Gradient Card',
	description:
		'A card with a spinning neon gradient border and a soft glowing halo behind it.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'neon-gradient-card.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'Children' },
		{ name: 'class', type: 'string', description: 'Extra classes on the outer wrapper.' },
		{
			name: 'borderSize',
			type: 'number',
			default: '2',
			description: 'Neon border thickness in pixels.',
		},
		{
			name: 'borderRadius',
			type: 'number',
			default: '20',
			description: 'Corner radius in pixels.',
		},
		{
			name: 'neonColors',
			type: '{ firstColor: string; secondColor: string }',
			default: '{ firstColor: "#ff00aa", secondColor: "#00FFF1" }',
			description: 'Start and end colors of the spinning gradient.',
		},
	],
};
