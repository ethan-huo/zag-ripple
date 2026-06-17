import { track } from 'ripple';
import { createMap } from 'piri';
import { cn } from '@/lib/utils';

// piri.createMap is a pure GeoJSON-to-SVG-point calculation (no DOM/browser
// APIs), so it is safe to call at render time as a derived value. The SVG
// renders on the server and hydrates without a flash.

interface Marker {
	lat: number;
	lng: number;
	size?: number;
	[key: string]: unknown;
}

export function DottedMap({
	width = 150,
	height = 75,
	mapSamples = 5000,
	markers = [],
	markerColor = '#FF6900',
	dotColor = 'currentColor',
	dotRadius = 0.2,
	stagger: diagonalStagger = true,
	class: className,
	style,
}: any) @{
	// Derive the point set reactively so width/height/mapSamples prop changes
	// automatically re-compute the map without re-mounting the component.
	const map = track(() =>
		createMap({
			width,
			height,
			mapSamples,
			radius: dotRadius,
			grid: diagonalStagger ? 'diagonal' : 'vertical',
		}),
	);

	const points = track(() => map.value.points);

	const processedMarkers = track(() =>
		map.value.addMarkers(markers) as Array<{ x: number; y: number; size?: number }>,
	);

	<>
	<svg
		viewBox={`0 0 ${width} ${height}`}
		class={cn('text-gray-500 dark:text-gray-500', className)}
		style={`width: 100%; height: 100%;${style ? ' ' + style : ''}`}
	>
		@for (const point of points.value; index i) {
			<circle cx={point.x} cy={point.y} r={dotRadius} fill={dotColor} />
		}
		@for (const marker of processedMarkers.value; index j) {
			<circle cx={marker.x} cy={marker.y} r={marker.size ?? dotRadius * 4} fill={markerColor} />
		}
	</svg>
	</>
}
