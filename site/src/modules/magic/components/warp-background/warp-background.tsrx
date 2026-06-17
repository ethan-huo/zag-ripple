import { Motion } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Each beam is pre-computed at render time (pure Math.random — SSR-safe).
// Hue and aspect-ratio vary per beam so the light feels organic and random.
type BeamData = {
	x: number;      // cell index along the face
	delay: number;  // seconds before first travel
	hue: number;    // HSL hue 0–360
	ar: number;     // beam aspect ratio (height multiplier)
};

function makeBeams(beamsPerSide: number, beamSize: number, delayMin: number, delayMax: number): BeamData[] {
	const cellsPerSide = Math.floor(100 / beamSize);
	const step = cellsPerSide / beamsPerSide;
	const beams: BeamData[] = [];
	for (let i = 0; i < beamsPerSide; i++) {
		beams.push({
			x: Math.floor(i * step),
			delay: Math.random() * (delayMax - delayMin) + delayMin,
			hue: Math.floor(Math.random() * 360),
			ar: Math.floor(Math.random() * 10) + 1,
		});
	}
	return beams;
}

// Renders the beams for one grid face.
// `x: '-50%'` is kept constant in both initial and animate so the motion engine
// doesn't reset it to 0 when composing the unified transform property.
function FaceBeams({ beams, beamSize, beamDuration }: { beams: BeamData[]; beamSize: number; beamDuration: number }) @{
	<>
		@for (const beam of beams; index _i) {
			<Motion
				class="absolute top-0"
				style={`left: ${beam.x * beamSize}%; width: ${beamSize}%; aspect-ratio: 1/${beam.ar}; background: linear-gradient(hsl(${beam.hue} 80% 60%), transparent);`}
				initial={{ y: '100cqmax', x: '-50%' }}
				animate={{ y: '-100%', x: '-50%' }}
				transition={{
					duration: beamDuration,
					delay: beam.delay,
					repeat: Infinity,
					ease: 'linear',
				}}
			/>
		}
	</>
}

// 3-D warp background: four perspective grid planes (top / bottom / left / right)
// each shoot coloured beams inward. Drop children inside to get the warp-tunnel
// framing effect.
//
// The grid CSS uses two overlapping linear-gradients to draw the grid lines;
// container-query units (cqmax / cqi / cqh) size the planes relative to their
// own container — those units only resolve after the browser establishes the
// container context, which is why the perspective stage carries `warp-stage`
// (container-type:size) and each face carries `warp-grid-face` (container-type:size).
export function WarpBackground({
	children,
	class: className,
	perspective = 100,
	beamsPerSide = 3,
	beamSize = 5,
	beamDelayMax = 3,
	beamDelayMin = 0,
	beamDuration = 3,
	gridColor = 'var(--border)',
	...rest
}: any) @{
	// All beam data is computed once at render time. Math.random is SSR-safe;
	// the values are stable for the lifetime of this component instance.
	const topBeams = makeBeams(beamsPerSide, beamSize, beamDelayMin, beamDelayMax);
	const rightBeams = makeBeams(beamsPerSide, beamSize, beamDelayMin, beamDelayMax);
	const bottomBeams = makeBeams(beamsPerSide, beamSize, beamDelayMin, beamDelayMax);
	const leftBeams = makeBeams(beamsPerSide, beamSize, beamDelayMin, beamDelayMax);

	// CSS for the grid pattern repeated on all four faces.
	const gridBg = `linear-gradient(${gridColor} 0 1px, transparent 1px ${beamSize}%) 50% -0.5px / ${beamSize}% ${beamSize}%, linear-gradient(90deg, ${gridColor} 0 1px, transparent 1px ${beamSize}%) 50% 50% / ${beamSize}% ${beamSize}%`;

	const faceClass = 'warp-grid-face absolute';

	<>
	<div class={cn('relative rounded border p-20', className)} {...rest}>
		{/* 3-D perspective stage — container-type:size so the face dimensions
		    (100cqi, 100cqh, 100cqmax) resolve against this box, not the viewport */}
		<div
			class="warp-stage pointer-events-none absolute top-0 left-0 size-full overflow-hidden [clip-path:inset(0)] [transform-style:preserve-3d]"
			style={`perspective: ${perspective}px;`}
		>
			{/* top face — tilted backward from the top edge */}
			<div
				class={faceClass}
				style={`top: 0; left: 0; width: 100cqi; height: 100cqmax; transform-origin: 50% 0%; transform: rotateX(-90deg); background: ${gridBg};`}
			>
				<FaceBeams beams={topBeams} beamSize={beamSize} beamDuration={beamDuration} />
			</div>

			{/* bottom face — tilted backward from the bottom edge */}
			<div
				class={faceClass}
				style={`top: 100%; left: 0; width: 100cqi; height: 100cqmax; transform-origin: 50% 0%; transform: rotateX(-90deg); background: ${gridBg};`}
			>
				<FaceBeams beams={bottomBeams} beamSize={beamSize} beamDuration={beamDuration} />
			</div>

			{/* left face — rotated 90° then tilted */}
			<div
				class={faceClass}
				style={`top: 0; left: 0; width: 100cqh; height: 100cqmax; transform-origin: 0% 0%; transform: rotate(90deg) rotateX(-90deg); background: ${gridBg};`}
			>
				<FaceBeams beams={leftBeams} beamSize={beamSize} beamDuration={beamDuration} />
			</div>

			{/* right face — rotated -90° then tilted */}
			<div
				class={faceClass}
				style={`top: 0; right: 0; width: 100cqh; height: 100cqmax; transform-origin: 100% 0%; transform: rotate(-90deg) rotateX(-90deg); background: ${gridBg};`}
			>
				<FaceBeams beams={rightBeams} beamSize={beamSize} beamDuration={beamDuration} />
			</div>
		</div>

		{/* content layer — sits above the 3-D planes */}
		<div class="relative">
			{children}
		</div>
	</div>

	<style>
		/*
		 * The Svelte source sets @container-[size] on the perspective stage so that
		 * the face dimensions (100cqi / 100cqh / 100cqmax) resolve against it.
		 * Each face also needs container-type:size so the beams inside can use
		 * 100cqmax to span the full face height for the travel animation.
		 */
		.warp-stage {
			container-type: size;
		}
		.warp-grid-face {
			container-type: size;
		}
	</style>
	</>
}
