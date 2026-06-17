import { Tree, Folder, File, CollapseButton } from './file-tree.tsrx';
import type { TreeViewElement, TreeCtx } from './file-tree.tsrx';

// Pre-expand src and components so the tree looks populated on load.
const elements: TreeViewElement[] = [
	{
		id: '1',
		name: 'src',
		nodes: [
			{
				id: '2',
				name: 'components',
				nodes: [
					{ id: '3', name: 'button.tsx' },
					{ id: '4', name: 'card.tsx' },
				],
			},
			{
				id: '5',
				name: 'lib',
				nodes: [
					{ id: '6', name: 'utils.ts' },
					{ id: '7', name: 'cn.ts' },
				],
			},
			{ id: '8', name: 'main.tsx' },
		],
	},
	{
		id: '10',
		name: 'public',
		nodes: [{ id: '11', name: 'favicon.ico' }],
	},
	{ id: '12', name: 'package.json' },
];

function renderLib(ctx: TreeCtx) @{
	<>
	<File ctx={ctx} value="6"><span>{'utils.ts'}</span></File>
	<File ctx={ctx} value="7"><span>{'cn.ts'}</span></File>
	</>
}

function renderComponents(ctx: TreeCtx) @{
	<>
	<File ctx={ctx} value="3"><span>{'button.tsx'}</span></File>
	<File ctx={ctx} value="4"><span>{'card.tsx'}</span></File>
	</>
}

function renderSrc(ctx: TreeCtx) @{
	<>
	<Folder ctx={ctx} value="2" element="components">{renderComponents(ctx)}</Folder>
	<Folder ctx={ctx} value="5" element="lib">{renderLib(ctx)}</Folder>
	<File ctx={ctx} value="8"><span>{'main.tsx'}</span></File>
	</>
}

function renderPublic(ctx: TreeCtx) @{
	<>
	<File ctx={ctx} value="11"><span>{'favicon.ico'}</span></File>
	</>
}

function renderRoot(ctx: TreeCtx) @{
	<>
	<Folder ctx={ctx} value="1" element="src">{renderSrc(ctx)}</Folder>
	<Folder ctx={ctx} value="10" element="public">{renderPublic(ctx)}</Folder>
	<File ctx={ctx} value="12"><span>{'package.json'}</span></File>
	<CollapseButton ctx={ctx} elements={elements} />
	</>
}

export function Preview() @{
	<>
	<div class="relative h-72 w-72 overflow-hidden rounded-xl border border-border bg-card p-2 text-sm text-foreground">
		<Tree
			initialSelectedId="3"
			initialExpandedItems={['1', '2']}
			elements={elements}
			renderChildren={renderRoot}
		/>
	</div>
	</>
}
