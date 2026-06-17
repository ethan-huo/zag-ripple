import { Letter3DSwap } from './letter-3d-swap.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-8 py-8 font-mono text-3xl font-semibold">
		<Letter3DSwap
			text="Hover over me"
			rotateDirection="right"
			frontFaceClass="text-foreground"
			secondFaceClass="text-primary"
			class="cursor-pointer"
		/>
		<Letter3DSwap
			text="Letter 3D Swap"
			rotateDirection="top"
			staggerFrom="center"
			staggerDuration={0.04}
			frontFaceClass="text-muted-foreground"
			secondFaceClass="text-foreground"
			class="cursor-pointer text-xl"
		/>
	</div>
	</>
}
