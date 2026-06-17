import { effect, track } from 'ripple';

// Renders children only after client mount. Under SSR the server (and the first
// hydration pass) render `fallback`, then the effect flips `mounted` and swaps in
// the real children — so it's safe to wrap interactive subtrees that touch
// browser APIs during render (Zag demos, the Streamdown playground).
export function ClientOnly({ children, fallback }: any) @{
	const mounted = track(false);
	effect(() => {
		mounted.value = true;
	});

	<>
	@if (mounted.value) {
		{children}
	} @else {
		@if (fallback) {
			{fallback}
		}
	}
	</>
}
