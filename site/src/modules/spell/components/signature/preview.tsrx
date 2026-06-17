import { Signature } from './signature.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-8 py-8">
		<div class="flex flex-col items-center gap-2">
			<Signature
				text="Hello World"
				color="currentColor"
				fontSize={16}
				duration={1.5}
				delay={0}
				class="text-foreground"
			/>
			<span class="text-xs text-muted-foreground">{'Hello World'}</span>
		</div>
		<div class="flex flex-col items-center gap-2">
			<Signature
				text="Signature"
				color="#6366f1"
				fontSize={20}
				duration={2}
				delay={0.2}
			/>
			<span class="text-xs text-muted-foreground">{'Signature — indigo'}</span>
		</div>
	</div>
	</>
}
