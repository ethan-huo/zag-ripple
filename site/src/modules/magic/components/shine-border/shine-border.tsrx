import { cn } from '@/lib/utils';

// The shine effect is pure CSS: a radial-gradient background animates its
// position via `background-size: 300% 300%` + a custom keyframe. The CSS mask
// pair (content-box XOR border-box) carves out the content area so only the
// border ring is visible — no JS needed at all.
export function ShineBorder({
	borderWidth = 1,
	duration = 14,
	shineColor = '#000000',
	class: className,
	style,
	...restProps
}: any) @{
	const shineColorValue = Array.isArray(shineColor) ? shineColor.join(',') : shineColor;

	const computedStyle =
		`--shine-border-width: ${borderWidth}px;` +
		`--shine-border-duration: ${duration}s;` +
		`background-image: radial-gradient(transparent,transparent,${shineColorValue},transparent,transparent);` +
		`background-size: 300% 300%;` +
		`mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);` +
		`-webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);` +
		`-webkit-mask-composite: xor;` +
		`mask-composite: exclude;` +
		`padding: var(--shine-border-width);` +
		(style ? ` ${style}` : '');

	<>
	<div
		class={cn(
			'magic-shine-border pointer-events-none absolute inset-0 size-full rounded-[inherit] will-change-[background-position]',
			className,
		)}
		style={computedStyle}
		{...restProps}
	/>

	<style>
		@keyframes magic-shine-border-spin {
			0%   { background-position: 0% 0%; }
			50%  { background-position: 100% 100%; }
			100% { background-position: 0% 0%; }
		}

		.magic-shine-border {
			animation: magic-shine-border-spin var(--shine-border-duration, 14s) linear infinite;
		}
	</style>
	</>
}
