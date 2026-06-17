import { AnimatedGradientSvg } from './animated-gradient-svg.tsrx';

const WARM_COLORS = ['#FFA412', '#FF4500', '#FF9900'];
const COOL_COLORS = ['#6366f1', '#8b5cf6', '#06b6d4'];

export function Preview() @{
	<>
	<div class="flex h-64 w-full items-center justify-center gap-4 bg-background p-6">
		<div class="relative flex h-full flex-1 flex-col justify-between overflow-hidden rounded-2xl p-4 font-medium">
			<span class="pointer-events-none absolute inset-0 z-0 bg-[#ff592f]">
				<AnimatedGradientSvg colors={WARM_COLORS} speed={10} blur="medium" />
			</span>
			<div class="relative z-10 flex h-full flex-col justify-between">
				<div>
					<div class="text-sm font-semibold text-white">Animated Bento</div>
					<div class="text-xs text-white/80">#001</div>
				</div>
				<div class="text-xs leading-tight text-white">Using only SVG circles and blur</div>
			</div>
		</div>

		<div class="relative flex h-full w-36 flex-col justify-between overflow-hidden rounded-2xl p-4 font-medium">
			<span class="pointer-events-none absolute inset-0 z-0 bg-indigo-700">
				<AnimatedGradientSvg colors={COOL_COLORS} speed={8} blur="light" />
			</span>
			<div class="relative z-10 flex h-full flex-col justify-between">
				<div class="text-sm font-semibold text-white">Gradients</div>
				<button class="mt-2 cursor-pointer rounded-full border border-white px-2 py-0.5 text-xs font-medium text-white">
					Explore More
				</button>
			</div>
		</div>
	</div>
	</>
}
