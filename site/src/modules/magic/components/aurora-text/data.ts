import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './aurora-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'aurora-text',
	title: 'Aurora Text',
	description: 'Animated gradient text that cycles through colours with a flowing aurora effect.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'aurora-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'ReactNode', required: true, description: 'Text content to display.' },
		{
			name: 'colors',
			type: 'string[]',
			default: "['#FF0080','#7928CA','#0070F3','#38bdf8']",
			description: 'Gradient colour stops; first colour is appended to close the loop.',
		},
		{
			name: 'speed',
			type: 'number',
			default: '1',
			description: 'Playback multiplier — higher is faster (duration = 10 / speed seconds).',
		},
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the outer <span>.' },
	],
};
