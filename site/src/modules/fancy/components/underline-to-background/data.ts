import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './underline-to-background.tsrx?raw';

export const data: ComponentEntry = {
	id: 'underline-to-background',
	title: 'Underline To Background',
	description:
		'On hover, a coloured underline bar expands to fill the element background while the text colour transitions to a target value.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'underline-to-background.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'targetTextColor',
			type: 'string',
			default: '"#fef"',
			description: 'Text colour applied when the background is fully expanded.',
		},
		{
			name: 'underlineHeightRatio',
			type: 'number',
			default: '0.1',
			description: 'Underline height as a fraction of the computed font-size.',
		},
		{
			name: 'underlinePaddingRatio',
			type: 'number',
			default: '0.01',
			description: 'Downward offset of the bar as a fraction of the computed font-size.',
		},
		{
			name: 'duration',
			type: 'number',
			default: '0.25',
			description: 'Animation duration in seconds for enter and exit transitions.',
		},
		{
			name: 'ease',
			type: 'string',
			default: '"easeOut"',
			description: 'Easing function passed to the motion engine.',
		},
	],
};
