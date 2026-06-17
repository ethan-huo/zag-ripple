// A module-level counter generates a stable, unique filter ID per component
// instance. Counter is deterministic on both server and client (module
// re-initialises once per environment), so SSR/hydration IDs stay in sync as
// long as render order matches — which it does for static previews.
let _counter = 0;

// Wraps children in an SVG bloom filter: blur → saturate 4x → composite over
// source. The result is a vivid "backlight" glow without any canvas or JS
// animation — pure SVG filter stack, safe for SSR.
export function Backlight({ children, class: className, blur = 10 }: any) @{
	const filterId = `backlight-${++_counter}`;

	<div class={className}>
		<svg width="0" height="0" aria-hidden="true" style="position:absolute;width:0;height:0;overflow:hidden;">
			<filter id={filterId} y="-50%" x="-50%" width="200%" height="200%">
				<feGaussianBlur in="SourceGraphic" stdDeviation={blur} result="blurred" />
				<feColorMatrix type="saturate" in="blurred" values="4" />
				<feComposite in="SourceGraphic" operator="over" />
			</filter>
		</svg>
		<div style={`filter: url(#${filterId})`}>
			{children}
		</div>
	</div>
}
