import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// All canvas, ResizeObserver, requestAnimationFrame, and Image loading are
// deferred to effects — this component renders only a div+canvas shell on the
// server, making the component SSR-safe despite heavy client-only DOM API usage.

// 4×4 Bayer matrix for ordered dithering (lower quality, cheaper)
const BAYER_4x4 = [
	[0, 8, 2, 10],
	[12, 4, 14, 6],
	[3, 11, 1, 9],
	[15, 7, 13, 5],
];

// 8×8 Bayer matrix for finer dithering (higher quality grids)
const BAYER_8x8 = [
	[0, 32, 8, 40, 2, 34, 10, 42],
	[48, 16, 56, 24, 50, 18, 58, 26],
	[12, 44, 4, 36, 14, 46, 6, 38],
	[60, 28, 52, 20, 62, 30, 54, 22],
	[3, 35, 11, 43, 1, 33, 9, 41],
	[51, 19, 59, 27, 49, 17, 57, 25],
	[15, 47, 7, 39, 13, 45, 5, 37],
	[63, 31, 55, 23, 61, 29, 53, 21],
];

function parseColor(color: string): [number, number, number] {
	if (color.startsWith('#')) {
		const hex = color.slice(1);
		if (hex.length === 3) {
			return [
				parseInt(hex[0] + hex[0], 16),
				parseInt(hex[1] + hex[1], 16),
				parseInt(hex[2] + hex[2], 16),
			];
		}
		return [
			parseInt(hex.slice(0, 2), 16),
			parseInt(hex.slice(2, 4), 16),
			parseInt(hex.slice(4, 6), 16),
		];
	}
	const match = color.match(/rgb\((\d+)\s*,\s*(\d+)\s*,\s*(\d+)\)/i);
	if (match) return [parseInt(match[1]), parseInt(match[2]), parseInt(match[3])];
	return [0, 0, 0];
}

function getLuminance(r: number, g: number, b: number): number {
	return 0.299 * r + 0.587 * g + 0.114 * b;
}

function clampVal(v: number, lo: number, hi: number): number {
	return Math.max(lo, Math.min(hi, v));
}

