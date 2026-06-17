import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './arc-timeline.tsrx?raw';

export const data: ComponentEntry = {
	id: 'arc-timeline',
	title: 'Arc Timeline',
	description:
		'An interactive timeline arranged on a large arc circle. Click any step to rotate the arc and reveal its label and description.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'arc-timeline.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'data',
			type: 'ArcTimelineItem[]',
			required: true,
			description: 'Array of timeline items, each with a time label and steps.',
		},
		{
			name: 'arcConfig',
			type: 'ArcTimelineArcConfig',
			description: 'Optional tuning for circle size and angles.',
		},
		{
			name: 'defaultActiveStep',
			type: 'ArcTimelineDefaultActiveStep',
			description: 'Initial active time and step index to center on mount.',
		},
		{ name: 'class', type: 'string' },
	],
};
