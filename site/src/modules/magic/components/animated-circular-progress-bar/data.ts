import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './animated-circular-progress-bar.tsrx?raw';

export const data: ComponentEntry = {
	id: 'animated-circular-progress-bar',
	title: 'Animated Circular Progress Bar',
	description: 'A circular SVG progress bar that animates smoothly via CSS stroke-dasharray transitions.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'animated-circular-progress-bar.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'value', type: 'number', required: true, description: 'Current progress value.' },
		{ name: 'min', type: 'number', default: '0', description: 'Minimum value.' },
		{ name: 'max', type: 'number', default: '100', description: 'Maximum value.' },
		{ name: 'gaugePrimaryColor', type: 'string', required: true, description: 'Color of the primary progress arc.' },
		{ name: 'gaugeSecondaryColor', type: 'string', required: true, description: 'Color of the secondary (remaining) arc.' },
		{ name: 'class', type: 'string', description: 'Extra classes for the root element.' },
	],
};
