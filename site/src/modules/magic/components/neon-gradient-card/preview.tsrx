import { NeonGradientCard } from './neon-gradient-card.tsrx';

export function Preview() @{
	<>
	<div class="flex items-center justify-center gap-6 flex-wrap p-8">
		<NeonGradientCard class="w-72 h-auto">
			<div class="flex flex-col gap-2">
				<span class="text-xs uppercase tracking-widest text-muted-foreground">{'Magic UI'}</span>
				<h3 class="text-xl font-bold text-foreground">{'Neon Gradient Card'}</h3>
				<p class="text-sm text-muted-foreground">
					{'A card with a spinning neon gradient border and a soft glowing halo effect.'}
				</p>
			</div>
		</NeonGradientCard>

		<NeonGradientCard
			class="w-56 h-auto"
			neonColors={{ firstColor: '#00c6ff', secondColor: '#7b2ff7' }}
			borderRadius={12}
		>
			<div class="flex flex-col gap-2">
				<h3 class="text-lg font-semibold text-foreground">{'Custom Colors'}</h3>
				<p class="text-xs text-muted-foreground">{'Blue to purple gradient.'}</p>
			</div>
		</NeonGradientCard>
	</div>
	</>
}
