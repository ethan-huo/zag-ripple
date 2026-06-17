import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './rainbow-button.tsrx?raw';

export const data: ComponentEntry = {
	id: 'rainbow-button',
	title: 'Rainbow Button',
	description: 'A button with an animated rainbow gradient border and glow, driven entirely by CSS.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'rainbow-button.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'variant',
			type: '"default" | "outline"',
			default: '"default"',
			description: 'Visual style: filled dark background or transparent with rainbow border.',
		},
		{
			name: 'size',
			type: '"default" | "sm" | "lg" | "icon"',
			default: '"default"',
			description: 'Button size preset.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra CSS classes to merge onto the button element.',
		},
	],
};
