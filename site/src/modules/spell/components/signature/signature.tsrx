import { effect, track } from 'ripple';
import { animate, inView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// opentype.js is loaded client-side inside effect because it calls fetch +
// ArrayBuffer APIs that don't exist on the server.
//
// Path drawing uses the SVG stroke-dasharray trick: dasharray = dashoffset =
// getTotalLength(), then animate dashoffset → 0. This is the CSS-native way
// since motion@12 (vanilla DOM) does not expose framer-motion's synthetic
// `pathLength` prop — that lives in the React build only.
//
// Animation lifecycle:
//   1. effect: fetch font → parse glyphs → set paths[]
//   2. render: @for renders <path> elements; ref callbacks populate pathRefs[]
//   3. effect: when pathRefs[] length matches paths[] length, snap then animate.

const SVG_HEIGHT = 100;
// Font URL served from /public — same origin avoids CORS.
const FONT_URL = '/LastoriaBoldRegular.otf';

type SignaturePath = {
	id: string;
	d: string;
	delay: number;
};

export function Signature({
	text = 'Signature',
	color = 'currentColor',
	fontSize = 14,
	duration = 1.5,
	delay = 0,
	inView: triggerInView = false,
	once = true,
	class: className,
	...rest
}: any) @{
	const paths = track([]);
	const svgWidth = track(300);
	// Ordered list of resolved <path> DOM nodes — one per SignaturePath entry.
	const pathRefs = track([]);
	const svgNode = track(null);

	// Derived geometry — pure, SSR-safe.
	const horizontalPadding = track(() => fontSize * 0.1);
	const topMargin = track(() => Math.max(5, (SVG_HEIGHT - fontSize) / 2));
	const baseline = track(() => Math.min(SVG_HEIGHT - 5, topMargin.value + fontSize));

	// Cancel in-flight requests if props change before the previous fetch resolves.
	let requestId = 0;

	// Build glyph paths on the client whenever text/fontSize/baseline changes.
	effect(() => {
		// Declare dependencies so effect re-runs on prop changes.
		const _text = text;
		const _fontSize = fontSize;
		const _baseline = baseline.value;
		const _hPad = horizontalPadding.value;
		const _delay = delay;

		const currentRequest = ++requestId;
		// Reset refs synchronously so the animation effect won't fire with stale nodes.
		pathRefs.value = [];

		// Use promise chaining instead of async IIFE so `await` keywords don't
		// appear inside the synchronous effect callback (TSRX can't transform async
		// functions nested inside the component setup body).
		import('opentype.js').then((mod) => {
			const opentype = mod.default;
			return fetch(FONT_URL).then((response) => {
				if (!response.ok) throw new Error(`Font fetch failed: ${response.status}`);
				return response.arrayBuffer().then((buf) => {
					const font = opentype.parse(buf);

					if (currentRequest !== requestId) return;

					const fontOptions = { kerning: true, features: { liga: true, rlig: true } };
					const nextPaths = [];

					font.forEachGlyph(
						_text,
						_hPad,
						_baseline,
						_fontSize,
						fontOptions,
						(glyph, glyphX, glyphY, glyphFontSize) => {
							const pathData = glyph
								.getPath(glyphX, glyphY, glyphFontSize)
								.toPathData(3)
								.trim();
							if (pathData) {
								nextPaths.push({
									id: `path-${nextPaths.length}`,
									d: pathData,
									delay: _delay + nextPaths.length * 0.2,
								});
							}
						},
					);

					paths.value = nextPaths;
					svgWidth.value = Math.max(
						font.getAdvanceWidth(_text, _fontSize, fontOptions) + _hPad * 2,
						_fontSize,
					);
				});
			}).catch(() => {
				if (currentRequest !== requestId) return;
				paths.value = [];
				svgWidth.value = Math.max(_text.length * _fontSize * 0.6, _fontSize * 2);
			});
		});
	});

	// Animate paths once all refs are populated for the current path list.
	// pathRefs.value is updated by the ref callbacks in @for; when its length
	// matches paths.value.length the DOM is ready and animation is safe.
	effect(() => {
		const currentPaths = paths.value;
		const refs = pathRefs.value;

		// Wait until every rendered path has a resolved DOM node.
		if (currentPaths.length === 0 || refs.length !== currentPaths.length) return;
		if (refs.some((el) => el === null)) return;

		const svgEl = svgNode.value;

		function runAnimation() {
			for (let i = 0; i < currentPaths.length; i++) {
				const p = currentPaths[i];
				const el = refs[i] as SVGPathElement;

				// getTotalLength is DOM-only; safe here because we're inside effect.
				const len = el.getTotalLength();
				if (len === 0) continue;

				// Stroke draw: dashoffset len → 0 reveals the path progressively.
				animate(
					el,
					{ strokeDashoffset: [len, 0] },
					{ duration, delay: p.delay, ease: 'easeInOut' },
				);

				// Fill fades in at 65% of stroke duration — creates an ink-wet effect.
				const fillDelay = p.delay + duration * 0.65;
				const fillDuration = Math.min(0.25, duration * 0.35);
				animate(el, { fillOpacity: [0, 1] }, { duration: fillDuration, delay: fillDelay, ease: 'linear' });
			}
		}

		// Snap all paths to hidden state: full dashoffset hides the stroke.
		for (const el of refs) {
			if (!el) continue;
			const len = (el as SVGPathElement).getTotalLength();
			// Apply dasharray once here; dashoffset drives the animation.
			(el as SVGPathElement).style.strokeDasharray = String(len);
			(el as SVGPathElement).style.strokeDashoffset = String(len);
			(el as SVGPathElement).style.fillOpacity = '0';
		}

		if (triggerInView && svgEl) {
			return inView(
				svgEl,
				() => {
					runAnimation();
					if (once === false) return undefined;
				},
				{ amount: 0.35 },
			);
		}

		runAnimation();
	});

	<>
	<svg
		ref={(el) => { svgNode.value = el; }}
		width={svgWidth.value}
		height={SVG_HEIGHT}
		viewBox={`0 0 ${svgWidth.value} ${SVG_HEIGHT}`}
		fill="none"
		class={cn('overflow-visible', className)}
		{...rest}
	>
		@for (const path of paths.value; index i) {
			<path
				ref={(el) => {
					// Build the refs array slot by slot as each path mounts.
					// A new array object triggers the animation effect re-check.
					const next = [...pathRefs.value];
					next[i] = el;
					pathRefs.value = next;
				}}
				d={path.d}
				stroke={color}
				stroke-width={2}
				fill={color}
				fill-opacity={0}
				vector-effect="non-scaling-stroke"
				stroke-linecap="butt"
				stroke-linejoin="round"
			/>
		}
	</svg>
	</>
}
