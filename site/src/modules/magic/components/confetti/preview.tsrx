import { track } from 'ripple';
import { Confetti, ConfettiButton } from './confetti.tsrx';

export function Preview() @{
	const active = track(false);

	<>
	<div class="flex flex-col items-center gap-8 py-8">
		{/* Wrapper confetti: fires when toggle switches on */}
		<Confetti active={active.value}>
			<button
				class="rounded-lg border border-border bg-card px-6 py-3 text-sm font-semibold text-foreground transition-colors hover:bg-muted"
				onClick={() => {
					active.value = false;
					// Small delay so active transitions false→true and re-triggers effect.
					setTimeout(() => { active.value = true; }, 10);
				}}
			>
				🎉 {'Burst from wrapper'}
			</button>
		</Confetti>

		{/* Self-contained button that fires its own burst */}
		<ConfettiButton>
			{'🎊 Click for Confetti'}
		</ConfettiButton>
	</div>
	</>
}
