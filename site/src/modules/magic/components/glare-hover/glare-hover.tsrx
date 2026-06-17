import { track } from 'ripple';
import { cn } from '@/lib/utils';

// Pure CSS glare effect via a `::before` pseudo-element whose background-position
// transitions from off-screen to fully visible on hover. CSS custom properties on
// the root element control angle, color, size, and duration — no JS animation loop
// needed. `parseHEX` converts a hex color + opacity to an rgba() string so the
// gradient edge can be semi-transparent.
type Color = `#${string}`;
type RGBA = `rgba(${number},${number},${number},${number})`;

function parseHEX(color: Color, opacity: number): RGBA | Color {
	const hex = color.replace('#', '');
	const parse = (h: string) => Number.parseInt(h, 16);

	if (/^[0-9A-Fa-f]{6}$/.test(hex)) {
		return `rgba(${parse(hex.slice(0, 2))},${parse(hex.slice(2, 4))},${parse(hex.slice(4, 6))},${opacity})`;
	}

	if (/^[0-9A-Fa-f]{3}$/.test(hex)) {
		return `rgba(${parse(hex[0] + hex[0])},${parse(hex[1] + hex[1])},${parse(hex[2] + hex[2])},${opacity})`;
	}

	return color;
}

export function GlareHover({
	children,
	width,
	height,
	background = '#000',
	color = '#ffffff',
	opacity = 0.5,
	angle = -45,
	size = 250,
	duration = 650,
	playOnce = false,
	class: className,
	style: styleProp,
	...restProps
}: any) @{
	// Derived rgba is pure computation — safe at render time on the server.
	const rgba = track(() => parseHEX(color as Color, opacity));

	const rootStyle = track(() => {
		const parts = [
			`--gh-angle: ${angle}deg`,
			`--gh-duration: ${duration}ms`,
			`--gh-size: ${size}%`,
			`--gh-rgba: ${rgba.value}`,
			`background: ${background}`,
			styleProp,
			width !== undefined ? `width: ${width}` : undefined,
			height !== undefined ? `height: ${height}` : undefined,
		];
		return parts
			.filter((v): v is string => v !== undefined && v !== null && v !== '')
			.join('; ');
	});

	<>
	<div
		class={cn(
			'relative grid size-fit cursor-pointer place-items-center overflow-hidden bg-transparent',
			'before:pointer-events-none before:absolute before:inset-0 before:z-10 before:bg-no-repeat before:content-[""]',
			'before:bg-[linear-gradient(var(--gh-angle),transparent_60%,var(--gh-rgba)_70%,transparent,transparent_100%)]',
			'before:bg-size-[var(--gh-size)_var(--gh-size),100%_100%]',
			'before:bg-position-[-100%_-100%,0_0]',
			!playOnce && 'before:transition-[background-position] before:duration-(--gh-duration) before:ease-in-out',
			playOnce && 'before:transition-none hover:before:transition-[background-position] hover:before:duration-(--gh-duration)',
			'hover:before:bg-position-[100%_100%,0_0]',
			className,
		)}
		style={rootStyle.value}
		{...restProps}
	>
		{children}
	</div>
	</>
}
