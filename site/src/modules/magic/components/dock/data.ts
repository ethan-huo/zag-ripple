import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './dock.tsrx?raw';

export const data: ComponentEntry = {
	id: 'dock',
	title: 'Dock',
	description: 'A macOS-style icon dock with pointer-proximity magnification and spring physics.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'dock.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'items',
			type: 'DockItemDef[]',
			required: true,
			description: 'Array of { icon, label?, href?, class? } entries.',
		},
		{
			name: 'iconSize',
			type: 'number',
			default: '40',
			description: 'Base icon size in pixels when not magnified.',
		},
		{
			name: 'iconMagnification',
			type: 'number',
			default: '60',
			description: 'Peak icon size in pixels when the pointer is directly over an icon.',
		},
		{
			name: 'disableMagnification',
			type: 'boolean',
			default: 'false',
			description: 'Disables the magnification effect entirely.',
		},
		{
			name: 'iconDistance',
			type: 'number',
			default: '140',
			description: 'Pointer distance in pixels at which magnification begins.',
		},
		{
			name: 'direction',
			type: '"top" | "middle" | "bottom"',
			default: '"middle"',
			description: 'Vertical alignment of icons within the dock bar.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra class names for the dock container.',
		},
	],
};
