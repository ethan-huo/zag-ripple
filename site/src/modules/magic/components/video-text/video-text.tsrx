import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// The mask is built as an inline SVG data URL so the video is clipped to the
// text shape purely via CSS — no canvas needed. The SVG is regenerated on prop
// change via a tracked derived; the resize listener is deferred to an effect so
// it never runs server-side (SSR-safe).
export function VideoText({
	src,
	content,
	class: className = '',
	autoPlay = true,
	muted = true,
	loop = true,
	preload = 'auto',
	fontSize = 20,
	fontWeight = 'bold',
	textAnchor = 'middle',
	dominantBaseline = 'middle',
	fontFamily = 'sans-serif',
}: any) @{
	// Build the SVG mask string as a derived so it reacts to prop changes.
	// Uses `vw` units so text scales with viewport width (same as original).
	const svgMask = track(() => {
		const responsiveFontSize = typeof fontSize === 'number' ? `${fontSize}vw` : fontSize;
		return `<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%'><text x='50%' y='50%' font-size='${responsiveFontSize}' font-weight='${fontWeight}' text-anchor='${textAnchor}' dominant-baseline='${dominantBaseline}' font-family='${fontFamily}'>${content}</text></svg>`;
	});

	// Encode the SVG as a CSS mask-image data URL — pure string, safe at render.
	const maskUrl = track(() => `url("data:image/svg+xml,${encodeURIComponent(svgMask.value)}")`);

	// Attach resize listener client-side only. The SVG uses `vw` units so the
	// mask itself reflowed by the browser automatically; the listener exists only
	// to force a re-encode when the viewport changes in browsers that cache the
	// data URL. It does nothing functionally when Ripple reacts to prop changes.
	effect(() => {
		const handler = () => {
			// Trigger a masked re-render by nudging svgMask. Because svgMask is a
			// derived track, we cannot write to it — instead rely on the browser
			// natively reflowing `vw` units inside the SVG. No-op here; kept for
			// parity with the Svelte original's intent.
		};
		window.addEventListener('resize', handler);
		return () => window.removeEventListener('resize', handler);
	});

	const maskStyle = track(() => {
		const url = maskUrl.value;
		return [
			`mask-image: ${url}`,
			`-webkit-mask-image: ${url}`,
			`mask-size: contain`,
			`-webkit-mask-size: contain`,
			`mask-repeat: no-repeat`,
			`-webkit-mask-repeat: no-repeat`,
			`mask-position: center`,
			`-webkit-mask-position: center`,
		].join('; ');
	});

	<>
	<div class={cn('relative size-full', className)}>
		<div
			class="absolute inset-0 flex items-center justify-center"
			style={maskStyle.value}
		>
			<video
				class="h-full w-full object-cover"
				autoplay={autoPlay}
				muted={muted}
				loop={loop}
				preload={preload}
				playsinline
			>
				<source src={src} />
				Your browser does not support the video tag.
			</video>
		</div>

		{/* Accessibility: visible text is replaced by mask — keep for SEO/screen readers */}
		<span class="sr-only">{content}</span>
	</div>
	</>
}
