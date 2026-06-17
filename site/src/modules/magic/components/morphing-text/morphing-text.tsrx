import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// The liquid morph effect is achieved by two stacked <span>s cross-fading with
// blur. An SVG feColorMatrix filter (threshold) clamps the blended alpha,
// making separate glyphs appear to merge. The SVG must live in the DOM with
// a stable id for `filter: url(#threshold)` to resolve — it is rendered
// inside this component as `fixed h-0 w-0` so it takes no layout space.
// All RAF logic runs inside effect() — never at render / module top-level.

const MORPH_TIME = 1.5;
const COOLDOWN_TIME = 0.5;

export function MorphingText({ texts, class: className }: any) @{
	const text1Node = track<HTMLSpanElement | null>(null);
	const text2Node = track<HTMLSpanElement | null>(null);

	effect(() => {
		const t1 = text1Node.value;
		const t2 = text2Node.value;
		if (!t1 || !t2 || !texts || texts.length === 0) return;

		let textIndex = 0;
		let morph = 0;
		// Start with cooldown=0 so morphing begins immediately on mount,
		// matching the Svelte source ($state(0) for both morph and cooldown).
		let cooldown = 0;
		let lastTime = Date.now();
		let rafId: number;

		const setStyles = (fraction: number) => {
			// fraction 0 = fully text[textIndex], fraction 1 = fully text[textIndex+1]
			t2.style.filter = `blur(${Math.min(8 / fraction - 8, 100)}px)`;
			t2.style.opacity = `${Math.pow(fraction, 0.4) * 100}%`;

			const inv = 1 - fraction;
			t1.style.filter = `blur(${Math.min(8 / inv - 8, 100)}px)`;
			t1.style.opacity = `${Math.pow(inv, 0.4) * 100}%`;

			t1.textContent = texts[textIndex % texts.length];
			t2.textContent = texts[(textIndex + 1) % texts.length];
		};

		const doMorph = () => {
			morph -= cooldown;
			cooldown = 0;

			let fraction = morph / MORPH_TIME;
			if (fraction > 1) {
				cooldown = COOLDOWN_TIME;
				fraction = 1;
			}

			setStyles(fraction);

			if (fraction === 1) {
				textIndex = (textIndex + 1) % texts.length;
			}
		};

		const doCooldown = () => {
			morph = 0;
			t2.style.filter = 'none';
			t2.style.opacity = '100%';
			t1.style.filter = 'none';
			t1.style.opacity = '0%';
		};

		// Seed initial text so spans aren't empty on first frame
		t1.textContent = texts[0];
		t2.textContent = texts[1 % texts.length];

		const frame = () => {
			rafId = requestAnimationFrame(frame);
			const now = Date.now();
			const dt = (now - lastTime) / 1000;
			lastTime = now;

			cooldown -= dt;

			if (cooldown <= 0) {
				doMorph();
			} else {
				doCooldown();
			}
		};

		rafId = requestAnimationFrame(frame);
		return () => cancelAnimationFrame(rafId);
	});

	<>
	<div
		class={cn(
			'relative mx-auto h-16 w-full max-w-3xl text-center font-sans text-[40pt] font-bold leading-none [filter:url(#morphing-text-threshold)_blur(0.6px)] md:h-24 lg:text-[6rem]',
			className,
		)}
	>
		<span
			class="absolute inset-x-0 top-0 m-auto inline-block w-full"
			ref={(el) => { text1Node.value = el; }}
		/>
		<span
			class="absolute inset-x-0 top-0 m-auto inline-block w-full"
			ref={(el) => { text2Node.value = el; }}
		/>

		{/* SVG filter must be in the DOM for `filter: url(#...)` to resolve.
		    Fixed + zero-size so it contributes no layout. A stable id is used
		    to avoid conflicts when multiple instances are on the same page. */}
		<svg
			id="morphing-text-filters"
			class="fixed h-0 w-0"
			aria-hidden="true"
			preserveAspectRatio="xMidYMid slice"
		>
			<defs>
				<filter id="morphing-text-threshold">
					<feColorMatrix
						in="SourceGraphic"
						type="matrix"
						values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 255 -140"
					/>
				</filter>
			</defs>
		</svg>
	</div>
	</>
}
