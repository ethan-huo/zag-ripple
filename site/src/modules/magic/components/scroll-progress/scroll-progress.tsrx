import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Scroll progress bar: `scaleX` maps page scroll fraction to bar width.
// Computed inside an effect (window/document are browser-only).
// `transform-origin: left` ensures the bar grows from the left edge.
export function ScrollProgress({ class: className }: any) @{
	let scaleX = track(0);

	effect(() => {
		function onScroll() {
			const scrollTop = window.scrollY;
			const docHeight = document.documentElement.scrollHeight - window.innerHeight;
			// Guard against zero-height pages (e.g. during SSR hydration flush).
			scaleX.value = docHeight > 0 ? scrollTop / docHeight : 0;
		}

		window.addEventListener('scroll', onScroll, { passive: true });
		// Initialise immediately in case the page is already scrolled on mount.
		onScroll();

		return () => window.removeEventListener('scroll', onScroll);
	});

	<>
	<div
		class={cn(
			'fixed inset-x-0 top-0 z-50 h-1 origin-left bg-linear-to-r from-[#A97CF8] via-[#F38CB8] to-[#FDCC92]',
			className,
		)}
		style={`transform: scaleX(${scaleX.value})`}
	/>
	</>
}
