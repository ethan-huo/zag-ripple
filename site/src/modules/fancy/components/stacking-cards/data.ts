import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './stacking-cards.tsrx?raw';

export const data: ComponentEntry = {
	id: 'stacking-cards',
	title: 'Stacking Cards',
	description: 'Cards stack and shrink as you scroll, creating a layered depth effect driven by scroll progress.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'stacking-cards.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'items',
			type: 'StackingCardItem[]',
			required: true,
			description: 'Array of card entries. Each entry carries `children` (JSX), optional `index`, `topPosition`, and `class`.',
		},
		{
			name: 'scaleMultiplier',
			type: 'number',
			default: '0.03',
			description: 'How much each card shrinks per card index. Higher = more pronounced stacking.',
		},
		{
			name: 'scrollable',
			type: 'boolean',
			default: 'false',
			description: 'When true the component becomes its own scroll container (useful inside fixed-height boxes). When false, window scroll drives the animation.',
		},
	],
};
