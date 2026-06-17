import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './qrcode.tsrx?raw';

export const data: ComponentEntry = {
	id: 'qrcode',
	title: 'QR Code',
	description: 'Renders a styled SVG QR code with circular data dots and rounded finder patterns.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'qrcode.tsrx', code: source, lang: 'tsx' }],
	packages: ['qrcode'],
	props: [
		{ name: 'value', type: 'string', required: true, description: 'The text or URL to encode.' },
		{ name: 'size', type: 'number', default: '268', description: 'Width and height of the SVG in pixels.' },
		{ name: 'fgColor', type: 'string', default: '"var(--foreground)"', description: 'Color of the QR modules and finder patterns.' },
		{ name: 'bgColor', type: 'string', default: '"var(--background)"', description: 'Background fill color.' },
		{ name: 'errorCorrectionLevel', type: '"L" | "M" | "Q" | "H"', default: '"M"', description: 'QR error correction level.' },
	],
};
