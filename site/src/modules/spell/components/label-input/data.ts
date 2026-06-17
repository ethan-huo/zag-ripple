import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './label-input.tsrx?raw';

export const data: ComponentEntry = {
	id: 'label-input',
	title: 'Label Input',
	description: 'An input with a floating label that animates up on focus or when a value is present.',
	group: 'Inputs',
	preview: Preview,
	previewCode,
	source: [{ filename: 'label-input.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'label', type: 'string', default: '""', description: 'Floating label text.' },
		{
			name: 'ringColor',
			type: '"muted" | "primary" | "secondary" | "destructive" | "red" | "blue" | "green" | "yellow" | "purple" | "pink" | "orange" | "cyan" | "indigo" | "violet" | "rose" | "amber" | "lime" | "emerald" | "sky" | "slate" | "fuchsia"',
			default: '"muted"',
			description: 'Focus ring color.',
		},
		{ name: 'type', type: '"text" | "email" | "password" | "search" | "tel" | "url" | "number" | "hidden"', default: '"text"' },
		{ name: 'placeholder', type: 'string', default: '""' },
		{ name: 'disabled', type: 'boolean', default: 'false' },
		{ name: 'containerClass', type: 'string', description: 'Extra classes on the wrapper div.' },
		{ name: 'inputClass', type: 'string', description: 'Extra classes on the input element.' },
	],
};
