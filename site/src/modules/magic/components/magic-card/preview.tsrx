import { MagicCard } from './magic-card.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-4 sm:flex-row">
		<MagicCard
			class="h-56 w-64 cursor-pointer rounded-2xl border border-border p-6 shadow-md"
			gradientFrom="#9E7AFF"
			gradientTo="#FE8BBB"
		>
			<div class="flex h-full flex-col justify-between">
				<span class="text-xs uppercase tracking-widest text-muted-foreground">{'Magic'}</span>
				<div>
					<h3 class="text-xl font-bold text-foreground">{'Magic Card'}</h3>
					<p class="mt-1 text-sm text-muted-foreground">{'Move your cursor to reveal the gradient border.'}</p>
				</div>
			</div>
		</MagicCard>
		<MagicCard
			class="h-56 w-64 cursor-pointer rounded-2xl border border-border p-6 shadow-md"
			gradientFrom="#40c8ff"
			gradientTo="#ff6b6b"
			gradientColor="#1a1a2e"
		>
			<div class="flex h-full flex-col justify-between">
				<span class="text-xs uppercase tracking-widest text-muted-foreground">{'Custom'}</span>
				<div>
					<h3 class="text-xl font-bold text-foreground">{'Blue & Red'}</h3>
					<p class="mt-1 text-sm text-muted-foreground">{'Customisable gradient colors.'}</p>
				</div>
			</div>
		</MagicCard>
	</div>
	</>
}
