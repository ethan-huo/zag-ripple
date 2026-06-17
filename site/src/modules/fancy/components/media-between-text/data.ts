import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './media-between-text.tsrx?raw';

export const data: ComponentEntry = {
	id: 'media-between-text',
	title: 'Media Between Text',
	description: 'Reveals an image or video between two text segments on hover, scroll, or external trigger.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'media-between-text.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'firstText', type: 'string', required: true, description: 'Text displayed before the media.' },
		{ name: 'secondText', type: 'string', required: true, description: 'Text displayed after the media.' },
		{ name: 'mediaUrl', type: 'string', required: true, description: 'URL of the image or video.' },
		{ name: 'mediaType', type: '"image" | "video"', required: true, description: 'Whether the media is an image or video.' },
		{ name: 'triggerType', type: '"hover" | "inView" | "ref"', default: '"hover"', description: 'What triggers the reveal animation.' },
		{ name: 'mediaContainerClass', type: 'string', description: 'Extra classes for the media wrapper (use to set height/shape).' },
		{ name: 'fallbackUrl', type: 'string', description: 'Poster image for videos.' },
		{ name: 'alt', type: 'string', description: 'Alt text for images.' },
		{ name: 'autoPlay', type: 'boolean', default: 'true' },
		{ name: 'loop', type: 'boolean', default: 'true' },
		{ name: 'muted', type: 'boolean', default: 'true' },
		{ name: 'playsInline', type: 'boolean', default: 'true' },
		{ name: 'useInViewOptions', type: '{ once?: boolean; amount?: number | string; margin?: string }', default: '{ once: true, amount: 0.5 }' },
		{ name: 'isAnimating', type: 'boolean', default: 'false', description: 'External control when triggerType is "ref".' },
		{ name: 'leftTextClass', type: 'string', description: 'Extra classes for the left text span.' },
		{ name: 'rightTextClass', type: 'string', description: 'Extra classes for the right text span.' },
	],
};
