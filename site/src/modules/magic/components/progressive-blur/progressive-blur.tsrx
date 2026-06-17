import { cn } from '@/lib/utils';

// Each blur level gets its own backdrop-filter div whose mask-image confines it
// to a single band of the overlay. Stacking n bands produces a smooth blur
// ramp with no visible seams. The mask math mirrors the Svelte source 1:1:
// band width = 100% / n, each layer occupies three consecutive bands and fades
// at the edges so neighbouring layers blend rather than hard-cut.
export function ProgressiveBlur({
	class: className,
	height = '30%',
	position = 'bottom',
	blurLevels = [0.5, 1, 2, 4, 8, 16, 32, 64],
	...rest
}: any) @{
	const n = blurLevels.length;
	// Middle layers — all except first and last.
	const middleIndices = Array.from({ length: n - 2 }, (_, i) => i);

	// Mask gradients confine each layer to its assigned band.  The step size is
	// 100% / n so the math stays correct for any blurLevels array length.
	const step = 100 / n;

	const getMaskGradient = (index: number) => {
		const blurIndex = index + 1;
		const start = blurIndex * step;
		const mid = (blurIndex + 1) * step;
		const end = (blurIndex + 2) * step;

		if (position === 'bottom') {
			return `linear-gradient(to bottom, rgba(0,0,0,0) ${start}%, rgba(0,0,0,1) ${mid}%, rgba(0,0,0,1) ${end}%, rgba(0,0,0,0) ${end + step}%)`;
		} else if (position === 'top') {
			return `linear-gradient(to top, rgba(0,0,0,0) ${start}%, rgba(0,0,0,1) ${mid}%, rgba(0,0,0,1) ${end}%, rgba(0,0,0,0) ${end + step}%)`;
		} else {
			return `linear-gradient(rgba(0,0,0,0) 0%, rgba(0,0,0,1) 5%, rgba(0,0,0,1) 95%, rgba(0,0,0,0) 100%)`;
		}
	};

	const getFirstLayerMask = () => {
		if (position === 'bottom') {
			return `linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,1) ${step}%, rgba(0,0,0,1) ${step * 2}%, rgba(0,0,0,0) ${step * 3}%)`;
		} else if (position === 'top') {
			return `linear-gradient(to top, rgba(0,0,0,0) 0%, rgba(0,0,0,1) ${step}%, rgba(0,0,0,1) ${step * 2}%, rgba(0,0,0,0) ${step * 3}%)`;
		} else {
			return `linear-gradient(rgba(0,0,0,0) 0%, rgba(0,0,0,1) 5%, rgba(0,0,0,1) 95%, rgba(0,0,0,0) 100%)`;
		}
	};

	const getLastLayerMask = () => {
		if (position === 'bottom') {
			return `linear-gradient(to bottom, rgba(0,0,0,0) ${step * (n - 1)}%, rgba(0,0,0,1) 100%)`;
		} else if (position === 'top') {
			return `linear-gradient(to top, rgba(0,0,0,0) ${step * (n - 1)}%, rgba(0,0,0,1) 100%)`;
		} else {
			return `linear-gradient(rgba(0,0,0,0) 0%, rgba(0,0,0,1) 5%, rgba(0,0,0,1) 95%, rgba(0,0,0,0) 100%)`;
		}
	};

	const firstMask = getFirstLayerMask();
	const lastMask = getLastLayerMask();

	<>
	<div
		class={cn(
			'pointer-events-none absolute inset-x-0 z-10',
			position === 'top' ? 'top-0' : position === 'bottom' ? 'bottom-0' : 'inset-y-0',
			className,
		)}
		style={`height: ${position === 'both' ? '100%' : height};`}
		{...rest}
	>
		{/* First blur layer */}
		<div
			class="absolute inset-0"
			style={`z-index: 1; backdrop-filter: blur(${blurLevels[0]}px); -webkit-backdrop-filter: blur(${blurLevels[0]}px); mask-image: ${firstMask}; -webkit-mask-image: ${firstMask};`}
		/>

		{/* Middle blur layers */}
		@for (const index of middleIndices) {
			<div
				class="absolute inset-0"
				style={`z-index: ${index + 2}; backdrop-filter: blur(${blurLevels[index + 1]}px); -webkit-backdrop-filter: blur(${blurLevels[index + 1]}px); mask-image: ${getMaskGradient(index)}; -webkit-mask-image: ${getMaskGradient(index)};`}
			/>
		}

		{/* Last blur layer */}
		<div
			class="absolute inset-0"
			style={`z-index: ${n}; backdrop-filter: blur(${blurLevels[n - 1]}px); -webkit-backdrop-filter: blur(${blurLevels[n - 1]}px); mask-image: ${lastMask}; -webkit-mask-image: ${lastMask};`}
		/>
	</div>
	</>
}
