import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Physics-based particle emitter that attaches to an <input> and spawns
// confetti-like particles at the text-cursor position on every keystroke.
// The overlay is position:fixed / pointer-events:none so it never disrupts layout.
// Svelte's typed snippet(item, idx) has no direct TSRX equivalent; we use
// `itemRenderer` as an explicit render-function prop instead.

interface Particle {
	id: number;
	x: number;
	y: number;
	scale: number;
	rotate: number;
	opacity: number;
	vx: number;
	vy: number;
	gravity: number;
	birthTime: number;
	lifeMs: number;
	contentIdx: number;
	scaleStart: number;
	scaleEnd: number;
	rotateStart: number;
	rotateEnd: number;
}

function clamp(value: number, min: number, max: number): number {
	return Math.min(max, Math.max(min, value));
}

function mapLinear(value: number, inMin: number, inMax: number, outMin: number, outMax: number): number {
	if (inMax === inMin) return outMin;
	const t = (value - inMin) / (inMax - inMin);
	return outMin + t * (outMax - outMin);
}

function createPRNG(seed: number): () => number {
	let s = seed;
	return () => {
		s |= 0;
		s = (s + 1831565813) | 0;
		let t = Math.imul(s ^ (s >>> 15), 1 | s);
		t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
		return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
	};
}

function toFiniteNumber(value: number, fallback: number): number {
	return Number.isFinite(value) ? value : fallback;
}

