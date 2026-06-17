import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './color-selector.tsrx?raw';

export const data: ComponentEntry = {
	id: 'color-selector',
	title: 'Color Selector',
	description: 'A radiogroup of color swatches with selected-ring feedback and controlled/uncontrolled modes.',
	group: 'Inputs',
	preview: Preview,
	previewCode,
	source: [{ filename: 'color-selector.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'colors', type: 'ColorSelectorColor[]', default: '[]', description: 'Ordered list of color values to display.' },
		{ name: 'size', type: '"sm" | "default" | "lg"', default: '"default"', description: 'Dot size.' },
		{ name: 'value', type: 'ColorSelectorColor', description: 'Controlled selected color.' },
		{ name: 'defaultValue', type: 'ColorSelectorColor', description: 'Initial selected color for uncontrolled mode.' },
		{ name: 'name', type: 'string', description: 'Populates a hidden <input> for form submission.' },
		{ name: 'onColorSelect', type: '(color: ColorSelectorColor) => void', description: 'Fired whenever a dot is clicked.' },
	],
};
