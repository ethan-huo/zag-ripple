import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Svelte's setContext/getContext is used in the source to share selectedId,
// expandedItems, and callbacks with Folder/File/CollapseButton descendants.
// TSRX has no context API, so the design follows the Dock precedent: Tree
// creates track objects and a callbacks bag, then passes a single `ctx` prop
// to every child via a `renderChildren` render-prop (a plain function prop,
// not `children`, because JSX children aren't callable in TSRX).

export type TreeViewElement = {
	id: string;
	name: string;
	isSelectable?: boolean;
	children?: TreeViewElement[];
};

export type TreeCtx = {
	selectedId: ReturnType<typeof track<string | undefined>>;
	expandedItems: ReturnType<typeof track<string[]>>;
	handleExpand: (id: string) => void;
	selectItem: (id: string) => void;
	setExpandedItems: (items: string[]) => void;
	indicator: boolean;
	direction: 'ltr' | 'rtl';
};

export function Tree({
	initialSelectedId,
	initialExpandedItems = [],
	indicator = true,
	dir = 'ltr',
	// `renderChildren` is a function prop that receives the ctx bag.
	// It replaces Svelte's slot + context pattern.
	renderChildren,
	class: className,
	...rest
}: any) @{
	const selectedId = track<string | undefined>(initialSelectedId);
	const expandedItems = track<string[]>(initialExpandedItems);
	const direction: 'ltr' | 'rtl' = dir === 'rtl' ? 'rtl' : 'ltr';

	const handleExpand = (id: string) => {
		const current = expandedItems.value;
		if (current.includes(id)) {
			expandedItems.value = current.filter((item) => item !== id);
		} else {
			expandedItems.value = [...current, id];
		}
	};

	const selectItem = (id: string) => {
		selectedId.value = id;
	};

	const setExpandedItems = (items: string[]) => {
		expandedItems.value = items;
	};

	const ctx: TreeCtx = {
		selectedId,
		expandedItems,
		handleExpand,
		selectItem,
		setExpandedItems,
		indicator,
		direction,
	};

	<>
	<div class={cn('size-full', className)} {...rest}>
		<div class="relative h-full overflow-auto px-2" dir={direction}>
			<div class="flex flex-col gap-1">
				{renderChildren ? renderChildren(ctx) : null}
			</div>
		</div>
	</div>
	</>
}

// Default folder icon: open or closed state passed as a prop.
// Using a single component with conditional path is SSR-safe.
function DefaultFolderIcon({ isOpen }: { isOpen: boolean }) @{
	<>
	@if (isOpen) {
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
			<path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z" />
			<path d="M2 10h20" />
		</svg>
	} @else {
		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
			<path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z" />
		</svg>
	}
	</>
}

export function Folder({
	ctx,
	element,
	value,
	isSelectable = true,
	isSelect,
	openIcon,
	closeIcon,
	children,
	class: className,
	...rest
}: any) @{
	const treeCtx: TreeCtx = ctx;
	// `visible` controls DOM presence of the content wrapper; starts at the
	// initial expanded state so SSR renders open folders with content.
	const visible = track(treeCtx.expandedItems.value.includes(value));
	const isExpanded = track(() => treeCtx.expandedItems.value.includes(value));
	const isSelected = track(() => isSelect ?? treeCtx.selectedId.value === value);

	// Resolve which icon to show: prefer custom slot, fall back to defaults.
	// Stored as track so the icon updates reactively when isExpanded changes.
	const folderIcon = track(() => {
		if (isExpanded.value && openIcon) return openIcon;
		if (!isExpanded.value && closeIcon) return closeIcon;
		return null; // null => render <DefaultFolderIcon>
	});

	// Stable ref to the content node for the exit animation.
	let contentEl: HTMLElement | null = null;
	// Skip the entrance animation for folders that were open on the initial
	// render -- avoids flashing hidden on hydration.
	let isInitiallyOpen = treeCtx.expandedItems.value.includes(value);

	function handleToggle() {
		if (isExpanded.value) {
			// Exit: animate out then unmount.
			if (contentEl) {
				const h = contentEl.getBoundingClientRect().height;
				animate(
					contentEl,
					{ height: [h, 0], opacity: [1, 0] },
					{ duration: 0.2, ease: 'easeInOut' },
				).then(() => {
					visible.value = false;
					treeCtx.handleExpand(value);
				});
			} else {
				visible.value = false;
				treeCtx.handleExpand(value);
			}
		} else {
			// Entrance: update model state first, then mount the content div.
			// The ref callback fires once mounted and drives the open animation.
			treeCtx.handleExpand(value);
			visible.value = true;
		}
	}

	function onContentMount(el: HTMLElement | null) {
		contentEl = el;
		if (!el) return;
		if (isInitiallyOpen) {
			// Already open at initial render -- reveal immediately, no animation.
			el.style.height = 'auto';
			el.style.opacity = '1';
			isInitiallyOpen = false;
			return;
		}
		// Animate open: height 0 -> natural scrollHeight, then release to 'auto'
		// so the container can grow with dynamic children.
		const targetH = el.scrollHeight;
		animate(
			el,
			{ height: [0, targetH], opacity: [0, 1] },
			{ duration: 0.2, ease: 'easeInOut' },
		).then(() => {
			if (el) el.style.height = 'auto';
		});
	}

	<>
	<div class="relative h-full overflow-hidden" {...rest}>
		<button
			type="button"
			class={cn('flex w-full items-center gap-1 rounded-md text-left text-sm', className, {
				'bg-muted rounded-md': isSelected.value && isSelectable,
				'cursor-pointer': isSelectable,
				'cursor-not-allowed opacity-50': !isSelectable,
			})}
			disabled={!isSelectable}
			onClick={handleToggle}
		>
			<span class="size-4">
				@if (folderIcon.value) {
					{folderIcon.value}
				} @else {
					<DefaultFolderIcon isOpen={isExpanded.value} />
				}
			</span>
			<span>{element}</span>
		</button>

		@if (visible.value) {
			<div
				ref={onContentMount}
				class="relative overflow-hidden text-sm"
				style="height: 0; opacity: 0;"
			>
				@if (element && treeCtx.indicator) {
					<div
						dir={treeCtx.direction}
						class="bg-muted absolute left-1.5 h-full w-px rounded-md py-3 duration-300 ease-in-out hover:bg-slate-300 rtl:right-1.5"
						aria-hidden="true"
					/>
				}
				<div class="ml-5 flex flex-col gap-1 py-1 rtl:mr-5" dir={treeCtx.direction}>
					{children}
				</div>
			</div>
		}
	</div>
	</>
}

