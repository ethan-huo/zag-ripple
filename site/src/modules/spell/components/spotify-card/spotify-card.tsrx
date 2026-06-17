import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// The Spotify API proxy lives at /api/spotify on the original SvelteKit host.
// The component still wires up the fetch so real deployments can add that
// route; the demo preview bypasses it with static `initialData`.
export function SpotifyCard({
	url,
	initialData,
	class: className,
	...restProps
}: any) @{
	// Stable per-instance SVG filter/mask IDs — safe to derive at render time
	// because Math.random() runs once per component instantiation on client AND
	// server, but SVG IDs only need to be unique within the page, not globally
	// stable across SSR/hydration. The `uid` string is pure, so no DOM access.
	const uid = 'sc-' + Math.random().toString(36).slice(2, 9);
	const maskId    = uid + '-mask';
	const filterId0 = uid + '-f0';
	const filterId1 = uid + '-f1';
	const filterId2 = uid + '-f2';
	const filterId3 = uid + '-f3';
	const filterId4 = uid + '-f4';
	const filterId5 = uid + '-f5';
	const filterId6 = uid + '-f6';
	const filterId7 = uid + '-f7';
	const filterId8 = uid + '-f8';
	const filterId9 = uid + '-f9';

	let data      = track<{ title: string; artist: string; image: string; link: string; audio?: string } | null>(initialData ?? null);
	let isLoading = track(!initialData);
	let hasError  = track(false);
	let isPlaying = track(false);

	// Keep the active Audio instance outside of tracked state — it's mutable
	// imperative state that doesn't need to drive re-renders.
	let audioEl: HTMLAudioElement | null = null;

	function stopAudio() {
		if (audioEl) {
			audioEl.pause();
			audioEl.currentTime = 0;
			audioEl.onended = null;
			audioEl = null;
		}
		isPlaying.value = false;
	}

	// Fetch effect — skipped when `initialData` is provided (demo mode).
	effect(() => {
		if (!url || initialData) return;

		const controller = new AbortController();
		let cancelled = false;

		data.value      = null;
		hasError.value  = false;
		isLoading.value = true;
		stopAudio();

		const currentUrl = (url as string).trim();
		if (!currentUrl) {
			hasError.value  = true;
			isLoading.value = false;
			return () => { cancelled = true; controller.abort(); };
		}

		void (async () => {
			try {
				const res = await fetch(`/api/spotify?url=${encodeURIComponent(currentUrl)}`, {
					signal: controller.signal,
				});
				if (!res.ok) throw new Error('fetch failed');
				const result = await res.json();
				if (cancelled) return;
				if ('error' in result) throw new Error(result.error);
				data.value = result;
			} catch {
				if (!cancelled) hasError.value = true;
			} finally {
				if (!cancelled) isLoading.value = false;
			}
		})();

		return () => {
			cancelled = true;
			controller.abort();
			stopAudio();
		};
	});

	async function handlePlayPause() {
		// Audio APIs are client-only; guard for SSR.
		if (typeof Audio === 'undefined') return;
		const previewUrl = data.value?.audio;
		if (!previewUrl) return;

		if (!audioEl || audioEl.src !== previewUrl) {
			stopAudio();
			audioEl = new Audio(previewUrl);
			audioEl.volume = 0.3;
			audioEl.onended = () => { isPlaying.value = false; };
		}

		if (isPlaying.value) {
			audioEl.pause();
			isPlaying.value = false;
			return;
		}

		try {
			await audioEl.play();
			isPlaying.value = true;
		} catch {
			isPlaying.value = false;
		}
	}

	const imgTranslate = track(() => {
		const playing = isPlaying.value;
		return playing ? '-translate-x-0.5' : '';
	});

	const vinylTranslate = track(() => {
		const playing = isPlaying.value;
		return playing ? 'translate-x-[-10%]' : 'translate-x-[-50%] group-hover:translate-x-[-10%]';
	});

	<>
	@if (isLoading.value) {
		<div
			data-slot="spotify-card-skeleton"
			class={cn(
				'border-border bg-muted/50 relative flex h-full max-h-[100px] w-full items-stretch justify-center overflow-hidden rounded-2xl border p-3',
				className,
			)}
			{...restProps}
		>
			<div class="bg-muted aspect-square w-full max-w-[75px] animate-pulse self-center rounded-lg"></div>
			<div class="z-10 flex w-full flex-col justify-end">
				<div class="flex flex-col items-end gap-1 pl-6">
					<div class="bg-muted h-4 w-24 animate-pulse rounded"></div>
					<div class="bg-muted h-4 w-16 animate-pulse rounded"></div>
				</div>
			</div>
		</div>
	} @else if (hasError.value || !data.value) {
		<div
			data-slot="spotify-card-error"
			class={cn(
				'border-border bg-muted/50 text-muted-foreground flex h-[100px] w-full items-center justify-center rounded-2xl border p-6',
				className,
			)}
			{...restProps}
		>
			<p class="text-sm">{'Failed to load Spotify data'}</p>
		</div>
	} @else {
		<div
			data-slot="spotify-card"
			class={cn(
				'border-border relative flex h-full max-h-[100px] w-full items-stretch justify-center overflow-hidden rounded-2xl border p-3',
				className,
			)}
			{...restProps}
		>
			{/* Blurred album art backdrop */}
			<div class="pointer-events-none absolute top-1/2 left-1/2 z-0 block aspect-square w-[120%] -translate-x-1/2 -translate-y-1/2">
				<div class="pointer-events-none flex h-full opacity-100 select-none">
					<img
						src={data.value.image}
						alt=""
						class="absolute top-0 left-0 block h-full w-full blur-[50px] brightness-150"
					/>
					<div class="absolute top-0 left-0 h-full w-full bg-[linear-gradient(180deg,_rgba(0,_0,_0,_0)_0,_rgba(0,_0,_0,_.8)_100%)]"></div>
				</div>
			</div>

			{/* Album art / play button */}
			<button
				type="button"
				onClick={() => void handlePlayPause()}
				class={cn(
					'group relative z-[1] w-full max-w-[75px] self-center',
					data.value.audio ? 'cursor-pointer' : 'cursor-default',
				)}
				aria-label={
					data.value.audio
						? isPlaying.value
							? `Pause preview for ${data.value.title}`
							: `Play preview for ${data.value.title}`
						: `${data.value.title} cover art`
				}
			>
				<img
					src={data.value.image}
					alt={data.value.title}
					class={cn(
						'pointer-events-none relative z-[1] min-h-[75px] w-full min-w-[75px] rounded-lg object-cover shadow-md transition-transform duration-300 ease-out select-none',
						data.value.audio && 'group-hover:-translate-x-0.5',
						imgTranslate.value,
					)}
				/>

				@if (data.value.audio) {
					{/* Spinning vinyl disk that peeks out from behind the cover art */}
					<div
						class={cn(
							'absolute top-1/2 left-1/2 -z-[1] size-[80%] -translate-y-1/2 transition-all duration-300',
							vinylTranslate.value,
						)}
					>
						<svg
							xmlns="http://www.w3.org/2000/svg"
							viewBox="0 0 110 110"
							class="size-full animate-spin"
							style={`animation-duration:3s;animation-play-state:${isPlaying.value ? 'running' : 'paused'};`}
							aria-hidden="true"
						>
							<circle cx="55" cy="55" r="55" fill="#000" />
							<mask
								id={maskId}
								width="110"
								height="110"
								x="0"
								y="0"
								maskUnits="userSpaceOnUse"
								style="mask-type:alpha;"
							>
								<circle cx="55" cy="55" r="55" fill="#000" />
							</mask>
							<g mask={`url(#${maskId})`}>
								<g filter={`url(#${filterId0})`}>
									<circle cx="55" cy="55" r="51.5" stroke="#fff" stroke-opacity="0.21" />
								</g>
								<g filter={`url(#${filterId1})`}>
									<circle cx="55" cy="55" r="47.5" stroke="#fff" stroke-opacity="0.21" />
								</g>
								<g filter={`url(#${filterId2})`}>
									<circle cx="55" cy="55" r="45.5" stroke="#fff" stroke-opacity="0.21" />
								</g>
								<g filter={`url(#${filterId3})`}>
									<circle cx="55" cy="55" r="43.5" stroke="#fff" stroke-opacity="0.21" />
								</g>
								<g filter={`url(#${filterId4})`}>
									<circle cx="55" cy="55" r="37.5" stroke="#fff" stroke-opacity="0.21" />
								</g>
								<g filter={`url(#${filterId5})`}>
									<circle cx="55" cy="55" r="34.5" stroke="#fff" stroke-opacity="0.21" />
								</g>
								<g filter={`url(#${filterId6})`} opacity="0.4">
									<path fill="#fff" d="M-14 38l68 19.579L-14 74V38z" />
								</g>
								<g filter={`url(#${filterId7})`} opacity="0.4">
									<path fill="#fff" d="M123 38L55 57.579 123 74V38z" />
								</g>
								<g filter={`url(#${filterId8})`} opacity="0.4">
									<path fill="#fff" d="M36.5 124.5l19.579-68 16.421 68h-36z" />
								</g>
								<g filter={`url(#${filterId9})`} opacity="0.4">
									<path fill="#fff" d="M36.5-12.5l19.579 68 16.421-68h-36z" />
								</g>
							</g>
							<defs>
								<filter id={filterId0} width="108" height="108" x="1" y="1" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="1" />
								</filter>
								<filter id={filterId1} width="100" height="100" x="5" y="5" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="1" />
								</filter>
								<filter id={filterId2} width="96" height="96" x="7" y="7" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="1" />
								</filter>
								<filter id={filterId3} width="92" height="92" x="9" y="9" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="1" />
								</filter>
								<filter id={filterId4} width="80" height="80" x="15" y="15" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="1" />
								</filter>
								<filter id={filterId5} width="74" height="74" x="18" y="18" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="1" />
								</filter>
								<filter id={filterId6} width="100" height="68" x="-30" y="22" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="8" />
								</filter>
								<filter id={filterId7} width="100" height="68" x="39" y="22" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="8" />
								</filter>
								<filter id={filterId8} width="68" height="100" x="20.5" y="40.5" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="8" />
								</filter>
								<filter id={filterId9} width="68" height="100" x="20.5" y="-28.5" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse">
									<feFlood flood-opacity="0" result="BackgroundImageFix" />
									<feBlend in="SourceGraphic" in2="BackgroundImageFix" result="shape" />
									<feGaussianBlur result="effect1_foregroundBlur" stdDeviation="8" />
								</filter>
							</defs>
						</svg>
					</div>
				}
			</button>

			{/* Track info + Spotify link */}
			<div class="z-10 flex w-full flex-col justify-between">
				<div class="flex self-end">
					<a
						href={data.value.link}
						target="_blank"
						rel="noopener noreferrer"
						class="cursor-pointer text-[#BAAEBA]"
						aria-label={`Open ${data.value.title} on Spotify`}
					>
						{/* Inline Spotify logo — no external icon dep needed */}
						<svg viewBox="0 0 24 24" class="size-[18px]" fill="currentColor" aria-hidden="true">
							<circle cx="12" cy="12" r="10" />
							<path d="M7.6 9.4c3.3-1 6.8-.6 9.3.8" stroke="#111" stroke-width="1.5" stroke-linecap="round" fill="none" />
							<path d="M8.4 12.2c2.6-.7 5.4-.4 7.4.7" stroke="#111" stroke-width="1.4" stroke-linecap="round" fill="none" />
							<path d="M9.2 14.8c1.9-.4 3.8-.2 5.3.5" stroke="#111" stroke-width="1.3" stroke-linecap="round" fill="none" />
						</svg>
					</a>
				</div>

				<div class="pl-6 text-end">
					<h2 class="text-sm font-semibold tracking-[-.006em] whitespace-nowrap text-[#D6D1D4]">
						{data.value.title}
					</h2>
					<h2 class="text-sm font-medium tracking-[-.006em] whitespace-nowrap text-[#BAAEBA]">
						{data.value.artist}
					</h2>
				</div>
			</div>
		</div>
	}
	</>
}
