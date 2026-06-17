import { cn } from '@/lib/utils';
import { LuArrowRight } from '@/lib/lucide-icons.tsrx';

// Children are rendered twice: once in the idle label slot (slides out on hover)
// and once in the revealed slot (slides in on hover). Tailwind group-hover
// drives all transitions — no JS animation needed. The expanding dot behind
// the text creates the fill effect via scale.
export function InteractiveHoverButton({
	children,
	class: className,
	...props
}: any) @{
	<>
	<button
		class={cn(
			'group relative w-auto cursor-pointer overflow-hidden rounded-full border bg-background p-2 px-6 text-center font-semibold',
			className,
		)}
		{...props}
	>
		<div class="flex items-center gap-2">
			<div class="h-2 w-2 rounded-full bg-primary transition-all duration-300 group-hover:scale-[100.8]" />
			<span class="inline-block transition-all duration-300 group-hover:translate-x-12 group-hover:opacity-0">
				{children}
			</span>
		</div>
		<div class="absolute top-0 z-10 flex h-full w-full translate-x-12 items-center justify-center gap-2 text-primary-foreground opacity-0 transition-all duration-300 group-hover:-translate-x-5 group-hover:opacity-100">
			<span>{children}</span>
			<LuArrowRight />
		</div>
	</button>
	</>
}
