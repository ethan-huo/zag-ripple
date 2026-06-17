import { cn } from '@/lib/utils';

// Pure SVG pattern — all geometry is computed at render (SSR-safe pure math).
// The stable `patternId` namespaces the <pattern> element so multiple instances
// on the same page don't collide on the `fill="url(#...)"` reference.

type Direction = 'horizontal' | 'vertical';
type HexPoint = readonly [number, number];

function hexVertexList(cx: number, cy: number, r: number, direction: Direction): HexPoint[] {
	const startAngle = direction === 'horizontal' ? 0 : 30;
	return Array.from({ length: 6 }, (_, i) => {
		const angle = ((startAngle + i * 60) * Math.PI) / 180;
		return [cx + r * Math.cos(angle), cy + r * Math.sin(angle)] as const;
	});
}

function hexPoints(cx: number, cy: number, r: number, direction: Direction): string {
	return hexVertexList(cx, cy, r, direction)
		.map(([px, py]) => `${px},${py}`)
		.join(' ');
}

function edgeLexKey(a: HexPoint, b: HexPoint): string {
	const [p, q] = a[0] < b[0] || (a[0] === b[0] && a[1] <= b[1]) ? [a, b] : [b, a];
	return `${p[0].toFixed(6)},${p[1].toFixed(6)}|${q[0].toFixed(6)},${q[1].toFixed(6)}`;
}

function collectUniqueHexEdges(
	centers: [number, number][],
	r: number,
	direction: Direction,
): [HexPoint, HexPoint][] {
	const seen = new Set<string>();
	const edges: [HexPoint, HexPoint][] = [];

	for (const [cx, cy] of centers) {
		const verts = hexVertexList(cx, cy, r, direction);
		for (let i = 0; i < 6; i++) {
			const a = verts[i];
			const b = verts[(i + 1) % 6];
			const key = edgeLexKey(a, b);
			if (!seen.has(key)) {
				seen.add(key);
				edges.push([a, b]);
			}
		}
	}

	return edges;
}

function isSolidStrokeDasharray(strokeDasharray: string): boolean {
	const t = strokeDasharray.trim();
	return t === '' || t === 'none' || t === '0';
}

function getHexSpacing(
	r: number,
	direction: Direction,
	gap: number,
): { colStep: number; rowStep: number; tileW: number; tileH: number } {
	const sqrt3 = Math.sqrt(3);

	if (direction === 'horizontal') {
		const colStep = (3 * r) / 2 + (sqrt3 * gap) / 2;
		const rowStep = sqrt3 * r + gap;
		return { colStep, rowStep, tileW: colStep * 2, tileH: rowStep };
	}

	const colStep = sqrt3 * r + gap;
	const rowStep = (3 * r) / 2 + (sqrt3 * gap) / 2;
	return { colStep, rowStep, tileW: colStep, tileH: rowStep * 2 };
}

function getTileGeometry(
	r: number,
	direction: Direction,
	gap: number,
): { tileW: number; tileH: number; centers: [number, number][] } {
	const { colStep, rowStep, tileW, tileH } = getHexSpacing(r, direction, gap);

	const canonical: [number, number][] =
		direction === 'horizontal'
			? [
					[colStep / 2, rowStep / 2],
					[(colStep * 3) / 2, rowStep],
				]
			: [
					[colStep / 2, rowStep / 2],
					[colStep, (rowStep * 3) / 2],
				];

	const centers: [number, number][] = [];
	for (const [cx, cy] of canonical) {
		centers.push([cx, cy]);
		if (cy - r < 0) centers.push([cx, cy + tileH]);
		if (cy + r > tileH) centers.push([cx, cy - tileH]);
		if (cx - r < 0) centers.push([cx + tileW, cy]);
		if (cx + r > tileW) centers.push([cx - tileW, cy]);
		if (cy - r < 0 && cx - r < 0) centers.push([cx + tileW, cy + tileH]);
		if (cy - r < 0 && cx + r > tileW) centers.push([cx - tileW, cy + tileH]);
		if (cy + r > tileH && cx - r < 0) centers.push([cx + tileW, cy - tileH]);
		if (cy + r > tileH && cx + r > tileW) centers.push([cx - tileW, cy - tileH]);
	}

	return { tileW, tileH, centers };
}

function hexCenter(
	col: number,
	row: number,
	r: number,
	direction: Direction,
	gap: number,
): [number, number] {
	const { colStep, rowStep } = getHexSpacing(r, direction, gap);
	if (direction === 'horizontal') {
		const px = col * colStep + colStep / 2;
		const py = row * rowStep + rowStep / 2 + (col % 2 !== 0 ? rowStep / 2 : 0);
		return [px, py];
	}
	const px = col * colStep + colStep / 2 + (row % 2 !== 0 ? colStep / 2 : 0);
	const py = row * rowStep + rowStep / 2;
	return [px, py];
}

export function HexagonPattern({
	radius = 40,
	gap = 0,
	x = -1,
	y = -1,
	strokeDasharray = '0',
	direction = 'horizontal',
	hexagons,
	class: className,
	...props
}: any) @{
	// Stable per-instance ID — avoids SVG pattern id collisions across instances.
	const patternId = `hex-${Math.random().toString(36).slice(2, 8)}`;

	const tileGeometry = getTileGeometry(radius, direction, gap);
	const solidStroke = isSolidStrokeDasharray(strokeDasharray);
	const dashedEdges = solidStroke
		? null
		: collectUniqueHexEdges(tileGeometry.centers, radius, direction);

	<>
	<svg
		aria-hidden="true"
		class={cn(
			'pointer-events-none absolute inset-0 h-full w-full fill-gray-400/30 stroke-gray-400/30',
			className,
		)}
		{...props}
	>
		<defs>
			<pattern
				id={patternId}
				width={tileGeometry.tileW}
				height={tileGeometry.tileH}
				patternUnits="userSpaceOnUse"
				x={x}
				y={y}
			>
				@if (solidStroke) {
					@for (const center of tileGeometry.centers; index i) {
						<polygon
							class="fill-none"
							points={hexPoints(center[0], center[1], radius, direction)}
							stroke-dasharray={strokeDasharray}
						/>
					}
				} @else {
					@for (const edge of (dashedEdges ?? []); index i) {
						<line
							class="fill-none"
							x1={edge[0][0]}
							y1={edge[0][1]}
							x2={edge[1][0]}
							y2={edge[1][1]}
							stroke-dasharray={strokeDasharray}
						/>
					}
				}
			</pattern>
		</defs>

		<rect width="100%" height="100%" fill={`url(#${patternId})`} stroke="none" />

		@if (hexagons && hexagons.length > 0) {
			<svg aria-hidden="true" overflow="visible" x={x} y={y}>
				@for (const hex of hexagons; index i) {
					<polygon
						points={(() => {
							const [cx, cy] = hexCenter(hex[0], hex[1], radius, direction, gap);
							return hexPoints(cx, cy, radius - 1, direction);
						})()}
						stroke-width="0"
					/>
				}
			</svg>
		}
	</svg>
	</>
}
