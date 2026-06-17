import { effect, track } from 'ripple';
import { useInView } from '@/lib/motion';
import { cn } from '@/lib/utils';

// Counts to `value` with a spring simulation when scrolled into view. The number
// is written straight to textContent each frame to avoid per-frame re-renders.
export function NumberTicker({
	value,
	startValue = 0,
	direction = 'up',
	delay = 0,
	decimalPlaces = 0,
	class: className,
	prefix = '',
	suffix = '',
	once = true,
}: any) @{
	let span = track<HTMLElement | null>(null);
	const view = useInView({ once, margin: '0px' });

	const damping = 60;
	const stiffness = 100;

	const fmt = (n: number) =>
		`${prefix}${Intl.NumberFormat('en-US', {
			minimumFractionDigits: decimalPlaces,
			maximumFractionDigits: decimalPlaces,
		}).format(Number(n.toFixed(decimalPlaces)))}${suffix}`;

	function animateValue(from: number, to: number) {
		const startTime = performance.now();
		const duration = 2000;
		let velocity = 0;
		let position = from;

		const step = (now: number) => {
			const elapsed = now - startTime;
			const dt = 16.67 / 1000;
			const springForce = -stiffness * (position - to);
			const dampingForce = -damping * velocity;
			velocity += (springForce + dampingForce) * dt;
			position += velocity * dt;
			if (span.value) span.value.textContent = fmt(position);
			const settled = Math.abs(velocity) < 0.01 && Math.abs(position - to) < 0.01;
			if (!settled && elapsed < duration * 2) {
				requestAnimationFrame(step);
			} else if (span.value) {
				span.value.textContent = fmt(to);
			}
		};

		requestAnimationFrame(step);
	}

	effect(() => {
		if (!view.visible.value) return;
		const timer = setTimeout(() => {
			animateValue(
				direction === 'down' ? value : startValue,
				direction === 'down' ? startValue : value,
			);
		}, delay);
		return () => clearTimeout(timer);
	});

	<>
	<span
		ref={(el) => {
			span.value = el;
			view.ref(el);
		}}
		class={cn('inline-block tracking-wider tabular-nums text-foreground', className)}
	>
		{fmt(direction === 'down' ? value : startValue)}
	</span>
	</>
}
