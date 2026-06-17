import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './dia-text-reveal.tsrx?raw';

export const data: ComponentEntry = {
	id: 'dia-text-reveal',
	title: 'Dia Text Reveal',
	description:
		'A diagonal gradient band sweeps across text on mount or scroll, with optional multi-text cycling.',
	group: 'Text',
	preview: Preview,
	previewCode,
	source: [{ filename: 'dia-text-reveal.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{ name: 'text', type: 'string | string[]', required: true, description: 'Text to reveal. Pass an array to cycle through multiple strings.' },
		{ name: 'colors', type: 'string[]', default: "['#c679c4','#fa3d1d','#ffb005','#e1e1fe','#0358f7']", description: 'Gradient band colors.' },
		{ name: 'textColor', type: 'string', default: "'var(--foreground)'", description: 'Revealed text color.' },
		{ name: 'duration', type: 'number', default: '1.5', description: 'Sweep animation duration in seconds.' },
		{ name: 'delay', type: 'number', default: '0', description: 'Delay before sweep starts.' },
		{ name: 'repeat', type: 'boolean', default: 'false', description: 'Whether to cycle through text array repeatedly.' },
		{ name: 'repeatDelay', type: 'number', default: '0.5', description: 'Pause between cycles in seconds.' },
		{ name: 'triggerOnView', type: 'boolean', default: 'true', description: 'Start animation when the element scrolls into view.' },
		{ name: 'once', type: 'boolean', default: 'true', description: 'Only animate once (on first in-view event).' },
		{ name: 'fixedWidth', type: 'boolean', default: 'false', description: 'When cycling, fix the span width to the widest text variant.' },
		{ name: 'class', type: 'string', description: 'Extra CSS classes.' },
	],
};
