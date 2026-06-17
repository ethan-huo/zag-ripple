import { AnimatedGradientText } from './animated-gradient-text.tsrx';
import { LuChevronRight } from '@/lib/lucide-icons.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6">
		<div class="group relative mx-auto flex items-center justify-center rounded-full px-4 py-1.5 shadow-[inset_0_-8px_10px_#8fdfff1f] transition-shadow duration-500 ease-out hover:shadow-[inset_0_-5px_10px_#8fdfff3f] border border-border bg-background">
			<span
				class="magic-agt-border-glow absolute inset-0 block h-full w-full rounded-[inherit]"
			></span>
			<span class="text-sm">🎉</span>
			<hr class="mx-2 h-4 w-px shrink-0 bg-neutral-500" />
			<AnimatedGradientText class="text-sm font-medium">
				{'Introducing Magic for Ripple'}
			</AnimatedGradientText>
			<LuChevronRight class="ml-1 size-4 text-muted-foreground transition-transform duration-300 ease-in-out group-hover:translate-x-0.5" />
		</div>

		<AnimatedGradientText class="text-4xl font-bold tracking-tight">
			{'Animated Gradient Text'}
		</AnimatedGradientText>
	</div>

	<style>
		@keyframes magic-preview-gradient-shift {
			0% { background-position: 0% 50%; }
			100% { background-position: 100% 50%; }
		}
		.magic-agt-border-glow {
			background: linear-gradient(to right, #ffaa4080, #9c40ff80, #ffaa4080);
			background-size: 300% 100%;
			animation: magic-preview-gradient-shift 8s linear infinite;
			-webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
			-webkit-mask-composite: destination-out;
			mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
			mask-composite: subtract;
			padding: 1px;
		}
	</style>
	</>
}
