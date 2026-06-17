import { PulsatingButton } from './pulsating-button.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-wrap items-center justify-center gap-6 p-10">
		<PulsatingButton variant="slow" pulseColor="#6366f1">
			{'Get Started'}
		</PulsatingButton>
		<PulsatingButton variant="ring" pulseColor="#22c55e" duration="2s">
			{'Subscribe'}
		</PulsatingButton>
		<PulsatingButton variant="ripple" pulseColor="#f59e0b" distance="12px">
			{'Learn More'}
		</PulsatingButton>
	</div>
	</>
}
