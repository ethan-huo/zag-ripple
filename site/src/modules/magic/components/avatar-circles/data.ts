import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './avatar-circles.tsrx?raw';

export const data: ComponentEntry = {
	id: 'avatar-circles',
	title: 'Avatar Circles',
	description: 'Stacked row of avatar images with an optional overflow count badge.',
	group: 'Media',
	preview: Preview,
	previewCode,
	source: [{ filename: 'avatar-circles.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'avatarUrls',
			type: 'AvatarItem[]',
			required: true,
			description: 'Array of { imageUrl, profileUrl } entries.',
		},
		{
			name: 'numPeople',
			type: 'number',
			description: 'Count shown in the overflow badge. Hidden when 0 or undefined.',
		},
		{ name: 'class', type: 'string' },
	],
};
