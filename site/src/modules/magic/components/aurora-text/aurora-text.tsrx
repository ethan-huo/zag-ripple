import { cn } from '@/lib/utils';

// Aurora text animates a wide gradient (200% wide) across the text via
// background-clip:text. The keyframes live in <style> so they're scoped here
// and don't pollute shared CSS. Speed prop controls animation-duration only;
// the base is 10 s (same as source) which we divide by `speed`.
export function AuroraText({
	children,
	class: className,
	colors = ['#FF0080', '#7928CA', '#0070F3', '#38bdf8'],
	speed = 1,
}: any) @{
	// Build the gradient as an inline style — color list is dynamic so we
	// can't use Tailwind utilities. Wrap back to first color so the loop is seamless.
	const gradientStyle = `background-image: linear-gradient(135deg, ${colors.join(', ')}, ${colors[0]}); -webkit-background-clip: text; -webkit-text-fill-color: transparent; animation-duration: ${10 / speed}s;`;

	<>
	<span class={cn('relative inline-block', className)}>
		{/* Screen-reader copy — visible to AT, invisible in paint */}
		<span class="sr-only">{children}</span>
		{/* Visually animated copy — hidden from AT to avoid duplication */}
		<span
			class="magic-aurora-text relative bg-clip-text text-transparent"
			aria-hidden="true"
			style={gradientStyle}
		>
			{children}
		</span>
	</span>

	<style>
		@keyframes magic-aurora {
			0%   { background-position: 0% 50%;   }
			25%  { background-position: 50% 100%; }
			50%  { background-position: 100% 50%; }
			75%  { background-position: 50% 0%;   }
			100% { background-position: 0% 50%;   }
		}
		.magic-aurora-text {
			background-size: 200% auto;
			animation-name: magic-aurora;
			animation-timing-function: ease-in-out;
			animation-iteration-count: infinite;
			animation-direction: alternate;
		}
	</style>
	</>
}
