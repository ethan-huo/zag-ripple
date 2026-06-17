// @ts-expect-error qrcode ships no bundled TS declarations
import QRCodePackage from 'qrcode';
import { track } from 'ripple';
import { cn } from '@/lib/utils';

// `qrcode.create()` is pure JS math — SSR-safe. We call it in `track(() =>
// ...)` (derived) so the SVG is ready on first render without an effect round-
// trip. Rendering happens entirely in SVG; the `qrcode` canvas/png renderers
// are never invoked.

type ErrorCorrectionLevel = 'L' | 'M' | 'Q' | 'H';

interface QRModules {
	size: number;
	get(row: number, col: number): boolean;
}

interface QRData {
	modules: QRModules;
}

interface CirclePoint {
	cx: number;
	cy: number;
}

const QRCodeLib = QRCodePackage as {
	create(value: string, options: { errorCorrectionLevel: ErrorCorrectionLevel }): QRData;
};

function isInFinderPattern(row: number, col: number, size: number): boolean {
	return (row < 7 && col < 7) || (row < 7 && col >= size - 7) || (row >= size - 7 && col < 7);
}

export function QRCode({
	value,
	size = 268,
	fgColor = 'var(--foreground)',
	bgColor = 'var(--background)',
	errorCorrectionLevel = 'M',
	class: className,
	...restProps
}: any) @{
	// Pure derived — no DOM, runs safely during SSR.
	const qrData = track((): QRData | null => {
		try {
			return QRCodeLib.create(value, { errorCorrectionLevel });
		} catch {
			return null;
		}
	});

	const moduleCount = track(() => qrData.value?.modules.size ?? 0);
	const moduleSize = track(() => (moduleCount.value ? size / moduleCount.value : 0));
	const circleRadius = track(() => moduleSize.value / 3);

	const finderPositions = track((): [number, number][] => [
		[0, 0],
		[0, moduleCount.value - 7],
		[moduleCount.value - 7, 0],
	]);

	const finderSize = track(() => 7 * moduleSize.value);
	const innerPadding = track(() => moduleSize.value);
	const innerWhiteSize = track(() => 5 * moduleSize.value);
	const innerBlackSize = track(() => 3 * moduleSize.value);

	const circles = track((): CirclePoint[] => {
		const data = qrData.value;
		if (!data) return [];
		const count = moduleCount.value;
		const mSize = moduleSize.value;
		const result: CirclePoint[] = [];
		for (let row = 0; row < count; row++) {
			for (let col = 0; col < count; col++) {
				if (data.modules.get(row, col) && !isInFinderPattern(row, col, count)) {
					result.push({ cx: (col + 0.5) * mSize, cy: (row + 0.5) * mSize });
				}
			}
		}
		return result;
	});

	<>
	@if (qrData.value) {
		<svg
			width={size}
			height={size}
			viewBox={`0 0 ${size} ${size}`}
			xmlns="http://www.w3.org/2000/svg"
			aria-label={`QR code for ${value}`}
			class={cn('block', className)}
			{...restProps}
		>
			<rect width={size} height={size} fill={bgColor} rx="12" ry="12" />

			@for (const fp of finderPositions.value; index fi; key fi) {
				<g>
					<rect
						x={fp[1] * moduleSize.value}
						y={fp[0] * moduleSize.value}
						width={finderSize.value}
						height={finderSize.value}
						fill={fgColor}
						rx="12"
						ry="12"
					/>
					<rect
						x={fp[1] * moduleSize.value + innerPadding.value}
						y={fp[0] * moduleSize.value + innerPadding.value}
						width={innerWhiteSize.value}
						height={innerWhiteSize.value}
						fill={bgColor}
						rx="8"
						ry="8"
					/>
					<rect
						x={fp[1] * moduleSize.value + innerPadding.value * 2}
						y={fp[0] * moduleSize.value + innerPadding.value * 2}
						width={innerBlackSize.value}
						height={innerBlackSize.value}
						fill={fgColor}
						rx="3"
						ry="3"
					/>
				</g>
			}

			@for (const dot of circles.value; index ci; key ci) {
				<circle cx={dot.cx} cy={dot.cy} r={circleRadius.value} fill={fgColor} />
			}
		</svg>
	}
	</>
}
