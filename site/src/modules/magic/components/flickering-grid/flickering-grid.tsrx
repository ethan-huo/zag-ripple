import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Canvas-based flickering grid. ALL browser APIs (canvas, requestAnimationFrame,
// ResizeObserver, IntersectionObserver) live inside effect() — the render body
// runs on the server too and must stay pure.
export function FlickeringGrid({
	squareSize = 4,
	gridGap = 6,
	flickerChance = 0.3,
	color = 'rgb(0, 0, 0)',
	width,
	height,
	class: className,
	maxOpacity = 0.3,
	...rest
}: any) @{
	const canvasRef = track<HTMLCanvasElement | null>(null);
	const containerRef = track<HTMLDivElement | null>(null);

	effect(() => {
		const canvas = canvasRef.value;
		const container = containerRef.value;
		if (!canvas || !container) return;

		const ctx = canvas.getContext('2d');
		if (!ctx) return;

		// Parse any CSS color string into an `rgba(r,g,b,` prefix by drawing it
		// on a 1×1 offscreen canvas — the only reliable cross-browser approach.
		const toRGBAPrefix = (colorStr: string): string => {
			const tiny = document.createElement('canvas');
			tiny.width = tiny.height = 1;
			const tctx = tiny.getContext('2d');
			if (!tctx) return 'rgba(0,0,0,';
			tctx.fillStyle = colorStr;
			tctx.fillRect(0, 0, 1, 1);
			const [r, g, b] = Array.from(tctx.getImageData(0, 0, 1, 1).data);
			return `rgba(${r},${g},${b},`;
		};

		const rgbaPrefix = toRGBAPrefix(color);

		interface GridParams {
			cols: number;
			rows: number;
			squares: Float32Array;
			dpr: number;
		}

		const setupCanvas = (w: number, h: number): GridParams => {
			const dpr = window.devicePixelRatio || 1;
			canvas.width = w * dpr;
			canvas.height = h * dpr;
			canvas.style.width = `${w}px`;
			canvas.style.height = `${h}px`;
			const cols = Math.floor(w / (squareSize + gridGap));
			const rows = Math.floor(h / (squareSize + gridGap));
			const squares = new Float32Array(cols * rows);
			for (let i = 0; i < squares.length; i++) {
				squares[i] = Math.random() * maxOpacity;
			}
			return { cols, rows, squares, dpr };
		};

		const updateSquares = (squares: Float32Array, deltaTime: number) => {
			for (let i = 0; i < squares.length; i++) {
				if (Math.random() < flickerChance * deltaTime) {
					squares[i] = Math.random() * maxOpacity;
				}
			}
		};

		const drawGrid = (params: GridParams) => {
			const { cols, rows, squares, dpr } = params;
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			for (let i = 0; i < cols; i++) {
				for (let j = 0; j < rows; j++) {
					const opacity = squares[i * rows + j];
					ctx.fillStyle = `${rgbaPrefix}${opacity})`;
					ctx.fillRect(
						i * (squareSize + gridGap) * dpr,
						j * (squareSize + gridGap) * dpr,
						squareSize * dpr,
						squareSize * dpr,
					);
				}
			}
		};

		let rafId: number;
		let gridParams: GridParams;
		let isInView = false;
		let lastTime = 0;

		const tick = (time: number) => {
			if (!isInView) return;
			const deltaTime = (time - lastTime) / 1000;
			lastTime = time;
			updateSquares(gridParams.squares, deltaTime);
			drawGrid(gridParams);
			rafId = requestAnimationFrame(tick);
		};

		const updateSize = () => {
			const w = width ?? container.clientWidth;
			const h = height ?? container.clientHeight;
			gridParams = setupCanvas(w, h);
		};

		updateSize();

		const ro = new ResizeObserver(() => {
			updateSize();
		});
		ro.observe(container);

		// Only run the RAF loop while the canvas is visible — saves CPU when
		// scrolled away.
		const io = new IntersectionObserver(
			([entry]) => {
				isInView = entry.isIntersecting;
				if (isInView) {
					lastTime = performance.now();
					rafId = requestAnimationFrame(tick);
				} else {
					cancelAnimationFrame(rafId);
				}
			},
			{ threshold: 0 },
		);
		io.observe(canvas);

		return () => {
			cancelAnimationFrame(rafId);
			ro.disconnect();
			io.disconnect();
		};
	});

	<>
	<div
		ref={(el) => { containerRef.value = el; }}
		class={cn('h-full w-full', className)}
		{...rest}
	>
		<canvas
			ref={(el) => { canvasRef.value = el; }}
			class="pointer-events-none"
		/>
	</div>
	</>
}
