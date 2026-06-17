import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-checkbox.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-checkbox',
	title: 'Animated Checkbox',
	description: 'A checkbox that animates the checkmark path and a strikethrough on the label when toggled.',
	group: 'Inputs',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-checkbox.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'title', type: 'string', default: '"Implement Checkbox"', description: 'Label text shown beside the checkbox.' },
		{ name: 'checked', type: 'boolean', description: 'Controlled checked state.' },
		{ name: 'defaultChecked', type: 'boolean', default: 'false', description: 'Initial checked state when uncontrolled.' },
		{ name: 'onCheckedChange', type: '(checked: boolean) => void', description: 'Fires with the new checked value on toggle.' },
	],
};
