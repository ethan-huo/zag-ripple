import { effect, track } from 'ripple';

// Wraps children in a <span> and spawns colorful particles while the user
// presses/drags over it. All DOM work lives inside effect() — the render body
// emits only a static <span> wrapper so SSR is safe.

// Module-level counter mirrors the original — tracks how many CoolMode
// instances share the singleton overlay so we remove it only when the last
// one unmounts.
let instanceCounter = 0;

interface CoolParticle {
	element: HTMLElement;
	left: number;
	top: number;
	size: number;
	direction: number;
	speedHorz: number;
	speedUp: number;
	spinSpeed: number;
	spinVal: number;
}

export interface CoolParticleOptions {
	particle?: string;   // 'circle' (default) | emoji/text | image URL
	size?: number;       // fixed size, otherwise random from [15,20,25,35,45]
	particleCount?: number; // not used directly; limit is 45
	speedHorz?: number;
	speedUp?: number;
}

export function CoolMode({
	children,
	options,
}: any) @{
	let spanRef = track<HTMLSpanElement | null>(null);

	effect(() => {
		const el = spanRef.value;
		if (!el) return;

		// --- shared overlay container (singleton per page) ---
		const containerId = '_coolMode_effect';
		const getContainer = (): HTMLElement => {
			const existing = document.getElementById(containerId);
			if (existing) return existing;
			const div = document.createElement('div');
			div.id = containerId;
			div.setAttribute(
				'style',
				'overflow:hidden;position:fixed;height:100%;top:0;left:0;right:0;bottom:0;pointer-events:none;z-index:2147483647',
			);
			document.body.appendChild(div);
			return div;
		};

		const container = getContainer();
		instanceCounter++;

		// --- particle config ---
		const particleType: string = options?.particle ?? 'circle';
		const SIZES = [15, 20, 25, 35, 45];
		const LIMIT = 45;
		const GENERATION_DELAY_MS = 30;

		let particles: CoolParticle[] = [];
		let autoAdd = false;
		let mouseX = 0;
		let mouseY = 0;
		let lastGenTs = 0;
		let rafId: number | undefined;

		function generateParticle() {
			const size: number = options?.size ?? SIZES[Math.floor(Math.random() * SIZES.length)];
			const speedHorz: number = options?.speedHorz ?? Math.random() * 10;
			const speedUp: number = options?.speedUp ?? Math.random() * 25;
			const spinVal = Math.random() * 360;
			const spinSpeed = Math.random() * 35 * (Math.random() <= 0.5 ? -1 : 1);
			const direction = Math.random() <= 0.5 ? -1 : 1;
			const top = mouseY - size / 2;
			const left = mouseX - size / 2;

			const wrapper = document.createElement('div');

			if (particleType === 'circle') {
				const svgNS = 'http://www.w3.org/2000/svg';
				const svg = document.createElementNS(svgNS, 'svg');
				const circle = document.createElementNS(svgNS, 'circle');
				circle.setAttributeNS(null, 'cx', String(size / 2));
				circle.setAttributeNS(null, 'cy', String(size / 2));
				circle.setAttributeNS(null, 'r', String(size / 2));
				circle.setAttributeNS(null, 'fill', `hsl(${Math.random() * 360},70%,50%)`);
				svg.appendChild(circle);
				svg.setAttribute('width', String(size));
				svg.setAttribute('height', String(size));
				wrapper.appendChild(svg);
			} else if (particleType.startsWith('http') || particleType.startsWith('/')) {
				wrapper.innerHTML = `<img src="${particleType}" width="${size}" height="${size}" style="border-radius:50%">`;
			} else {
				// emoji / text: scale it up 3× for visual pop
				wrapper.innerHTML = `<div style="font-size:${size * 3}px;line-height:1;width:${size}px;height:${size}px;display:flex;align-items:center;justify-content:center;transform:scale(3);transform-origin:center;">${particleType}</div>`;
			}

			wrapper.style.position = 'absolute';
			wrapper.style.transform = `translate3d(${left}px,${top}px,0) rotate(${spinVal}deg)`;
			container.appendChild(wrapper);

			particles.push({ element: wrapper, left, top, size, direction, speedHorz, speedUp, spinSpeed, spinVal });
		}

		function tick(now: number) {
			if (autoAdd && particles.length < LIMIT && now - lastGenTs > GENERATION_DELAY_MS) {
				generateParticle();
				lastGenTs = now;
			}

			const viewH = Math.max(window.innerHeight, document.body.clientHeight);

			particles = particles.filter((p) => {
				p.left -= p.speedHorz * p.direction;
				p.top -= p.speedUp;
				p.speedUp = Math.min(p.size, p.speedUp - 1);
				p.spinVal += p.spinSpeed;

				if (p.top >= viewH + p.size) {
					p.element.remove();
					return false;
				}

				p.element.setAttribute(
					'style',
					`position:absolute;will-change:transform;top:${p.top}px;left:${p.left}px;transform:rotate(${p.spinVal}deg)`,
				);
				return true;
			});

			rafId = requestAnimationFrame(tick);
		}

		rafId = requestAnimationFrame(tick);

		// --- event wiring (touch + mouse) ---
		const isTouch = 'ontouchstart' in window;
		const evMove = isTouch ? 'touchmove' : 'mousemove';
		const evTap = isTouch ? 'touchstart' : 'mousedown';
		const evTapEnd = isTouch ? 'touchend' : 'mouseup';

		const onMove = (e: Event) => {
			const ev = e as MouseEvent | TouchEvent;
			if ('touches' in ev) {
				mouseX = ev.touches[0].clientX;
				mouseY = ev.touches[0].clientY;
			} else {
				mouseX = (ev as MouseEvent).clientX;
				mouseY = (ev as MouseEvent).clientY;
			}
		};
		const onTap = (e: Event) => { onMove(e); autoAdd = true; };
		const onRelease = () => { autoAdd = false; };

		el.addEventListener(evMove, onMove, { passive: true });
		el.addEventListener(evTap, onTap, { passive: true });
		el.addEventListener(evTapEnd, onRelease, { passive: true });
		el.addEventListener('mouseleave', onRelease, { passive: true });

		return () => {
			el.removeEventListener(evMove, onMove);
			el.removeEventListener(evTap, onTap);
			el.removeEventListener(evTapEnd, onRelease);
			el.removeEventListener('mouseleave', onRelease);

			// drain remaining particles, then tear down the shared overlay only
			// when we're the last live CoolMode instance.
			const drain = setInterval(() => {
				if (particles.length === 0) {
					if (rafId !== undefined) cancelAnimationFrame(rafId);
					clearInterval(drain);
					if (--instanceCounter === 0) container.remove();
				}
			}, 500);
		};
	});

	<>
	<span ref={(el) => { spanRef.value = el; }}>
		{children}
	</span>
	</>
}
