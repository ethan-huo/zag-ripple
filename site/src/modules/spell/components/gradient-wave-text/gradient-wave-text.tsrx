import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// A gradient that sweeps upward through the text by animating a `--gi` custom
// property on a requestAnimationFrame loop; the gradient stops are expressed in
// `calc((var(--gi) + offset) * 1%)` so CSS does the painting.
const defaultColors = ['#8d6869', '#5a8ea6', '#b9c96e', '#c7c571', '#cb706f', '#7e5e5f'];

export function GradientWaveText({
	children,
	align = 'center',
	class: className,
	speed = 1,
	paused = false,
	delay = 0,
	repeat = false,
	triggerOnView = false,
	once = true,
	radial = true,
	bottomOffset = 20,
	bandGap = 4,
	bandCount = 8,
	customColors,
	ariaLabel,
	style,
	role,
	...props
}: any) @{
	let node = track<HTMLElement | null>(null);
	let inView = track(!triggerOnView);

	// Plain (non-reactive) loop state — mirrors the upstream `let` bindings.
	let gradientIndex = -25;
	let rafId = 0;
	let cyclesDone = 0;
	let finished = false;
	let started = false;
	let startAt = 0;

	const cycles = track(() => (repeat ? 0 : 1));
	const resolvedColors = track(() => (customColors?.length ? customColors : defaultColors));
	const isInView = track(() => (triggerOnView ? inView.value : true));
	const justifyContent = track(() =>
		align === 'left' ? 'flex-start' : align === 'right' ? 'flex-end' : 'center',
	);

	const stops = track(() => {
		const parts: string[] = [];
		const baseColor = 'var(--gradient-wave-base, rgb(29,29,31))';
		parts.push(`${baseColor} calc((var(--gi) + 0) * 1%)`);
		const colors = resolvedColors.value;
		for (let index = 0; index < bandCount && index < colors.length * 2; index += 1) {
			const color = colors[index % colors.length];
			const offset = (index + 2) * bandGap;
			parts.push(`${color} calc((var(--gi) + ${offset}) * 1%)`);
		}
		const endOffset = (bandCount + 2) * bandGap;
		parts.push(`${baseColor} calc((var(--gi) + ${endOffset}) * 1%)`);
		return parts.join(', ');
	});

	const gradient = track(() =>
		radial
			? `radial-gradient(circle at 50% bottom, ${stops.value})`
			: `linear-gradient(0deg, ${stops.value})`,
	);

	const rootStyle = track(() =>
		[`justify-content: ${justifyContent.value}`, '--gi: -25', style].filter(Boolean).join('; '),
	);

	const textStyle = track(() =>
		[
			`text-align: ${align}`,
			`background-image: ${gradient.value}`,
			'-webkit-background-clip: text',
			'background-clip: text',
			'-webkit-text-fill-color: transparent',
			'color: transparent',
			'white-space: pre-wrap',
			'word-break: break-word',
			'display: inline-block',
			'-webkit-font-smoothing: antialiased',
			'-moz-osx-font-smoothing: grayscale',
			'transform: translateZ(0)',
			`padding-bottom: ${bottomOffset}%`,
			`margin-bottom: -${bottomOffset}%`,
			'padding-inline: 2px',
		].join('; '),
	);

	function setGradientIndex(value: number) {
		gradientIndex = value;
		node.value?.style.setProperty('--gi', String(value));
	}

	// Viewport gate (only when triggerOnView).
	effect(() => {
		const el = node.value;
		if (!el || !triggerOnView) return;
		const observer = new IntersectionObserver(
			([entry]) => {
				if (!entry) return;
				if (entry.isIntersecting) inView.value = true;
				else if (!once) inView.value = false;
			},
			{ threshold: 0.1 },
		);
		observer.observe(el);
		return () => observer.disconnect();
	});

	// Reset the sweep whenever it (re)enters view.
	effect(() => {
		const el = node.value;
		if (!el || !isInView.value) return;
		gradientIndex = -25;
		cyclesDone = 0;
		finished = false;
		started = false;
		startAt = performance.now() + Math.max(0, delay * 1000);
		setGradientIndex(-25);
	});

	// The animation loop.
	effect(() => {
		const el = node.value;
		if (!el || !isInView.value) return;
		const range = 200;
		let last = performance.now();

		const tick = (now: number) => {
			if (finished) return;
			if (!started) {
				if (now >= startAt) {
					started = true;
					last = now;
				} else {
					rafId = requestAnimationFrame(tick);
					return;
				}
			}
			const delta = Math.min(64, now - last);
			last = now;
			if (!paused) {
				const increment = (delta * speed) / 16.6667;
				let next = gradientIndex + increment;
				if (cycles.value === 0) {
					if (next >= range) next %= range;
					setGradientIndex(next);
				} else {
					while (next >= range && cyclesDone < cycles.value) {
						next -= range;
						cyclesDone += 1;
					}
					if (cyclesDone >= cycles.value) {
						setGradientIndex(range);
						finished = true;
						return;
					}
					setGradientIndex(next);
				}
			}
			rafId = requestAnimationFrame(tick);
		};

		rafId = requestAnimationFrame(tick);
		return () => cancelAnimationFrame(rafId);
	});

	<>
	<div
		ref={(el) => {
			node.value = el;
		}}
		class={cn(
			'flex h-full w-full items-center [--gradient-wave-base:rgb(29,29,31)] dark:[--gradient-wave-base:rgb(255,255,255)]',
			className,
		)}
		style={rootStyle.value}
		aria-label={ariaLabel}
		role={role ?? (ariaLabel ? 'img' : undefined)}
		{...props}
	>
		<span style={textStyle.value}>{children}</span>
	</div>
	</>
}
