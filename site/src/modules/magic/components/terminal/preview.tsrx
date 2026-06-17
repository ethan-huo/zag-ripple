import {
	Terminal,
	AnimatedSpan,
	TypingAnimation,
	createTerminalSequence,
} from './terminal.tsrx';

export function Preview() @{
	// Create the sequence once at setup time — all children share this object.
	const seq = createTerminalSequence();

	<>
	<div class="flex items-center justify-center p-8">
		<Terminal sequence={seq} startOnView={true}>
			<AnimatedSpan sequence={seq} itemIndex={0} class="text-green-400">
				<span>✓ Initializing Ripple runtime…</span>
			</AnimatedSpan>
			<AnimatedSpan sequence={seq} itemIndex={1} class="text-green-400">
				<span>✓ Loading components…</span>
			</AnimatedSpan>
			<AnimatedSpan sequence={seq} itemIndex={2} class="text-green-400">
				<span>✓ Compiling TSRX templates…</span>
			</AnimatedSpan>
			<AnimatedSpan sequence={seq} itemIndex={3} class="text-yellow-400">
				<span>⚡ Optimizing bundle…</span>
			</AnimatedSpan>
			<TypingAnimation
				sequence={seq}
				itemIndex={4}
				text="$ ripple dev --port 3000"
				class="text-muted-foreground"
				duration={50}
			/>
			<AnimatedSpan sequence={seq} itemIndex={5} class="text-primary">
				<span>🚀 Server running at http://localhost:3000</span>
			</AnimatedSpan>
		</Terminal>
	</div>
	</>
}
