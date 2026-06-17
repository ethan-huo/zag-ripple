import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './bento-grid.tsrx?raw';

export const data: ComponentEntry = {
	id: 'bento-grid',
	title: 'Bento Grid',
	description:
		'A responsive bento-style grid with hover-animated cards that reveal a CTA link.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'bento-grid.tsrx', code: source, lang: 'tsx' }],
	props: [
		// BentoGrid props
		{ name: 'class', type: 'string', description: 'Extra classes on the grid wrapper.' },
		// BentoCard props
		{ name: 'name', type: 'string', required: true, description: 'Card heading.' },
		{
			name: 'background',
			type: '() => JSX',
			required: true,
			description: 'Zero-arg render function for the card background area.',
		},
		{ name: 'Icon', type: 'Component', required: true, description: 'Icon component rendered in the card body.' },
		{ name: 'iconClass', type: 'string', default: '""', description: 'Extra classes on the icon.' },
		{ name: 'description', type: 'string', required: true, description: 'Card body text.' },
		{ name: 'href', type: 'string', required: true, description: 'CTA link destination.' },
		{ name: 'cta', type: 'string', required: true, description: 'CTA button label.' },
	],
};
