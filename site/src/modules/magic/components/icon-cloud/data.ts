import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './icon-cloud.tsrx?raw';

export const data: ComponentEntry = {
	id: 'icon-cloud',
	title: 'Icon Cloud',
	description: 'An interactive 3D sphere of icons that rotates with the mouse and snaps to any clicked icon.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'icon-cloud.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'images',
			type: 'string[]',
			description: 'Array of image URLs to display on the sphere. Falls back to numbered circles when omitted.',
		},
		{
			name: 'class',
			type: 'string',
			description: 'Extra CSS classes forwarded to the <canvas> element.',
		},
	],
};
