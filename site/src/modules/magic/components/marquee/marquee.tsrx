import { cn } from '@/lib/utils';

// Magic UI marquee: renders `repeat` identical copies of children in a row/column,
// each copy continuously scrolling. Unlike spell/marquee's two-segment seamless
// trick, this approach lets the gap and individual items be visible between loops —
// matching the original magicui.design layout contract.
export function Marquee({
	children,
	class: className,
	reverse = false,
	pauseOnHover = false,
	vertical = false,
	repeat = 4,
	duration = 40,
	gap = '1rem',
	...rest
}: any) @{
	const durationVar = `${duration}s`;

	<>
	<div
		{...rest}
		class={cn(
			'magic-marquee group flex overflow-hidden p-2',
			vertical ? 'flex-col' : 'flex-row',
			className,
		)}
		style={`--magic-marquee-duration: ${durationVar}; --magic-marquee-gap: ${gap};`}
	>
		@for (const _item of Array.from({ length: repeat }); index i) {
			<div
				class={cn(
					'magic-marquee__strip flex shrink-0 justify-around',
					vertical
						? 'magic-marquee__strip--vertical flex-col'
						: 'magic-marquee__strip--horizontal flex-row',
					reverse && 'magic-marquee__strip--reverse',
					pauseOnHover && 'magic-marquee__strip--pause-on-hover',
				)}
			>
				{children}
			</div>
		}
	</div>

	<style>
		@keyframes magic-marquee-x {
			from { transform: translateX(0); }
			to   { transform: translateX(-100%); }
		}
		@keyframes magic-marquee-x-reverse {
			from { transform: translateX(-100%); }
			to   { transform: translateX(0); }
		}
		@keyframes magic-marquee-y {
			from { transform: translateY(0); }
			to   { transform: translateY(-100%); }
		}
		@keyframes magic-marquee-y-reverse {
			from { transform: translateY(-100%); }
			to   { transform: translateY(0); }
		}

		.magic-marquee {
			gap: var(--magic-marquee-gap);
		}

		.magic-marquee__strip {
			gap: var(--magic-marquee-gap);
			animation-duration: var(--magic-marquee-duration);
			animation-timing-function: linear;
			animation-iteration-count: infinite;
			will-change: transform;
		}

		.magic-marquee__strip--horizontal {
			animation-name: magic-marquee-x;
			align-items: center;
		}
		.magic-marquee__strip--horizontal.magic-marquee__strip--reverse {
			animation-name: magic-marquee-x-reverse;
		}

		.magic-marquee__strip--vertical {
			animation-name: magic-marquee-y;
		}
		.magic-marquee__strip--vertical.magic-marquee__strip--reverse {
			animation-name: magic-marquee-y-reverse;
		}

		.magic-marquee:hover .magic-marquee__strip--pause-on-hover {
			animation-play-state: paused;
		}
	</style>
	</>
}
