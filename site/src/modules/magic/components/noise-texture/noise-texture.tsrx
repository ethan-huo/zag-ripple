import { cn } from '@/lib/utils';

// Each instance needs a unique filter id to avoid cross-instance bleeding when
// multiple NoiseTextures appear on the same page. Math.random() is SSR-safe
// (pure math, no browser API) and stable enough for a one-time SVG reference.
const makeId = () => `noise-${Math.random().toString(36).slice(2, 9)}`;

export function NoiseTexture({
	class: className,
	frequency = 0.4,
	octaves = 6,
	slope = 0.15,
	noiseOpacity = 0.6,
	...props
}: any) @{
	// Computed once at render time — no reactive wrapper needed since props are
	// received fresh on every render and the id is purely a local DOM reference.
	const filterId = makeId();

	<svg
		class={cn(
			'pointer-events-none absolute inset-0 z-0 size-full opacity-50 select-none dark:opacity-[0.75]',
			className,
		)}
		xmlns="http://www.w3.org/2000/svg"
		{...props}
	>
		<filter id={filterId}>
			<feTurbulence
				type="fractalNoise"
				baseFrequency={frequency}
				numOctaves={octaves}
				stitchTiles="stitch"
			/>
			<feColorMatrix type="saturate" values="0" />
			<feComponentTransfer>
				<feFuncR type="linear" slope={slope} />
				<feFuncG type="linear" slope={slope} />
				<feFuncB type="linear" slope={slope} />
			</feComponentTransfer>
		</filter>
		<rect width="100%" height="100%" filter={`url(#${filterId})`} opacity={noiseOpacity} />
	</svg>
}
