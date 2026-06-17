import { cn } from '@/lib/utils';
import { LuArrowRight } from '@/lib/lucide-icons.tsrx';
import { Button } from '@/components/ui/button.tsrx';

// BentoGrid: responsive auto-rows grid wrapper. Three columns by default;
// individual cards control their own col-span via `class`.
export function BentoGrid({ children, class: className, ...rest }: any) @{
	<>
	<div class={cn('grid w-full auto-rows-[22rem] grid-cols-3 gap-4', className)} {...rest}>
		{children}
	</div>
	</>
}

// BentoCard: a single bento cell.
// `background` is a render-prop (zero-arg function returning JSX) so callers can
// compose arbitrary background content without needing a named slot — matches the
// Svelte `Snippet` pattern one-to-one.
// `Icon` is a TSRX component constructor rendered inline.
export function BentoCard({
	name,
	class: className,
	background,
	Icon,
	iconClass = '',
	description,
	href,
	cta,
	...rest
}: any) @{
	<>
	<div
		class={cn(
			'group relative col-span-3 flex flex-col justify-between overflow-hidden rounded-xl',
			// light styles
			'bg-background [box-shadow:0_0_0_1px_rgba(0,0,0,.03),0_2px_4px_rgba(0,0,0,.05),0_12px_24px_rgba(0,0,0,.05)]',
			// dark styles
			'dark:bg-background transform-gpu dark:[box-shadow:0_-20px_80px_-20px_#ffffff1f_inset] dark:[border:1px_solid_rgba(255,255,255,.1)]',
			className,
		)}
		{...rest}
	>
		<div>{background?.()}</div>
		<div class="p-4">
			<div class="pointer-events-none z-10 flex transform-gpu flex-col gap-1 transition-all duration-300 lg:group-hover:-translate-y-10">
				@if (Icon) {
					<Icon
						class={cn(
							'h-12 w-12 origin-left transform-gpu text-neutral-700 transition-all duration-300 ease-in-out group-hover:scale-75',
							iconClass,
						)}
					/>
				}
				<h3 class="text-xl font-semibold text-neutral-700 dark:text-neutral-300">
					{name}
				</h3>
				<p class="max-w-lg text-neutral-400">{description}</p>
			</div>
			{/* Mobile CTA — always visible on small screens */}
			<div class="pointer-events-none flex w-full translate-y-0 transform-gpu flex-row items-center transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100 lg:hidden">
				<Button variant="link" size="sm" class="pointer-events-auto p-0" href={href}>
					{cta}
					<LuArrowRight class="ms-2 h-4 w-4 rtl:rotate-180" />
				</Button>
			</div>
		</div>
		{/* Desktop CTA — slides up on hover */}
		<div class="pointer-events-none absolute bottom-0 hidden w-full translate-y-10 transform-gpu flex-row items-center p-4 opacity-0 transition-all duration-300 group-hover:translate-y-0 group-hover:opacity-100 lg:flex">
			<Button href={href} variant="link" size="sm" class="pointer-events-auto p-0">
				{cta}
				<LuArrowRight class="ms-2 h-4 w-4 rtl:rotate-180" />
			</Button>
		</div>
		<div class="pointer-events-none absolute inset-0 transform-gpu transition-all duration-300 group-hover:bg-black/3 group-hover:dark:bg-neutral-800/10" />
	</div>
	</>
}
