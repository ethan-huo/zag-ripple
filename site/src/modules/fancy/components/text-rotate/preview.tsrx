import { TextRotate } from './text-rotate.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-8 py-8">
		<div class="flex items-baseline gap-2 text-4xl font-bold">
			<span>We are</span>
			<TextRotate
				texts={['designers', 'engineers', 'builders', 'creators']}
				mainClassName="text-primary"
				rotationInterval={2000}
				staggerDuration={0.03}
				staggerFrom="first"
			/>
		</div>
		<TextRotate
			texts={['Fast', 'Reliable', 'Accessible', 'Beautiful']}
			class="text-2xl font-semibold text-muted-foreground"
			rotationInterval={1800}
			initial={{ y: '100%', opacity: 0 }}
			animate={{ y: 0, opacity: 1 }}
			exit={{ y: '-120%', opacity: 0 }}
			staggerDuration={0.04}
			staggerFrom="center"
			transition={{ type: 'spring', damping: 20, stiffness: 250 }}
		/>
	</div>
	</>
}
