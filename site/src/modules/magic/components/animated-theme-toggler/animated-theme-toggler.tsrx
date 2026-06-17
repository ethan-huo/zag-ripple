import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';
import { LuMoon, LuSun } from '@/lib/lucide-icons.tsrx';

// The View Transition API clipPath animation must run entirely on the client —
// it touches document, window, and the ::view-transition-new(root) pseudo-element.
// Theme state is also read from the live DOM class list, so all setup lives in
// effect(). The button renders unconditionally on the server; isDark defaults to
// false (moon icon) to match the default light theme without a DOM read.
export function AnimatedThemeToggler({ class: className, duration = 400, ...rest }: any) @{
	const isDark = track(false);
	const buttonRef = track<HTMLButtonElement | null>(null);

	// Sync isDark with the actual <html> class list on mount, then watch for
	// programmatic theme changes (e.g. system-preference scripts).
	effect(() => {
		const update = () => {
			isDark.value = document.documentElement.classList.contains('dark');
		};
		update();

		const observer = new MutationObserver(update);
		observer.observe(document.documentElement, {
			attributes: true,
			attributeFilter: ['class'],
		});

		return () => observer.disconnect();
	});

	const toggleTheme = async () => {
		const btn = buttonRef.value;
		if (!btn) return;

		// Fallback path: browsers without the View Transition API skip the
		// radial-reveal animation and just toggle the class directly.
		if (!(document as any).startViewTransition) {
			const next = !isDark.value;
			isDark.value = next;
			document.documentElement.classList.toggle('dark');
			localStorage.setItem('theme', next ? 'dark' : 'light');
			return;
		}

		// The transition `.ready` promise resolves after the new view is captured
		// but before any CSS transition starts — the right moment to inject the
		// custom clipPath animation on the pseudo-element.
		await (document as any)
			.startViewTransition(() => {
				const next = !isDark.value;
				isDark.value = next;
				document.documentElement.classList.toggle('dark');
				localStorage.setItem('theme', next ? 'dark' : 'light');
			})
			.ready;

		const { top, left, width, height } = btn.getBoundingClientRect();
		const x = left + width / 2;
		const y = top + height / 2;
		const maxRadius = Math.hypot(
			Math.max(left, window.innerWidth - left),
			Math.max(top, window.innerHeight - top),
		);

		document.documentElement.animate(
			{
				clipPath: [
					`circle(0px at ${x}px ${y}px)`,
					`circle(${maxRadius}px at ${x}px ${y}px)`,
				],
			},
			{
				duration,
				easing: 'ease-in-out',
				pseudoElement: '::view-transition-new(root)',
			},
		);
	};

	<>
	<button
		ref={(el) => {
			buttonRef.value = el;
		}}
		onclick={toggleTheme}
		class={cn('inline-flex items-center justify-center', className)}
		{...rest}
	>
		@if (isDark.value) {
			<LuSun size={20} />
		} @else {
			<LuMoon size={20} />
		}
		<span class="sr-only">Toggle theme</span>
	</button>
	</>
}