// File: a leaf node that selects itself on click.
function DefaultFileIcon() @{
	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
		<path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z" />
		<path d="M14 2v4a2 2 0 0 0 2 2h4" />
	</svg>
}

export function File({
	ctx,
	value,
	isSelectable = true,
	isSelect,
	fileIcon,
	children,
	class: className,
	...rest
}: any) @{
	const treeCtx: TreeCtx = ctx;
	const isSelected = track(() => isSelect ?? treeCtx.selectedId.value === value);

	<>
	<button
		type="button"
		disabled={!isSelectable}
		class={cn(
			'flex w-fit items-center gap-1 rounded-md pr-1 text-sm duration-200 ease-in-out rtl:pr-0 rtl:pl-1',
			{ 'bg-muted': isSelected.value && isSelectable },
			isSelectable ? 'cursor-pointer' : 'cursor-not-allowed opacity-50',
			treeCtx.direction === 'rtl' ? 'rtl' : 'ltr',
			className,
		)}
		onClick={() => treeCtx.selectItem(value)}
		{...rest}
	>
		<span class="size-4">
			@if (fileIcon) {
				{fileIcon}
			} @else {
				<DefaultFileIcon />
			}
		</span>
		{children}
	</button>
	</>
}

// CollapseButton: toggles all-expanded / all-collapsed.
// Uses effect (not onMount) to handle expandAll on client mount only.
export function CollapseButton({
	ctx,
	elements = [],
	expandAll = false,
	children,
	class: className,
	...rest
}: any) @{
	const treeCtx: TreeCtx = ctx;

	function expandAllTree(elems: TreeViewElement[]) {
		function expandTree(el: TreeViewElement) {
			const selectable = el.isSelectable ?? true;
			if (selectable && el.children && el.children.length > 0) {
				const current = treeCtx.expandedItems.value;
				if (!current.includes(el.id)) {
					treeCtx.setExpandedItems([...current, el.id]);
				}
				el.children.forEach(expandTree);
			}
		}
		elems.forEach(expandTree);
	}

	function closeAll() {
		treeCtx.setExpandedItems([]);
	}

	// Expand all on client mount if requested (effect is client-only).
	effect(() => {
		if (expandAll) expandAllTree(elements);
	});

	function handleClick() {
		const current = treeCtx.expandedItems.value;
		if (current && current.length > 0) {
			closeAll();
		} else {
			expandAllTree(elements);
		}
	}

	<>
	<button
		type="button"
		class={cn('hover:bg-muted absolute right-2 bottom-1 h-8 w-fit rounded-md p-1', className)}
		onClick={handleClick}
		{...rest}
	>
		{children}
		<span class="sr-only">{'Toggle'}</span>
	</button>
	</>
}
