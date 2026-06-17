import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './pulsating-button.tsrx?raw';

export const data: ComponentEntry = {
	id: 'pulsating-button',
	title: 'Pulsating Button',
	description: 'A button with a box-shadow pulse ring in three variants: slow fade, ping-pong ring, and ripple.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'pulsating-button.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'ReactNode', required: true, description: 'Button label content.' },
		{ name: 'class', type: 'string', description: 'Extra classes forwarded to the <button> element.' },
		{ name: 'pulseColor', type: 'string', default: '"#808080"', description: 'CSS color used for the pulse ring.' },
		{ name: 'duration', type: 'string', default: '"1.5s"', description: 'CSS duration string for the pulse animation.' },
		{ name: 'distance', type: 'string', default: '"8px"', description: 'Maximum spread radius of the pulse ring.' },
		{ name: 'variant', type: '"slow" | "ring" | "ripple"', default: '"slow"', description: 'Pulse style: slow fade-out, ping-pong ring, or ripple burst.' },
	],
};
