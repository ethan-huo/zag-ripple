import { cn } from '@/lib/utils';

// CSS-only shimmer button: a rotating conic-gradient creates the travelling
// shimmer arc. `@container-[size]` lets the spark layer track 100cqh without
// JS, so the entire effect is SSR-safe — no effects needed.
export function ShimmerButton({
	children,
	class: className,
	shimmerColor = '#ffffff',
	shimmerSize = '0.05em',
	shimmerDuration = '3s',
	borderRadius = '100px',
	background = 'rgba(0, 0, 0, 1)',
	...props
}: any) @{
	const inlineStyle = [
		`--spread: 90deg`,
		`--shimmer-color: ${shimmerColor}`,
		`--radius: ${borderRadius}`,
		`--speed: ${shimmerDuration}`,
		`--cut: ${shimmerSize}`,
		`--bg: ${background}`,
	].join('; ');

	<>
	<button
		style={inlineStyle}
		class={cn(
			'group relative z-0 flex cursor-pointer items-center justify-center overflow-hidden [border-radius:var(--radius)] border border-white/10 px-6 py-3 whitespace-nowrap text-white [background:var(--bg)]',
			'transform-gpu transition-transform duration-300 ease-in-out active:translate-y-px',
			className,
		)}
		{...props}
	>
		{/* spark container — container-type:size lets the child use 100cqh */}
		<div class={cn('-z-30 blur-[2px]', 'shimmer-btn__spark-container absolute inset-0 overflow-visible')}>
			{/* spark track — slides along the Y axis */}
			<div class="shimmer-btn__slide absolute inset-0 aspect-[1] h-[100cqh] rounded-none [mask:none]">
				{/* conic-gradient rotates continuously inside the track */}
				<div class="shimmer-btn__spin absolute -inset-full w-auto rotate-0 [translate:0_0] [background:conic-gradient(from_calc(270deg-(var(--spread)*0.5)),transparent_0,var(--shimmer-color)_var(--spread),transparent_var(--spread))]"></div>
			</div>
		</div>

		{children}

		{/* inner highlight — brightens on hover / press */}
		<div
			class={cn(
				'absolute inset-0 size-full',
				'rounded-2xl px-4 py-1.5 text-sm font-medium shadow-[inset_0_-8px_10px_#ffffff1f]',
				'transform-gpu transition-all duration-300 ease-in-out',
				'group-hover:shadow-[inset_0_-6px_10px_#ffffff3f]',
				'group-active:shadow-[inset_0_-10px_10px_#ffffff3f]',
			)}
		></div>

		{/* backdrop cutout — hides the spark behind the button face */}
		<div class="absolute inset-(--cut) -z-20 [border-radius:var(--radius)] [background:var(--bg)]"></div>
	</button>

	<style>
		/* Container query on the spark layer so h-[100cqh] resolves correctly. */
		.shimmer-btn__spark-container {
			container-type: size;
		}

		@keyframes shimmer-btn-slide {
			to { transform: translate(calc(100cqw - 100%), 0); }
		}

		@keyframes shimmer-btn-spin {
			from { transform: rotate(0deg); }
			to   { transform: rotate(360deg); }
		}

		.shimmer-btn__slide {
			animation: shimmer-btn-slide var(--speed, 3s) ease-in-out infinite alternate;
		}

		.shimmer-btn__spin {
			animation: shimmer-btn-spin calc(var(--speed, 3s) * 2) linear infinite;
		}
	</style>
	</>
}
