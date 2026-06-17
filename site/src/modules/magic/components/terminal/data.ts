import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './terminal.tsrx?raw';

export const data: ComponentEntry = {
	id: 'terminal',
	title: 'Terminal',
	description:
		'A macOS-style terminal window with sequenced typing and fade-in animations for child lines.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'terminal.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{
			name: 'sequence',
			type: 'TerminalSequence',
			description:
				'Shared sequence object from createTerminalSequence(). When provided, children animate one after another.',
		},
		{
			name: 'startOnView',
			type: 'boolean',
			default: 'true',
			description: 'Delay the sequence until the terminal scrolls into view.',
		},
		{
			name: 'class',
			type: 'string',
		},
		{
			name: 'children',
			type: 'ReactNode',
			description: 'AnimatedSpan and TypingAnimation elements.',
		},
	],
};
