import { track } from 'ripple';
import { cn } from '@/lib/utils';

// Seamless infinite marquee — two identical segments scroll under a CSS
// animation; duplicating the content makes the wrap-around invisible.
export function Marquee({
	children,
	class: className,
	style: styleAttribute,
	duration = 20,
	pauseOnHover = false,
	direction = 'left',
	fade = true,
	fadeAmount = 10,
	...props
}: any) @{
	const isVertical = track(() => direction === 'up' || direction === 'down');
	const safeDuration = track(() => Math.max(duration, 0.01));
	const clampedFade = track(() => Math.min(Math.max(fadeAmount, 0), 50));

	const maskImage = track(() => {
		if (!fade) return '';
		const start = clampedFade.value;
		const end = 100 - clampedFade.value;
		return isVertical.value
			? `linear-gradient(to bottom, transparent 0%, black ${start}%, black ${end}%, transparent 100%)`
			: `linear-gradient(to right, transparent 0%, black ${start}%, black ${end}%, transparent 100%)`;
	});

	const containerStyle = track(() => {
		const styles: string[] = [];
		if (styleAttribute) styles.push(String(styleAttribute));
		if (maskImage.value) {
			styles.push(`mask-image: ${maskImage.value}`);
			styles.push(`-webkit-mask-image: ${maskImage.value}`);
		}
		return styles.join('; ');
	});

	<>
	<div
		{...props}
		class={cn('group flex w-full overflow-hidden', isVertical.value && 'flex-col', className)}
		style={containerStyle.value}
	>
		<div
			class={cn(
				'spell-marquee__scroller',
				isVertical.value
					? 'spell-marquee__scroller--vertical'
					: 'spell-marquee__scroller--horizontal',
				`spell-marquee__scroller--${direction}`,
				pauseOnHover && 'spell-marquee__scroller--pause-on-hover',
			)}
			style={`--spell-marquee-duration: ${safeDuration.value}s;`}
		>
			<div
				class={cn(
					'spell-marquee__segment',
					isVertical.value
						? 'spell-marquee__segment--vertical'
						: 'spell-marquee__segment--horizontal',
				)}
			>
				{children}
			</div>
			<div
				aria-hidden="true"
				class={cn(
					'spell-marquee__segment',
					isVertical.value
						? 'spell-marquee__segment--vertical'
						: 'spell-marquee__segment--horizontal',
				)}
			>
				{children}
			</div>
		</div>
	</div>

	<style>
		@keyframes spell-marquee-scroll-x { from { transform: translateX(0); } to { transform: translateX(-50%); } }
		@keyframes spell-marquee-scroll-x-reverse { from { transform: translateX(-50%); } to { transform: translateX(0); } }
		@keyframes spell-marquee-scroll-y { from { transform: translateY(0); } to { transform: translateY(-50%); } }
		@keyframes spell-marquee-scroll-y-reverse { from { transform: translateY(-50%); } to { transform: translateY(0); } }

		.spell-marquee__scroller {
			display: flex;
			flex-shrink: 0;
			width: max-content;
			animation-duration: var(--spell-marquee-duration);
			animation-timing-function: linear;
			animation-iteration-count: infinite;
			will-change: transform;
		}
		.spell-marquee__scroller--horizontal { flex-direction: row; }
		.spell-marquee__scroller--vertical { flex-direction: column; height: max-content; }
		.spell-marquee__scroller--left { animation-name: spell-marquee-scroll-x; }
		.spell-marquee__scroller--right { animation-name: spell-marquee-scroll-x-reverse; }
		.spell-marquee__scroller--up { animation-name: spell-marquee-scroll-y; }
		.spell-marquee__scroller--down { animation-name: spell-marquee-scroll-y-reverse; }
		.group:hover .spell-marquee__scroller--pause-on-hover { animation-play-state: paused; }
		.spell-marquee__segment { display: flex; flex-shrink: 0; }
		.spell-marquee__segment--horizontal { flex-direction: row; align-items: center; }
		.spell-marquee__segment--vertical { flex-direction: column; width: 100%; }
	</style>
	</>
}
