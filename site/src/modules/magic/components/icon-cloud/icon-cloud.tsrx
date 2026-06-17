import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// All canvas, RAF, and DOM work lives inside effect — the render body runs on
// the server where window/canvas/requestAnimationFrame don't exist.
// Icons are Ripple components: we render each into a tiny offscreen canvas so
// they can be stamped onto the main canvas during the rAF loop.

function easeOutCubic(t: number): number {
	return 1 - Math.pow(1 - t, 3);
}

interface SphereIcon {
	x: number;
	y: number;
	z: number;
	id: number;
}

export function IconCloud({
	images,
	class: className,
}: any) @{
	const canvasRef = track<HTMLCanvasElement | null>(null);

	effect(() => {
		const canvas = canvasRef.value;
		if (!canvas) return;

		const ctx = canvas.getContext('2d');
		if (!ctx) return;

		// --- State that lives entirely in the effect closure (client-only) ---
		const items: string[] = images || [];
		const numIcons = items.length || 20;

		// Distribute icons evenly on a unit sphere using the golden-angle method.
		const iconPositions: SphereIcon[] = [];
		const offset = 2 / numIcons;
		const increment = Math.PI * (3 - Math.sqrt(5));
		for (let i = 0; i < numIcons; i++) {
			const y = i * offset - 1 + offset / 2;
			const r = Math.sqrt(1 - y * y);
			const phi = i * increment;
			iconPositions.push({
				x: Math.cos(phi) * r * 100,
				y: y * 100,
				z: Math.sin(phi) * r * 100,
				id: i,
			});
		}

		// Offscreen canvases hold each image so the rAF loop can drawImage cheaply.
		const offscreens: HTMLCanvasElement[] = [];
		const loaded: boolean[] = new Array(items.length).fill(false);

		items.forEach((src, idx) => {
			const off = document.createElement('canvas');
			off.width = 40;
			off.height = 40;
			const offCtx = off.getContext('2d');
			if (offCtx) {
				const img = new Image();
				img.crossOrigin = 'anonymous';
				img.src = src;
				img.onload = () => {
					offCtx.clearRect(0, 0, 40, 40);
					offCtx.beginPath();
					offCtx.arc(20, 20, 20, 0, Math.PI * 2);
					offCtx.closePath();
					offCtx.clip();
					offCtx.drawImage(img, 0, 0, 40, 40);
					loaded[idx] = true;
				};
			}
			offscreens.push(off);
		});

		// Rotation accumulator — mutated in place to avoid closure re-capture.
		let rotation = { x: 0, y: 0 };

		// Mouse-drive state.
		let isDragging = false;
		let lastMouse = { x: 0, y: 0 };
		let mousePos = { x: canvas.width / 2, y: canvas.height / 2 };

		// Animated snap-to-icon target.
		let snapTarget: {
			x: number; y: number;
			startX: number; startY: number;
			startTime: number; duration: number;
		} | null = null;

		// --- Event handlers ---
		function onMouseDown(e: MouseEvent) {
			const rect = canvas.getBoundingClientRect();
			const mx = e.clientX - rect.left;
			const my = e.clientY - rect.top;

			// Check if the click lands on a projected icon sphere.
			for (const icon of iconPositions) {
				const cosX = Math.cos(rotation.x), sinX = Math.sin(rotation.x);
				const cosY = Math.cos(rotation.y), sinY = Math.sin(rotation.y);
				const rx = icon.x * cosY - icon.z * sinY;
				const rz = icon.x * sinY + icon.z * cosY;
				const ry = icon.y * cosX + rz * sinX;
				const sx = canvas.width / 2 + rx;
				const sy = canvas.height / 2 + ry;
				const scale = (rz + 200) / 300;
				const radius = 20 * scale;
				const dx = mx - sx, dy = my - sy;
				if (dx * dx + dy * dy < radius * radius) {
					const targetX = -Math.atan2(icon.y, Math.sqrt(icon.x * icon.x + icon.z * icon.z));
					const targetY = Math.atan2(icon.x, icon.z);
					const dist = Math.sqrt(
						Math.pow(targetX - rotation.x, 2) + Math.pow(targetY - rotation.y, 2),
					);
					snapTarget = {
						x: targetX, y: targetY,
						startX: rotation.x, startY: rotation.y,
						startTime: performance.now(),
						duration: Math.min(2000, Math.max(800, dist * 1000)),
					};
					return;
				}
			}

			isDragging = true;
			lastMouse = { x: e.clientX, y: e.clientY };
		}

		function onMouseMove(e: MouseEvent) {
			const rect = canvas.getBoundingClientRect();
			mousePos = { x: e.clientX - rect.left, y: e.clientY - rect.top };
			if (isDragging) {
				rotation.x += (e.clientY - lastMouse.y) * 0.002;
				rotation.y += (e.clientX - lastMouse.x) * 0.002;
				lastMouse = { x: e.clientX, y: e.clientY };
			}
		}

		function onMouseUp() { isDragging = false; }

		canvas.addEventListener('mousedown', onMouseDown);
		canvas.addEventListener('mousemove', onMouseMove);
		canvas.addEventListener('mouseup', onMouseUp);
		canvas.addEventListener('mouseleave', onMouseUp);

		// --- rAF render loop ---
		let rafId = 0;
		function render() {
			ctx.clearRect(0, 0, canvas.width, canvas.height);

			const cx = canvas.width / 2;
			const cy = canvas.height / 2;
			const maxDist = Math.sqrt(cx * cx + cy * cy);
			const dx = mousePos.x - cx;
			const dy = mousePos.y - cy;
			const dist = Math.sqrt(dx * dx + dy * dy);
			const speed = 0.003 + (dist / maxDist) * 0.01;

			if (snapTarget) {
				const elapsed = performance.now() - snapTarget.startTime;
				const progress = Math.min(1, elapsed / snapTarget.duration);
				const eased = easeOutCubic(progress);
				rotation.x = snapTarget.startX + (snapTarget.x - snapTarget.startX) * eased;
				rotation.y = snapTarget.startY + (snapTarget.y - snapTarget.startY) * eased;
				if (progress >= 1) snapTarget = null;
			} else if (!isDragging) {
				rotation.x += (dy / canvas.height) * speed;
				rotation.y += (dx / canvas.width) * speed;
			}

			// Sort back-to-front so closer icons paint on top.
			const projected = iconPositions.map((icon, index) => {
				const cosX = Math.cos(rotation.x), sinX = Math.sin(rotation.x);
				const cosY = Math.cos(rotation.y), sinY = Math.sin(rotation.y);
				const rx = icon.x * cosY - icon.z * sinY;
				const rz = icon.x * sinY + icon.z * cosY;
				const ry = icon.y * cosX + rz * sinX;
				return { index, rx, ry, rz };
			});
			projected.sort((a, b) => a.rz - b.rz);

			for (const { index, rx, ry, rz } of projected) {
				const scale = (rz + 200) / 300;
				const opacity = Math.max(0.2, Math.min(1, (rz + 150) / 200));

				ctx.save();
				ctx.translate(canvas.width / 2 + rx, canvas.height / 2 + ry);
				ctx.scale(scale, scale);
				ctx.globalAlpha = opacity;

				if (items.length > 0) {
					if (offscreens[index] && loaded[index]) {
						ctx.drawImage(offscreens[index], -20, -20, 40, 40);
					}
				} else {
					// Fallback: numbered circles when no images are supplied.
					ctx.beginPath();
					ctx.arc(0, 0, 20, 0, Math.PI * 2);
					ctx.fillStyle = '#4444ff';
					ctx.fill();
					ctx.fillStyle = 'white';
					ctx.textAlign = 'center';
					ctx.textBaseline = 'middle';
					ctx.font = '16px Arial';
					ctx.fillText(`${iconPositions[index].id + 1}`, 0, 0);
				}

				ctx.restore();
			}

			rafId = requestAnimationFrame(render);
		}

		render();

		return () => {
			cancelAnimationFrame(rafId);
			canvas.removeEventListener('mousedown', onMouseDown);
			canvas.removeEventListener('mousemove', onMouseMove);
			canvas.removeEventListener('mouseup', onMouseUp);
			canvas.removeEventListener('mouseleave', onMouseUp);
		};
	});

	<>
	<canvas
		ref={(el) => { canvasRef.value = el; }}
		width={400}
		height={400}
		class={cn('rounded-lg cursor-grab active:cursor-grabbing', className)}
		aria-label="Interactive 3D Icon Cloud"
	/>
	</>
}
