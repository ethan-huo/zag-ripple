import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// A custom cursor overlay that follows the pointer inside the parent element.
// An empty sentinel <div> anchors inside the user's container; the effect
// walks up to parentElement to attach listeners. The visible cursor is
// `position: fixed` so it escapes normal flow. AnimatePresence is approximated
// by animating scale/opacity in/out imperatively; position is a separate outer
// wrapper so reactive style updates don't stomp the imperative display toggle.
export function Pointer({ children, class: className }: any) @{
	let sentinel = track<HTMLDivElement | null>(null);
	let cursorEl = track<HTMLDivElement | null>(null);
	const x = track(0);
	const y = track(0);
	const isActive = track(false);

	effect(() => {
		const anchor = sentinel.value;
		if (!anchor) return;
		const parent = anchor.parentElement;
		if (!parent) return;

		const prev = parent.style.cursor;
		parent.style.cursor = 'none';

		const onMove = (e: MouseEvent) => {
			x.value = e.clientX;
			y.value = e.clientY;
			isActive.value = true;
		};
		const onEnter = (e: MouseEvent) => {
			x.value = e.clientX;
			y.value = e.clientY;
			isActive.value = true;
		};
		const onLeave = () => {
			isActive.value = false;
		};

		parent.addEventListener('mousemove', onMove);
		parent.addEventListener('mouseenter', onEnter);
		parent.addEventListener('mouseleave', onLeave);

		return () => {
			parent.style.cursor = prev;
			parent.removeEventListener('mousemove', onMove);
			parent.removeEventListener('mouseenter', onEnter);
			parent.removeEventListener('mouseleave', onLeave);
		};
	});

	// Animate enter/exit whenever isActive changes — approximates AnimatePresence.
	// Operates on the inner wrapper so the outer position div's reactive style
	// binding does not overwrite the imperative `display` on re-render.
	effect(() => {
		const el = cursorEl.value;
		if (!el) return;
		if (isActive.value) {
			el.style.display = 'block';
			animate(el, { scale: [0, 1], opacity: [0, 1] }, { duration: 0.15, ease: 'easeOut' });
		} else {
			animate(el, { scale: [1, 0], opacity: [1, 0] }, { duration: 0.12, ease: 'easeIn' }).then(
				() => {
					// Guard: user may have re-entered while exit was playing.
					if (!isActive.value) el.style.display = 'none';
				},
			);
		}
	});

	// Reactive position string for the outer wrapper only (no display here).
	const posStyle = track(
		() => `position: fixed; top: ${y.value}px; left: ${x.value}px; pointer-events: none; z-index: 9999; transform: translate(-50%, -50%);`,
	);

	<>
	{/* Sentinel inside the user's container — walks up to attach listeners */}
	<div ref={(el) => { sentinel.value = el; }} style="display:none" aria-hidden="true" />

	{/* Outer: moves with pointer reactively. Inner: owns display+scale via animate. */}
	<div style={posStyle.value}>
		<div
			ref={(el) => {
				if (el) el.style.display = 'none';
				cursorEl.value = el;
			}}
		>
			@if (children) {
				{children}
			} @else {
				<svg
					stroke="currentColor"
					fill="currentColor"
					stroke-width="1"
					viewBox="0 0 16 16"
					height="24"
					width="24"
					xmlns="http://www.w3.org/2000/svg"
					class={cn('rotate-[-70deg] stroke-white text-black', className)}
				>
					<path d="M14.082 2.182a.5.5 0 0 1 .103.557L8.528 15.467a.5.5 0 0 1-.917-.007L5.57 10.694.803 8.652a.5.5 0 0 1-.006-.916l12.728-5.657a.5.5 0 0 1 .556.103z" />
				</svg>
			}
		</div>
	</div>
	</>
}
