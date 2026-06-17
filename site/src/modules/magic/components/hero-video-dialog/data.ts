import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './hero-video-dialog.tsrx?raw';

export const data: ComponentEntry = {
	id: 'hero-video-dialog',
	title: 'Hero Video Dialog',
	description: 'A thumbnail button that opens a full-screen video overlay with animated enter/exit transitions.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'hero-video-dialog.tsrx', code: source, lang: 'tsx' }],
	packages: ['motion'],
	props: [
		{
			name: 'videoSrc',
			type: 'string',
			required: true,
			description: 'URL to embed in the iframe (YouTube embed URL recommended).',
		},
		{
			name: 'thumbnailSrc',
			type: 'string',
			required: true,
			description: 'Image URL shown as the video thumbnail.',
		},
		{
			name: 'thumbnailAlt',
			type: 'string',
			default: '"Video thumbnail"',
			description: 'Alt text for the thumbnail image.',
		},
		{
			name: 'animationStyle',
			type: '"from-bottom" | "from-center" | "from-top" | "from-left" | "from-right" | "fade" | "top-in-bottom-out" | "left-in-right-out"',
			default: '"from-center"',
			description: 'Enter/exit animation direction for the video dialog panel.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Additional classes applied to the root wrapper.',
		},
	],
};
