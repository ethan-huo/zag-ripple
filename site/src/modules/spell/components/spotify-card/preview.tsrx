import { SpotifyCard } from './spotify-card.tsrx';

// Static mock bypasses the /api/spotify route so the demo renders without a
// real Spotify proxy. The component itself still supports live `url` fetching.
const mockTrack = {
	title: 'Blinding Lights',
	artist: 'The Weeknd',
	image: 'https://i.scdn.co/image/ab67616d0000b273a048415db06a5b6fa7ec4e1a',
	link: 'https://open.spotify.com/track/0VjIjW4GlUZAMYd2vXMi3b',
	audio: '',
};

export function Preview() @{
	<>
	<div class="flex w-full max-w-sm flex-col gap-4 p-4">
		<SpotifyCard initialData={mockTrack} class="w-full" />
	</div>
	</>
}
