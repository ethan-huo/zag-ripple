import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './text-highlighter.tsrx?raw';

export const data: ComponentEntry = {
	id: 'text-highlighter',
	title: 'Text Highlighter',
	description: 'Animates a gradient highlight fill behind text, with configurable direction and trigger.',
	group: 'Text Animations',
	preview: Preview,
	previewCode,
	source: [{ filename: 'text-highlighter.tsrx', code: source, lang: 'tsx' }],
	props: [
		{
			name: 'triggerType',
			type: '"hover" | "ref" | "inView" | "auto"',
			default: '"inView"',
			description: 'What triggers the highlight animation.',
		},
		{
			name: 'direction',
			type: '"ltr" | "rtl" | "ttb" | "btt"',
			default: '"ltr"',
			description: 'Direction the highlight sweeps across the text.',
		},
		{
			name: 'highlightColor',
			type: 'string',
			default: '"hsl(25, 90%, 80%)"',
			description: 'CSS color value for the highlight fill.',
		},
		{
			name: 'transition',
			type: '{ duration?: number; bounce?: number }',
			default: '{ type: "spring", duration: 1, bounce: 0 }',
			description: 'Animation timing options.',
		},
		{
			name: 'inViewOptions',
			type: '{ once?: boolean; amount?: number | "some" | "all"; margin?: string }',
			default: '{ once: true, amount: 0.1 }',
			description: 'IntersectionObserver options when triggerType is "inView".',
		},
		{
			name: 'animated',
			type: 'boolean',
			default: 'false',
			description: 'When triggerType is "ref", set true to trigger the animation.',
		},
	],
};