export function ExplodingInput({
	items = [],
	itemRenderer,
	count = 1,
	direction = { horizontal: 'center', vertical: 'top' },
	gravity = 0.7,
	duration = 3,
	scale = { value: 1, randomize: false, randomVariation: 0 },
	rotation = { value: 0, animate: false },
	target = null,
	class: className,
	style: styleAttribute,
	...restProps
}: any) @{
	const rootRef = track<HTMLDivElement | null>(null);
	const particles = track<Particle[]>([]);
	let particleIdCounter = 0;
	let rand: () => number = Math.random;
	let rafId: number | null = null;
	const particleTimeouts = new Map<number, ReturnType<typeof setTimeout>>();

	const rootStyle = track(() => {
		const parts: string[] = [];
		if (styleAttribute) parts.push(String(styleAttribute));
		parts.push('position: fixed', 'inset: 0', 'overflow: hidden', 'background-color: transparent', 'pointer-events: none');
		return parts.join('; ');
	});

	function getTextWidth(text: string, input: HTMLInputElement): number {
		const canvas = document.createElement('canvas');
		const ctx = canvas.getContext('2d');
		if (!ctx) return 0;
		const cs = window.getComputedStyle(input);
		ctx.font = cs.font || `${cs.fontStyle} ${cs.fontVariant} ${cs.fontWeight} ${cs.fontSize} / ${cs.lineHeight} ${cs.fontFamily}`;
		return ctx.measureText(text).width;
	}

	function getInputSpawnPosition(input: HTMLInputElement): { x: number; y: number } | null {
		const rect = input.getBoundingClientRect();
		const cs = window.getComputedStyle(input);
		const paddingLeft = Number.parseFloat(cs.paddingLeft) || 0;
		const paddingRight = Number.parseFloat(cs.paddingRight) || 0;
		const selectionEnd = input.selectionStart ?? input.value.length;
		const visibleValue = input.value.slice(0, selectionEnd);

		let x = rect.left + paddingLeft;
		if (visibleValue.length > 0) {
			const textWidth = getTextWidth(visibleValue, input);
			const maxX = rect.left + rect.width - paddingRight;
			x = Math.min(rect.left + paddingLeft + textWidth, maxX);
		}
		return { x, y: rect.top + rect.height / 2 };
	}

	function resolveTargetInput(): HTMLInputElement | null {
		if (target instanceof HTMLInputElement) return target;
		const root = rootRef.value;
		if (!root) return null;
		const label = root.closest('label');
		return label?.querySelector('input') ?? null;
	}

	function removeParticle(id: number) {
		const tid = particleTimeouts.get(id);
		if (tid !== undefined) {
			clearTimeout(tid);
			particleTimeouts.delete(id);
		}
		particles.value = particles.value.filter((p) => p.id !== id);
	}

	function spawnParticle(x: number, y: number) {
		const dir = { horizontal: 'center', vertical: 'top', ...direction };
		const sc = { value: 1, randomize: false, randomVariation: 0, ...scale };
		const rot = { value: 0, animate: false, ...rotation };

		const safeDuration = Math.max(0.01, toFiniteNumber(duration, 3));
		const safeGravity = clamp(toFiniteNumber(gravity, 0.7), -1, 1);

		const hv = dir.horizontal === 'left' ? -0.4 : dir.horizontal === 'right' ? 0.4 : 0;
		const vv = dir.vertical === 'top' ? -0.7 : dir.vertical === 'bottom' ? 0.7 : 0;

		const baseScale = sc.value;
		const variation = (sc.randomVariation / 100) * baseScale;
		const pScale = sc.randomize && sc.randomVariation > 0
			? (baseScale - variation) + rand() * 2 * variation
			: baseScale;
		const safeScale = clamp(pScale, 0.1, 4);

		let rotStart = rot.value;
		let rotEnd = rot.value;
		if (rot.animate) {
			rotStart = -180 + rand() * 360;
			rotEnd = rotStart + (-360 + rand() * 720);
		}

		particleIdCounter += 1;
		const p: Particle = {
			id: particleIdCounter,
			x, y,
			scale: safeScale,
			rotate: rotStart,
			opacity: 1,
			vx: mapLinear(hv, -1, 1, -800, 800) + (rand() * 2 - 1) * 300,
			vy: mapLinear(vv, -1, 1, -800, 800) + (rand() * 2 - 1) * 300,
			gravity: mapLinear(safeGravity, -1, 1, -2000, 2000),
			birthTime: performance.now(),
			lifeMs: safeDuration * 1000,
			contentIdx: items.length > 0 ? (particleIdCounter - 1) % items.length : -1,
			scaleStart: safeScale,
			scaleEnd: safeScale,
			rotateStart: rotStart,
			rotateEnd: rotEnd,
		};

		particles.value = [...particles.value, p];

		const tid = setTimeout(() => removeParticle(p.id), p.lifeMs);
		particleTimeouts.set(p.id, tid);
	}

	function createParticlesAtPosition(x: number, y: number) {
		const n = clamp(Math.round(toFiniteNumber(count, 1)), 1, 5);
		for (let i = 0; i < n; i += 1) spawnParticle(x, y);
	}

	// Input listener: spawn particles on every keystroke at the caret position.
	effect(() => {
		const input = resolveTargetInput();
		if (!input) return;

		const handleInput = () => {
			const pos = getInputSpawnPosition(input);
			if (pos) createParticlesAtPosition(pos.x, pos.y);
		};

		input.addEventListener('input', handleInput);
		return () => input.removeEventListener('input', handleInput);
	});

	// RAF physics loop: update particle positions, velocities, opacity each frame.
	// Seeded PRNG is initialized here so it's per-mount, not per-render.
	effect(() => {
		const timeBits = (Date.now() & 4294967295) >>> 0;
		const extra = Math.floor(Math.random() * 4294967295) >>> 0;
		rand = createPRNG((timeBits ^ extra) >>> 0);

		let lastTime = performance.now();

		const updateParticles = (currentTime: number) => {
			const dt = Math.min(32, currentTime - lastTime) / 1000;
			lastTime = currentTime;
			const now = performance.now();

			particles.value = particles.value
				.map((p) => {
					const age = now - p.birthTime;
					if (age >= p.lifeMs) return null;

					const progress = age / p.lifeMs;
					const nextVy = p.vy + p.gravity * dt;
					const nextX = p.x + p.vx * dt;
					const nextY = p.y + nextVy * dt;
					const nextScale = clamp(mapLinear(progress, 0, 1, p.scaleStart, p.scaleEnd), 0.1, 3);
					const nextRotate = mapLinear(progress, 0, 1, p.rotateStart, p.rotateEnd);
					const nextOpacity = progress > 0.7 ? mapLinear(progress, 0.7, 1, 1, 0) : 1;

					if (Number.isNaN(nextX) || Number.isNaN(nextY) || Number.isNaN(nextScale) || Number.isNaN(nextRotate)) return null;

					return { ...p, x: nextX, y: nextY, vy: nextVy, scale: nextScale, rotate: nextRotate, opacity: nextOpacity };
				})
				.filter((p): p is Particle => p !== null);

			rafId = requestAnimationFrame(updateParticles);
		};

		rafId = requestAnimationFrame(updateParticles);

		return () => {
			if (rafId !== null) {
				cancelAnimationFrame(rafId);
				rafId = null;
			}
			for (const tid of particleTimeouts.values()) clearTimeout(tid);
			particleTimeouts.clear();
			particles.value = [];
		};
	});

	<>
	<div
		ref={(el: HTMLDivElement) => { rootRef.value = el; }}
		data-slot="exploding-input"
		class={cn('spell-exploding-input', className)}
		style={rootStyle.value}
		aria-hidden="true"
		{...restProps}
	>
		@for (const particle of particles.value; key particle.id) {
			<div
				data-slot="exploding-input-particle"
				class="pointer-events-none absolute top-0 left-0 flex items-center justify-center will-change-transform"
				style={`transform: translate(${particle.x}px, ${particle.y}px) translate(-50%, -50%) scale(${particle.scale}) rotate(${particle.rotate}deg); opacity: ${particle.opacity}; transform-origin: 50% 50%;`}
			>
				@if (items.length > 0 && particle.contentIdx >= 0 && items[particle.contentIdx] !== undefined) {
					@if (itemRenderer) {
						{itemRenderer(items[particle.contentIdx], particle.contentIdx)}
					} @else {
						<span>{String(items[particle.contentIdx])}</span>
					}
				} @else {
					<div class="h-4 w-4 rounded-[6px] bg-[#6366f1]"></div>
				}
			</div>
		}
	</div>
	</>
}