function applyDithering(
	ctx: CanvasRenderingContext2D,
	imageData: ImageData,
	displayWidth: number,
	displayHeight: number,
	opts: {
		gridSize: number;
		pixelRatio: number;
		ditherMode: string;
		colorMode: string;
		invert: boolean;
		brightness: number;
		contrast: number;
		backgroundColor: string;
		threshold: number;
		primaryColor: [number, number, number];
		secondaryColor: [number, number, number];
		customPalette: [number, number, number][];
		time: number;
	},
) {
	if (opts.backgroundColor !== 'transparent') {
		ctx.fillStyle = opts.backgroundColor;
		ctx.fillRect(0, 0, displayWidth, displayHeight);
	} else {
		ctx.clearRect(0, 0, displayWidth, displayHeight);
	}

	const sourceData = imageData.data;
	const sourceWidth = imageData.width;
	const sourceHeight = imageData.height;

	const effectivePixelSize = Math.max(1, Math.floor(opts.gridSize * opts.pixelRatio));
	const matrixSize = opts.gridSize <= 4 ? 4 : 8;
	const bayerMatrix = opts.gridSize <= 4 ? BAYER_4x4 : BAYER_8x8;
	const matrixScale = matrixSize === 4 ? 16 : 64;

	for (let y = 0; y < displayHeight; y += effectivePixelSize) {
		for (let x = 0; x < displayWidth; x += effectivePixelSize) {
			const srcX = Math.floor((x / displayWidth) * sourceWidth);
			const srcY = Math.floor((y / displayHeight) * sourceHeight);
			const srcIdx = (srcY * sourceWidth + srcX) * 4;

			let r = sourceData[srcIdx] || 0;
			let g = sourceData[srcIdx + 1] || 0;
			let b = sourceData[srcIdx + 2] || 0;
			const a = sourceData[srcIdx + 3] || 0;
			if (a < 10) continue;

			r = clampVal((r - 128) * opts.contrast + 128 + opts.brightness * 255, 0, 255);
			g = clampVal((g - 128) * opts.contrast + 128 + opts.brightness * 255, 0, 255);
			b = clampVal((b - 128) * opts.contrast + 128 + opts.brightness * 255, 0, 255);

			const luminance = getLuminance(r, g, b) / 255;

			const matrixX = Math.floor(x / opts.gridSize) % matrixSize;
			const matrixY = Math.floor(y / opts.gridSize) % matrixSize;

			let ditherThreshold: number;
			switch (opts.ditherMode) {
				case 'bayer':
					ditherThreshold = bayerMatrix[matrixY][matrixX] / matrixScale;
					break;
				case 'halftone': {
					const angle = Math.PI / 4;
					const scale = opts.gridSize * 2;
					const rotX = x * Math.cos(angle) + y * Math.sin(angle);
					const rotY = -x * Math.sin(angle) + y * Math.cos(angle);
					ditherThreshold = (Math.sin(rotX / scale) + Math.sin(rotY / scale) + 2) / 4;
					break;
				}
				case 'noise': {
					const noiseVal = Math.sin(x * 12.9898 + y * 78.233 + opts.time * 100) * 43758.5453;
					ditherThreshold = noiseVal - Math.floor(noiseVal);
					break;
				}
				case 'crosshatch': {
					const line1 = (x + y) % (opts.gridSize * 2) < opts.gridSize ? 1 : 0;
					const line2 = (x - y + opts.gridSize * 4) % (opts.gridSize * 2) < opts.gridSize ? 1 : 0;
					ditherThreshold = (line1 + line2) / 2;
					break;
				}
				default:
					ditherThreshold = bayerMatrix[matrixY][matrixX] / matrixScale;
			}

			ditherThreshold = ditherThreshold * (1 - opts.threshold) + opts.threshold * 0.5;

			let outputColor: [number, number, number];
			switch (opts.colorMode) {
				case 'grayscale': {
					const dark = luminance < ditherThreshold;
					outputColor = dark ? [0, 0, 0] : [255, 255, 255];
					break;
				}
				case 'duotone': {
					const dark = luminance < ditherThreshold;
					outputColor = dark ? opts.primaryColor : opts.secondaryColor;
					break;
				}
				case 'custom': {
					if (opts.customPalette.length === 2) {
						const dark = luminance < ditherThreshold;
						outputColor = dark ? opts.customPalette[0] : opts.customPalette[1];
					} else {
						const adjusted = luminance + (ditherThreshold - 0.5) * 0.5;
						const idx = Math.floor(
							clampVal(adjusted, 0, 1) * (opts.customPalette.length - 1),
						);
						outputColor = opts.customPalette[idx];
					}
					break;
				}
				case 'original':
				default: {
					const ditherAmount = ditherThreshold - 0.5;
					const levels = 4;
					outputColor = [
						Math.round(clampVal(r + ditherAmount * 64, 0, 255) / (255 / levels)) * (255 / levels),
						Math.round(clampVal(g + ditherAmount * 64, 0, 255) / (255 / levels)) * (255 / levels),
						Math.round(clampVal(b + ditherAmount * 64, 0, 255) / (255 / levels)) * (255 / levels),
					];
					break;
				}
			}

			if (opts.invert) {
				outputColor = [255 - outputColor[0], 255 - outputColor[1], 255 - outputColor[2]];
			}

			ctx.fillStyle = `rgb(${outputColor[0]},${outputColor[1]},${outputColor[2]})`;
			ctx.fillRect(x, y, effectivePixelSize, effectivePixelSize);
		}
	}
}

