import { DottedMap } from './dotted-map.tsrx';

export function Preview() @{
	<>
	<div class="relative h-64 w-full overflow-hidden rounded-xl border border-border bg-card p-4">
		<DottedMap
			width={200}
			height={100}
			mapSamples={4000}
			dotRadius={0.35}
			dotColor="currentColor"
			markerColor="#FF6900"
			markers={[
				{ lat: 40.71, lng: -74.01 },
				{ lat: 51.51, lng: -0.13 },
				{ lat: 35.69, lng: 139.69 },
				{ lat: 1.35, lng: 103.82 },
				{ lat: -33.87, lng: 151.21 },
			]}
			class="text-muted-foreground"
		/>
	</div>
	</>
}
