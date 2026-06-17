import { getModule, groupComponents, type ModuleId } from '@/modules';
import { cn } from '@/lib/utils';

// Active component is passed in (`activeId`) rather than read from a client
// router — under SSR each page knows its own params.
export function ModuleSidebar({ module, activeId }: { module: ModuleId; activeId?: string }) @{
	const mod = getModule(module)!;
	const groups = groupComponents(mod);

	<>
	<aside class="hidden lg:block w-60 shrink-0 border-r border-border">
		<div class="sticky top-12 max-h-[calc(100vh-3rem)] overflow-y-auto px-4 py-6">
			<a
				href={`/${mod.id}`}
				class="mb-4 block text-sm font-semibold text-foreground hover:text-primary"
			>
				{mod.tagline}
			</a>

			@for (const section of groups) {
				<div class="mb-5">
					<h4 class="mb-2 px-2 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
						{section.group}
					</h4>
					<ul class="space-y-0.5">
						@for (const item of section.items) {
							<li>
								<a
									href={`/${mod.id}/${item.id}`}
									class={cn(
										'block rounded-md px-2 py-1.5 text-sm transition-colors',
										activeId === item.id
											? 'bg-muted font-medium text-foreground'
											: 'text-muted-foreground hover:bg-muted/50 hover:text-foreground',
									)}
								>
									{item.title}
								</a>
							</li>
						}
					</ul>
				</div>
			}
		</div>
	</aside>
	</>
}
