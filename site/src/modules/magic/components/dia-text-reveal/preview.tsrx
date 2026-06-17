import { DiaTextReveal } from './dia-text-reveal.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 py-8 text-center">
		<p class="text-4xl font-bold tracking-tight text-foreground">
			Build with{' '}
			<DiaTextReveal
				text={['Ripple', 'Motion', 'Zag JS', 'TSRX']}
				repeat={true}
				repeatDelay={1.2}
				once={false}
				class="text-4xl font-bold"
			/>
		</p>
		<p class="text-xl font-semibold text-muted-foreground">
			<DiaTextReveal
				text="Diagonal gradient sweep"
				colors={['#0358f7', '#c679c4', '#fa3d1d', '#ffb005']}
				duration={2}
				class="text-xl font-semibold"
			/>
		</p>
	</div>
	</>
}
