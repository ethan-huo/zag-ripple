import { RippleButton } from './ripple-button.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-wrap items-center justify-center gap-4">
		<RippleButton>Click me</RippleButton>
		<RippleButton rippleColor="#3b82f6" class="border-blue-500 bg-blue-500 text-white">
			Blue Ripple
		</RippleButton>
		<RippleButton rippleColor="#a855f7" duration="800ms" class="border-purple-500 bg-purple-500 text-white">
			Purple Ripple
		</RippleButton>
	</div>
	</>
}
