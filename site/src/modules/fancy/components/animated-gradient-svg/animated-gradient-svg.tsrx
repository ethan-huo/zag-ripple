import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Blob configs depend only on the `colors` prop — computed at render time (pure
// math, no DOM). `circleSize` needs the container's live dimensions, so it
// starts at a reasonable SSR default (400) and is updated client-side via a
// ResizeObserver inside an effect.

type BlurStrength = 'light' | 'medium' | 'heavy';

function hashString(value: string) {
	let hash = 2166136261;
	for (let i = 0; i < value.length; i += 1) {
		hash ^= value.charCodeAt(i);
		hash = Math.imul(hash, 16777619);
	}
	return hash >>> 0;
}

function createSeededRandom(seed: number) {
	return () => {
		seed += 0x6d2b79f5;
		let t = seed;
		t = Math.imul(t ^ (t >>> 15), t | 1);
		t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
		return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
	};
}

function randomBetween(random: () => number, min: number, max: number) {
	return min + (max - min) * random();
}

function buildBlobConfigs(colors: string[]) {
	return colors.map((color, index) => {
		const random = createSeededRandom(hashString(`${color}-${index}`));
		return {
			color,
			widthFactor: randomBetween(random, 0.5, 1.5),
			heightFactor: randomBetween(random, 0.5, 1.5),
			top: `${randomBetween(random, 0, 50)}%`,
			left: `${randomBetween(random, 0, 50)}%`,
			tx1: randomBetween(random, -0.5, 0.5),
			ty1: randomBetween(random, -0.5, 0.5),
			tx2: randomBetween(random, -0.5, 0.5),
			ty2: randomBetween(random, -0.5, 0.5),
			tx3: randomBetween(random, -0.5, 0.5),
			ty3: randomBetween(random, -0.5, 0.5),
			tx4: randomBetween(random, -0.5, 0.5),
			ty4: randomBetween(random, -0.5, 0.5),
		};
	});
}

export function AnimatedGradientSvg({
	colors,
	speed = 5,
	blur = 'light',
	class: className,
	...props
}: any) @{
	// Derived purely from props — safe to compute at render / on the server.
	const blobConfigs = track(() => buildBlobConfigs(colors as string[]));
	const blurClass = track(() =>
		blur === 'light' ? 'blur-2xl' : blur === 'medium' ? 'blur-3xl' : 'blur-[100px]',
	);

	// Start at a reasonable SSR default so the SVGs aren't zero-sized on first paint.
	const circleSize = track(400);
	const containerRef = track<HTMLElement | null>(null);

	// ResizeObserver runs client-only; `effect` is never called during SSR.
	effect(() => {
		const el = containerRef.value;
		if (!el) return;

		const update = () => {
			const { width, height } = el.getBoundingClientRect();
			circleSize.value = Math.max(width, height) || 400;
		};

		const ro = new ResizeObserver(update);
		ro.observe(el);
		update();
		return () => ro.disconnect();
	});

	<>
	<div
		ref={(el: HTMLElement | null) => { containerRef.value = el; }}
		class={cn('absolute inset-0 overflow-hidden', className)}
		{...props}
	>
		<div class={cn('absolute inset-0', blurClass.value)}>
			@for (const blob of blobConfigs.value; index i) {
				<svg
					class="absolute"
					width={circleSize.value * blob.widthFactor}
					height={circleSize.value * blob.heightFactor}
					viewBox="0 0 100 100"
					style={[
						`top: ${blob.top}`,
						`left: ${blob.left}`,
						`animation: ags-blob-move ${speed}s infinite ease-in-out`,
						`--tx-1: ${blob.tx1}`,
						`--ty-1: ${blob.ty1}`,
						`--tx-2: ${blob.tx2}`,
						`--ty-2: ${blob.ty2}`,
						`--tx-3: ${blob.tx3}`,
						`--ty-3: ${blob.ty3}`,
						`--tx-4: ${blob.tx4}`,
						`--ty-4: ${blob.ty4}`,
					].join('; ')}
					aria-hidden="true"
				>
					<circle cx="50" cy="50" r="50" fill={blob.color} />
				</svg>
			}
		</div>
	</div>

	<style>
		@keyframes ags-blob-move {
			0%, 100% { transform: translate(0, 0); }
			20%  { transform: translate(calc(100% * var(--tx-1, 1)),  calc(100% * var(--ty-1, 1))); }
			40%  { transform: translate(calc(100% * var(--tx-2, -1)), calc(100% * var(--ty-2, 1))); }
			60%  { transform: translate(calc(100% * var(--tx-3, 1)),  calc(100% * var(--ty-3, -1))); }
			80%  { transform: translate(calc(100% * var(--tx-4, -1)), calc(100% * var(--ty-4, -1))); }
		}
	</style>
	</>
}
