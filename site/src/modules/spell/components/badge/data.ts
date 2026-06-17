import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './badge.tsrx?raw';

export const data: ComponentEntry = {
	id: 'badge',
	title: 'Badge',
	description: 'A compact status tag with 20+ color variants and two sizes, powered by tailwind-variants.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'badge.tsrx', code: source, lang: 'tsx' }],
	packages: ['tailwind-variants'],
	props: [
		{ name: 'children', type: 'Children', required: true },
		{ name: 'href', type: 'string', description: 'Renders an <a> instead of a <span>.' },
		{ name: 'variant', type: '"default" | "secondary" | "outline" | "destructive" | color', default: '"default"' },
		{ name: 'size', type: '"default" | "sm"', default: '"default"' },
	],
};
