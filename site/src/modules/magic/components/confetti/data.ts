import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './confetti.tsrx?raw';

export const data: ComponentEntry = {
	id: 'confetti',
	title: 'Confetti',
	description: 'A confetti burst on demand — as a wrapper component or a self-contained button.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'confetti.tsrx', code: source, lang: 'tsx' }],
	packages: ['canvas-confetti'],
	props: [
		{
			name: 'active',
			type: 'boolean',
			default: 'false',
			description: '(Confetti) When true, fires a burst from the centre-top of the wrapper.',
		},
		{
			name: 'options',
			type: 'object',
			default: '{}',
			description: 'canvas-confetti options passed through (particleCount, spread, colors, origin, …).',
		},
		{
			name: 'class',
			type: 'string',
			default: '""',
			description: 'Extra classes on the outer wrapper (Confetti) or button (ConfettiButton).',
		},
	],
};
