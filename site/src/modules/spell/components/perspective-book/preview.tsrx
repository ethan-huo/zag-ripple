import { PerspectiveBook } from './perspective-book.tsrx';

export function Preview() @{
	<>
	<div class="flex items-center justify-center gap-8 py-8">
		<PerspectiveBook size="sm">
			<div class="flex h-full flex-col justify-between">
				<span class="text-[10px] font-semibold uppercase tracking-widest text-muted-foreground">{'Vol. I'}</span>
				<div>
					<p class="text-xs font-bold text-foreground">{'Small'}</p>
				</div>
			</div>
		</PerspectiveBook>

		<PerspectiveBook>
			<div class="flex h-full flex-col justify-between">
				<span class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">{'Design'}</span>
				<div>
					<h3 class="text-sm font-bold leading-tight text-foreground">{'Perspective'}</h3>
					<p class="mt-1 text-[10px] text-muted-foreground">{'Hover to open'}</p>
				</div>
			</div>
		</PerspectiveBook>

		<PerspectiveBook size="lg">
			<div class="flex h-full flex-col justify-between">
				<span class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">{'Large'}</span>
				<div>
					<h3 class="text-base font-bold leading-tight text-foreground">{'The Big Read'}</h3>
					<p class="mt-1 text-xs text-muted-foreground">{'Hover to open'}</p>
				</div>
			</div>
		</PerspectiveBook>
	</div>
	</>
}