export function DitherShader({
	src,
	gridSize = 4,
	ditherMode = 'bayer',
	colorMode = 'original',
	invert = false,
	pixelRatio = 1,
	primaryColor = '#000000',
	secondaryColor = '#ffffff',
	customPalette = ['#000000', '#ffffff'],
	brightness = 0,
	contrast = 1,
	backgroundColor = 'transparent',
	objectFit = 'cover',
	threshold = 0.5,
	animated = false,
	animationSpeed = 0.02,
	class: className,
}: any) @{
	let containerRef = track<HTMLDivElement | null>(null);
	let canvasRef = track<HTMLCanvasElement | null>(null);

	// All heavy work lives in a single effect. Props are read at effect-run time so
	// any prop change (src, gridSize, colorMode…) retriggers the full re-render.
	// ResizeObserver, Image, and requestAnimationFrame are not available on the server.
	effect(() => {
		const container = containerRef.value;
		const canvas = canvasRef.value;
		if (!container || !canvas) return;

		let rafId: number | null = null;
		let imageData: ImageData | null = null;
		let timeRef = 0;

		const parsedPrimary = parseColor(primaryColor);
		const parsedSecondary = parseColor(secondaryColor);
		const parsedPalette = (customPalette as string[]).map(parseColor) as [number, number, number][];

		function renderFrame(ctx: CanvasRenderingContext2D, w: number, h: number, t: number) {
			if (!imageData) return;
			applyDithering(ctx, imageData, w, h, {
				gridSize,
				pixelRatio,
				ditherMode,
				colorMode,
				invert,
				brightness,
				contrast,
				backgroundColor,
				threshold,
				primaryColor: parsedPrimary,
				secondaryColor: parsedSecondary,
				customPalette: parsedPalette,
				time: t,
			});
		}

		function processImage(img: HTMLImageElement, displayWidth: number, displayHeight: number) {
			if (rafId !== null) {
				cancelAnimationFrame(rafId);
				rafId = null;
			}

			const dpr = window.devicePixelRatio || 1;
			canvas.width = Math.floor(displayWidth * dpr);
			canvas.height = Math.floor(displayHeight * dpr);

			const ctx = canvas.getContext('2d');
			if (!ctx) return;
			ctx.resetTransform();
			ctx.scale(dpr, dpr);

			// Offscreen canvas for pixel extraction respects objectFit layout
			const offscreen = document.createElement('canvas');
			const iw = img.naturalWidth || displayWidth;
			const ih = img.naturalHeight || displayHeight;
			let dw = displayWidth, dh = displayHeight, dx = 0, dy = 0;
			if (objectFit === 'cover') {
				const s = Math.max(displayWidth / iw, displayHeight / ih);
				dw = Math.ceil(iw * s); dh = Math.ceil(ih * s);
				dx = Math.floor((displayWidth - dw) / 2); dy = Math.floor((displayHeight - dh) / 2);
			} else if (objectFit === 'contain') {
				const s = Math.min(displayWidth / iw, displayHeight / ih);
				dw = Math.ceil(iw * s); dh = Math.ceil(ih * s);
				dx = Math.floor((displayWidth - dw) / 2); dy = Math.floor((displayHeight - dh) / 2);
			} else if (objectFit === 'fill') {
				dw = displayWidth; dh = displayHeight;
			} else {
				dw = iw; dh = ih;
				dx = Math.floor((displayWidth - dw) / 2); dy = Math.floor((displayHeight - dh) / 2);
			}
			offscreen.width = displayWidth;
			offscreen.height = displayHeight;
			const offCtx = offscreen.getContext('2d');
			if (!offCtx) return;
			offCtx.drawImage(img, dx, dy, dw, dh);
			try {
				imageData = offCtx.getImageData(0, 0, displayWidth, displayHeight);
			} catch {
				console.error('DitherShader: could not read image pixels (CORS?)');
				return;
			}

			timeRef = 0;
			renderFrame(ctx, displayWidth, displayHeight, timeRef);

			if (animated) {
				const loop = () => {
					timeRef += animationSpeed;
					renderFrame(ctx, displayWidth, displayHeight, timeRef);
					rafId = requestAnimationFrame(loop);
				};
				rafId = requestAnimationFrame(loop);
			}
		}

		let currentImg: HTMLImageElement | null = null;
		let currentW = 0;
		let currentH = 0;

		function repaint(w: number, h: number) {
			currentW = w; currentH = h;
			if (currentImg && currentImg.complete) {
				processImage(currentImg, w, h);
			} else {
				const img = new Image();
				img.crossOrigin = 'anonymous';
				img.src = src;
				img.onload = () => {
					currentImg = img;
					processImage(img, currentW, currentH);
				};
				img.onerror = () => console.error('DitherShader: failed to load image:', src);
				currentImg = img;
			}
		}

		const ro = new ResizeObserver((entries) => {
			for (const entry of entries) {
				const { width, height } = entry.contentRect;
				if (width > 0 && height > 0) repaint(width, height);
			}
		});
		ro.observe(container);

		const { width: initW, height: initH } = container.getBoundingClientRect();
		if (initW > 0 && initH > 0) repaint(initW, initH);

		return () => {
			ro.disconnect();
			if (rafId !== null) cancelAnimationFrame(rafId);
		};
	});

	<>
	<div
		ref={(el) => { containerRef.value = el; }}
		class={cn('relative h-full w-full', className)}
	>
		<canvas
			ref={(el) => { canvasRef.value = el; }}
			class="absolute inset-0 h-full w-full"
			style="image-rendering: pixelated;"
			aria-label="Dithered image"
		/>
	</div>
	</>
}
