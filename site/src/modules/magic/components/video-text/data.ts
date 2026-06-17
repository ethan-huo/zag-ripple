import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './video-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'video-text',
	title: 'Video Text',
	description: 'Plays a video clipped to the shape of text using a CSS SVG mask.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'video-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'src', type: 'string', required: true, description: 'URL of the video source.' },
		{ name: 'content', type: 'string', required: true, description: 'Text displayed as the video mask.' },
		{ name: 'autoPlay', type: 'boolean', default: 'true' },
		{ name: 'muted', type: 'boolean', default: 'true' },
		{ name: 'loop', type: 'boolean', default: 'true' },
		{ name: 'preload', type: '"auto" | "metadata" | "none"', default: '"auto"' },
		{ name: 'fontSize', type: 'string | number', default: '20', description: 'Font size in vw (number) or any CSS length.' },
		{ name: 'fontWeight', type: 'string | number', default: '"bold"' },
		{ name: 'textAnchor', type: 'string', default: '"middle"', description: 'SVG text-anchor attribute.' },
		{ name: 'dominantBaseline', type: 'string', default: '"middle"', description: 'SVG dominant-baseline attribute.' },
		{ name: 'fontFamily', type: 'string', default: '"sans-serif"' },
		{ name: 'class', type: 'string' },
	],
};
