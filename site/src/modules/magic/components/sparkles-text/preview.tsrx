import { SparklesText } from './sparkles-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-4 py-8">
		<SparklesText
			sparklesCount={12}
			colors={{ first: '#9E7AFF', second: '#FE8BBB' }}
			class="text-5xl font-bold"
		>
			{'Sparkles'}
		</SparklesText>
		<SparklesText
			sparklesCount={8}
			colors={{ first: '#FFD700', second: '#FF6B6B' }}
			class="text-3xl font-semibold text-foreground"
		>
			{'Magic Text'}
		</SparklesText>
	</div>
	</>
}
