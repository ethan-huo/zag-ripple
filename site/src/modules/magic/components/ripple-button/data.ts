import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './ripple-button.tsrx?raw';

export const data: ComponentEntry = {
	id: 'ripple-button',
	title: 'Ripple Button',
	description: 'A button that emits a ripple animation from the click position.',
	group: 'Buttons',
	preview: Preview,
	previewCode,
	source: [{ filename: 'ripple-button.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'children', type: 'ReactNode', required: true },
		{ name: 'rippleColor', type: 'string', default: '"#ffffff"', description: 'Color of the ripple circle.' },
		{ name: 'duration', type: 'string', default: '"600ms"', description: 'CSS duration string for the ripple animation.' },
		{ name: 'onClick', type: '(e: MouseEvent) => void', description: 'Click handler forwarded after the ripple is created.' },
		{ name: 'class', type: 'string' },
	],
};
