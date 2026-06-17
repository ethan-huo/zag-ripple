import { ShimmerButton } from './shimmer-button.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-4 py-8">
		<ShimmerButton>
			{'Get Started'}
		</ShimmerButton>
		<ShimmerButton shimmerColor="#a855f7" background="rgba(15, 10, 30, 1)">
			{'Learn More'}
		</ShimmerButton>
		<ShimmerButton shimmerColor="#22d3ee" shimmerDuration="2s" borderRadius="8px" background="rgba(5, 20, 30, 1)">
			{'Explore'}
		</ShimmerButton>
	</div>
	</>
}
