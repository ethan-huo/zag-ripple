import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// cobe (WebGL globe) requires canvas + window — must be client-only (inside effect).
// Svelte Spring → hand-rolled spring simulation ticked on every rAF frame; keeps
// the dependency surface minimal without adding a spring library.

const BASE_THETA = 0.2;
const THETA_OFFSET_MIN = -0.4;
const THETA_OFFSET_MAX = 0.4;

function clamp(value: number, min: number, max: number) {
	return Math.min(max, Math.max(min, value));
}

// Minimal critically-damped spring state; updated imperatively inside rAF to
// avoid coupling the Ripple reactivity layer to the animation clock.
function makeSpring(stiffness = 0.12, damping = 0.7) {
	return { pos: 0, vel: 0, target: 0, stiffness, damping };
}

function tickSpring(s: ReturnType<typeof makeSpring>, dt: number) {
	// Implicit Euler — stable for the parameter ranges cobe uses.
	const force = -s.stiffness * (s.pos - s.target) - s.damping * s.vel;
	s.vel += force * dt;
	s.pos += s.vel * dt;
}

export function Globe({ class: className, config = {} }: any) @{
	const isDragging = track(false);
	let canvasNode = track<HTMLCanvasElement | null>(null);

	effect(() => {
		const canvas = canvasNode.value;
		if (!canvas) return;

		const size = config.width ?? 300;
		const initialPhi: number = config.phi ?? 0;
		const initialTheta: number = config.theta ?? BASE_THETA;

		let globe: any = null;
		let frame = 0;
		let isVisible = false;
		let autoPhi = 0;

		// Spring state for pointer drag — not tracked by Ripple (purely imperative).
		const phiSpring = makeSpring(0.12, 0.7);
		const thetaSpring = makeSpring(0.12, 0.7);
		let prevT = 0;

		let dragStart: { x: number; y: number; phi: number; theta: number } | null = null;
		let lastPointer: { x: number; y: number; t: number } | null = null;
		let releaseVelocity = { phi: 0, theta: 0 };

		// Lazy-load cobe to avoid bundling WebGL into the SSR chunk.
		let createGlobePromise: Promise<any> | null = null;
		function getCreateGlobe() {
			createGlobePromise ??= import('cobe').then((m) => m.default);
			return createGlobePromise;
		}

		function stopAnimation() {
			if (!frame) return;
			cancelAnimationFrame(frame);
			frame = 0;
		}

		function destroyGlobe() {
			stopAnimation();
			globe?.destroy();
			globe = null;
		}

		function animate(t: number) {
			if (!globe) { frame = 0; return; }

			const dt = prevT ? Math.min((t - prevT) / 16, 3) : 1;
			prevT = t;

			if (!isDragging.value) {
				autoPhi += 0.005;
			}

			tickSpring(phiSpring, dt);
			tickSpring(thetaSpring, dt);

			globe.update({
				phi: initialPhi + autoPhi + phiSpring.pos,
				theta: initialTheta + thetaSpring.pos,
			});

			frame = requestAnimationFrame(animate);
		}

		async function startGlobe() {
			if (!canvas || globe) {
				if (globe && !frame) requestAnimationFrame(animate);
				return;
			}

			const createGlobe = await getCreateGlobe();
			if (!canvas || globe || !isVisible) return;

			globe = createGlobe(canvas, {
				devicePixelRatio: Math.min(window.devicePixelRatio, 2),
				width: size,
				height: size,
				phi: 0,
				theta: BASE_THETA,
				dark: 0,
				diffuse: 1.7,
				mapSamples: 13000,
				mapBrightness: 6,
				baseColor: [1, 1, 1],
				markerColor: [0.9, 0.4, 0.1],
				glowColor: [1, 1, 1],
				markers: [
					{ location: [37.78, -122.44], size: 0.026 },
					{ location: [40.71, -74.01], size: 0.026 },
				],
				markerElevation: 0,
				...config,
			});

			requestAnimationFrame(animate);
		}

		// Pointer handlers attached to window so drag continues outside canvas.
		function handlePointerDown(event: PointerEvent) {
			dragStart = {
				x: event.clientX,
				y: event.clientY,
				phi: phiSpring.target,
				theta: thetaSpring.target,
			};
			lastPointer = { x: event.clientX, y: event.clientY, t: performance.now() };
			releaseVelocity = { phi: 0, theta: 0 };
			isDragging.value = true;
			canvas?.setPointerCapture?.(event.pointerId);
		}

		function handlePointerMove(event: PointerEvent) {
			if (!dragStart) return;

			const nextPhi = dragStart.phi + (event.clientX - dragStart.x) / 300;
			const nextTheta = clamp(
				dragStart.theta + (event.clientY - dragStart.y) / 1000,
				THETA_OFFSET_MIN,
				THETA_OFFSET_MAX,
			);

			// Instant snap to dragged position (no spring lag while dragging).
			phiSpring.pos = nextPhi;
			phiSpring.target = nextPhi;
			phiSpring.vel = 0;
			thetaSpring.pos = nextTheta;
			thetaSpring.target = nextTheta;
			thetaSpring.vel = 0;

			const now = performance.now();
			if (lastPointer) {
				const dt = Math.max(now - lastPointer.t, 1);
				const maxVelocity = 0.15;
				releaseVelocity = {
					phi: clamp(((event.clientX - lastPointer.x) / dt) * 0.3, -maxVelocity, maxVelocity),
					theta: clamp(
						((event.clientY - lastPointer.y) / dt) * 0.08,
						-maxVelocity,
						maxVelocity,
					),
				};
			}
			lastPointer = { x: event.clientX, y: event.clientY, t: now };
		}

		function handlePointerUp(event?: PointerEvent) {
			if (!dragStart) return;
			isDragging.value = false;
			dragStart = null;
			lastPointer = null;

			if (event && canvas?.hasPointerCapture(event.pointerId)) {
				canvas.releasePointerCapture(event.pointerId);
			}

			// Flick: carry release velocity into the spring target.
			phiSpring.target = phiSpring.pos + releaseVelocity.phi * 18;
			thetaSpring.target = clamp(
				thetaSpring.pos + releaseVelocity.theta * 12,
				THETA_OFFSET_MIN,
				THETA_OFFSET_MAX,
			);
			releaseVelocity = { phi: 0, theta: 0 };
		}

		const onPointerMove = (e: PointerEvent) => handlePointerMove(e);
		const onPointerUp = (e: PointerEvent) => handlePointerUp(e);

		window.addEventListener('pointermove', onPointerMove, { passive: true });
		window.addEventListener('pointerup', onPointerUp, { passive: true });
		window.addEventListener('pointercancel', onPointerUp, { passive: true });

		canvas.addEventListener('pointerdown', handlePointerDown);

		// Use IntersectionObserver to start/pause the rAF loop off-screen.
		const observer = new IntersectionObserver(
			([entry]) => {
				if (!entry) return;
				isVisible = entry.isIntersecting;
				if (isVisible) {
					void startGlobe();
				} else {
					stopAnimation();
				}
			},
			{ threshold: 0.1 },
		);
		observer.observe(canvas);

		return () => {
			observer.disconnect();
			canvas.removeEventListener('pointerdown', handlePointerDown);
			window.removeEventListener('pointermove', onPointerMove);
			window.removeEventListener('pointerup', onPointerUp);
			window.removeEventListener('pointercancel', onPointerUp);
			handlePointerUp();
			destroyGlobe();
		};
	});

	<>
	<div class={cn('globe-container absolute inset-0 mx-auto aspect-square w-full max-w-[37.5rem]', className)}>
		<canvas
			ref={(el) => { canvasNode.value = el as HTMLCanvasElement | null; }}
			class={cn(
				'block size-full touch-none select-none contain-[layout_paint_size]',
				isDragging.value ? 'cursor-grabbing' : 'cursor-grab',
			)}
		/>
	</div>
	</>
}
