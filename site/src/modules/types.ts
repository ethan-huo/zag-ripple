import type { Component } from 'ripple';

export type PropRow = {
	name: string;
	type: string;
	default?: string;
	required?: boolean;
	description?: string;
};

export type SourceFile = {
	filename: string;
	code: string;
	lang?: string;
};

export type Example = {
	name: string;
	preview: Component;
	code: string;
	lang?: string;
};

export type ComponentEntry = {
	id: string;
	title: string;
	description: string;
	/** Sidebar grouping label, e.g. "Text Animations". */
	group?: string;
	beta?: boolean;
	/** Main demo rendered in the preview box. */
	preview: Component;
	/** Raw source of the demo, shown in the "Preview" code tab. */
	previewCode: string;
	/** Component source file(s), shown in the "Code" tab for copy-paste install. */
	source?: SourceFile[];
	examples?: Example[];
	props?: PropRow[];
	/** Extra npm packages this component needs. */
	packages?: string[];
};

export type ModuleId = 'magic' | 'spell' | 'fancy';

export type ModuleDef = {
	id: ModuleId;
	label: string;
	tagline: string;
	description: string;
	/** Upstream attribution. */
	credit?: { label: string; href: string };
	components: ComponentEntry[];
};
