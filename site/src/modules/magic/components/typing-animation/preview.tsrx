import { TypingAnimation } from './typing-animation.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6 text-center">
		<div class="text-4xl font-bold tracking-tight text-foreground">
			<TypingAnimation
				content="Build stunning UIs."
				class="text-primary"
				startOnView={false}
			/>
		</div>
		<div class="text-xl text-muted-foreground">
			<TypingAnimation
				words={['Compose.', 'Animate.', 'Ship.']}
				loop={true}
				startOnView={false}
				cursorStyle="line"
			/>
		</div>
	</div>
	</>
}
