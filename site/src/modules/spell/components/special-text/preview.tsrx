import { SpecialText } from './special-text.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6 py-12">
		<div class="flex flex-col items-center gap-2">
			<p class="text-xs uppercase tracking-widest text-muted-foreground">{'On mount'}</p>
			<SpecialText
				text="Hello, world!"
				class="text-lg text-foreground"
				speed={30}
			/>
		</div>

		<div class="flex flex-col items-center gap-2">
			<p class="text-xs uppercase tracking-widest text-muted-foreground">{'Delayed start'}</p>
			<SpecialText
				text="zag-ripple"
				class="text-2xl font-bold text-primary"
				delay={0.5}
				speed={25}
			/>
		</div>

		<div class="flex flex-col items-center gap-2">
			<p class="text-xs uppercase tracking-widest text-muted-foreground">{'From children'}</p>
			<SpecialText class="text-lg text-foreground" speed={20}>
				{'special text'}
			</SpecialText>
		</div>
	</div>
	</>
}
