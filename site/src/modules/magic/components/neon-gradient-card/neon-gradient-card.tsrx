import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// CSS custom properties drive all sizing math. Because Tailwind cannot emit
// `blur-[var(--ngc-after-blur)]` (filter conflicts) and pseudo-element
// keyframe timing is component-local, we use a scoped <style> block for the
// before/after pseudo-elements and only set CSS custom props via inline style.
// ResizeObserver/window.resize live inside effect (client-only / SSR-safe).
export function NeonGradientCard({
	class: className,
	children,
	borderSize = 2,
	borderRadius = 20,
	neonColors = { firstColor: '#ff00aa', secondColor: '#00FFF1' },
	...props
}: any) @{
	let containerRef = track<HTMLDivElement | null>(null);
	let width = track(0);
	let height = track(0);

	effect(() => {
		const el = containerRef.value;
		if (!el) return;

		const update = () => {
			width.value = el.offsetWidth;
			height.value = el.offsetHeight;
		};

		update();
		window.addEventListener('resize', update);
		return () => window.removeEventListener('resize', update);
	});

	// Derived inline style — all sizing math expressed as CSS custom props so the
	// scoped pseudo-element rules (below) can reference them without JS.
	const containerStyle = track(() => {
		const w = width.value;
		const h = height.value;
		return [
			`--ngc-border-size: ${borderSize}px`,
			`--ngc-border-radius: ${borderRadius}px`,
			`--ngc-content-radius: ${borderRadius - borderSize}px`,
			`--ngc-first-color: ${neonColors.firstColor}`,
			`--ngc-second-color: ${neonColors.secondColor}`,
			`--ngc-pseudo-width: ${w > 0 ? w + borderSize * 2 : 100}px`,
			`--ngc-pseudo-height: ${h > 0 ? h + borderSize * 2 : 100}px`,
			`--ngc-blur: ${w > 0 ? Math.round(w / 3) : 0}px`,
		].join('; ');
	});

	<>
	<div
		ref={(el) => { containerRef.value = el; }}
		style={containerStyle.value}
		class={cn('ngc-root relative z-10 size-full', className)}
		{...props}
	>
		<div class="ngc-inner relative size-full min-h-[inherit] bg-gray-100 p-6 dark:bg-neutral-900 break-words">
			{children}
		</div>
	</div>

	<style>
		@keyframes ngc-bg-spin {
			0%   { background-position: 0% 0%; }
			100% { background-position: 0% 200%; }
		}

		.ngc-root {
			border-radius: var(--ngc-border-radius);
		}

		.ngc-inner {
			border-radius: var(--ngc-content-radius);
		}

		/* Spinning neon gradient border via ::before */
		.ngc-inner::before {
			content: '';
			position: absolute;
			top: calc(-1 * var(--ngc-border-size));
			left: calc(-1 * var(--ngc-border-size));
			width: var(--ngc-pseudo-width);
			height: var(--ngc-pseudo-height);
			border-radius: var(--ngc-border-radius);
			z-index: -10;
			background-image: linear-gradient(0deg, var(--ngc-first-color), var(--ngc-second-color));
			background-size: 100% 200%;
			animation: ngc-bg-spin 3s linear infinite;
		}

		/* Blurred glow layer — identical position/size, rendered below ::before */
		.ngc-inner::after {
			content: '';
			position: absolute;
			top: calc(-1 * var(--ngc-border-size));
			left: calc(-1 * var(--ngc-border-size));
			width: var(--ngc-pseudo-width);
			height: var(--ngc-pseudo-height);
			border-radius: var(--ngc-border-radius);
			z-index: -10;
			background-image: linear-gradient(0deg, var(--ngc-first-color), var(--ngc-second-color));
			background-size: 100% 200%;
			animation: ngc-bg-spin 3s linear infinite;
			filter: blur(var(--ngc-blur, 0px));
			opacity: 0.8;
		}
	</style>
	</>
}
