import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './spotify-card.tsrx?raw';

export const data: ComponentEntry = {
	id: 'spotify-card',
	title: 'Spotify Card',
	description: 'Compact now-playing card with album art, a spinning vinyl disk, and optional audio preview.',
	group: 'Cards',
	preview: Preview,
	previewCode,
	source: [{ filename: 'spotify-card.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'url', type: 'string', required: false, description: 'Spotify track/album URL. Fetched via /api/spotify proxy.' },
		{ name: 'initialData', type: '{ title; artist; image; link; audio? }', required: false, description: 'Skip the fetch and render with pre-supplied track data (useful for SSR demos).' },
		{ name: 'class', type: 'string', required: false },
	],
};
