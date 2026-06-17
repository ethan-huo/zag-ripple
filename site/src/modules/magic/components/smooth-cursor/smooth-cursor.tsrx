import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';

// The original uses motion-sv's `useSpring` reactive stores that feed a
// `motion.div` transform directly. We replicate this by driving the same DOM
// node with three independent `animate()` spring calls on each mousemove:
// position, rotation, and scale. All event setup is client-only (inside effect).
export function SmoothCursor({
	cursor,
	springConfig = {
		damping: 45,
		stiffness: 400,
		mass: 1,
		restDelta: 0.001,
	},
}: any) @{
	let node = track<HTMLElement | null>(null);

	effect(() => {
		const el = node.value;
		if (!el) return;

		let lastMouseX = 0;
		let lastMouseY = 0;
		let lastUpdateTime = Date.now();
		let velocityX = 0;
		let velocityY = 0;
		let previousAngle = 0;
		let accumulatedRotation = 0;
		let rafId = 0;
		let scaleResetTimeout = 0;

		// Hide native cursor while this custom one is active.
		document.body.style.cursor = 'none';

		const positionSpring = { type: 'spring', ...springConfig };
		const rotationSpring = { type: 'spring', ...springConfig, damping: 60, stiffness: 300 };
		const scaleSpring = { type: 'spring', ...springConfig, damping: 35, stiffness: 500 };

		function onMouseMove(e: MouseEvent) {
			if (rafId) return;
			rafId = requestAnimationFrame(() => {
				rafId = 0;
				const now = Date.now();
				const dt = now - lastUpdateTime;
				if (dt > 0) {
					velocityX = (e.clientX - lastMouseX) / dt;
					velocityY = (e.clientY - lastMouseY) / dt;
				}
				lastUpdateTime = now;
				lastMouseX = e.clientX;
				lastMouseY = e.clientY;

				// Animate position with spring.
				animate(
					el,
					{ x: e.clientX, y: e.clientY },
					positionSpring as any,
				);

				const speed = Math.sqrt(velocityX * velocityX + velocityY * velocityY);
				if (speed > 0.1) {
					// Angle points in direction of travel (+90° so cursor tip leads).
					const angle = Math.atan2(velocityY, velocityX) * (180 / Math.PI) + 90;
					let diff = angle - previousAngle;
					if (diff > 180) diff -= 360;
					if (diff < -180) diff += 360;
					accumulatedRotation += diff;
					previousAngle = angle;

					animate(el, { rotate: accumulatedRotation }, rotationSpring as any);
					animate(el, { scale: 0.95 }, scaleSpring as any);

					clearTimeout(scaleResetTimeout);
					scaleResetTimeout = setTimeout(() => {
						animate(el, { scale: 1 }, scaleSpring as any);
					}, 150) as unknown as number;
				}
			});
		}

		window.addEventListener('mousemove', onMouseMove);

		// Entrance animation from invisible.
		animate(el, { scale: [0, 1] }, { type: 'spring', stiffness: 400, damping: 30 });

		return () => {
			window.removeEventListener('mousemove', onMouseMove);
			document.body.style.cursor = 'auto';
			if (rafId) cancelAnimationFrame(rafId);
			clearTimeout(scaleResetTimeout);
		};
	});

	<>
	<div
		ref={(el) => { node.value = el; }}
		style="position: fixed; left: 0; top: 0; translate: -50% -50%; z-index: 9999; pointer-events: none; will-change: transform;"
	>
		@if (cursor) {
			{cursor}
		} @else {
			<svg
				xmlns="http://www.w3.org/2000/svg"
				width={50}
				height={54}
				viewBox="0 0 50 54"
				fill="none"
				style="scale: 0.5"
			>
				<g filter="url(#filter0_d_91_7928)">
					<path
						d="M42.6817 41.1495L27.5103 6.79925C26.7269 5.02557 24.2082 5.02558 23.3927 6.79925L7.59814 41.1495C6.75833 42.9759 8.52712 44.8902 10.4125 44.1954L24.3757 39.0496C24.8829 38.8627 25.4385 38.8627 25.9422 39.0496L39.8121 44.1954C41.6849 44.8902 43.4884 42.9759 42.6817 41.1495Z"
						fill="black"
					/>
					<path
						d="M43.7146 40.6933L28.5431 6.34306C27.3556 3.65428 23.5772 3.69516 22.3668 6.32755L6.57226 40.6778C5.3134 43.4156 7.97238 46.298 10.803 45.2549L24.7662 40.109C25.0221 40.0147 25.2999 40.0156 25.5494 40.1082L39.4193 45.254C42.2261 46.2953 44.9254 43.4347 43.7146 40.6933Z"
						stroke="white"
						stroke-width={2.25825}
					/>
				</g>
				<defs>
					<filter
						id="filter0_d_91_7928"
						x={0.602397}
						y={0.952444}
						width={49.0584}
						height={52.428}
						filterUnits="userSpaceOnUse"
						color-interpolation-filters="sRGB"
					>
						<feFlood flood-opacity={0} result="BackgroundImageFix" />
						<feColorMatrix
							in="SourceAlpha"
							type="matrix"
							values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0"
							result="hardAlpha"
						/>
						<feOffset dy={2.25825} />
						<feGaussianBlur stdDeviation={2.25825} />
						<feComposite in2="hardAlpha" operator="out" />
						<feColorMatrix
							type="matrix"
							values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.08 0"
						/>
						<feBlend
							mode="normal"
							in2="BackgroundImageFix"
							result="effect1_dropShadow_91_7928"
						/>
						<feBlend
							mode="normal"
							in="SourceGraphic"
							in2="effect1_dropShadow_91_7928"
							result="shape"
						/>
					</filter>
				</defs>
			</svg>
		}
	</div>
	</>
}
