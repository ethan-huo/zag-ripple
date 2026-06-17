import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './file-tree.tsrx?raw';

export const data: ComponentEntry = {
	id: 'file-tree',
	title: 'File Tree',
	description: 'An interactive file-tree with animated folder expand/collapse and selection state.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'file-tree.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'initialSelectedId',
			type: 'string',
			description: 'ID of the initially selected item.',
		},
		{
			name: 'initialExpandedItems',
			type: 'string[]',
			default: '[]',
			description: 'IDs of folders that start expanded.',
		},
		{
			name: 'indicator',
			type: 'boolean',
			default: 'true',
			description: 'Show vertical indicator line inside expanded folders.',
		},
		{
			name: 'dir',
			type: '"ltr" | "rtl"',
			default: '"ltr"',
			description: 'Text direction.',
		},
		{
			name: 'children',
			type: '(ctx: TreeCtx) => JSX.Element',
			required: true,
			description: 'Render-prop that receives the tree context; compose Folder/File/CollapseButton inside.',
		},
	],
};
