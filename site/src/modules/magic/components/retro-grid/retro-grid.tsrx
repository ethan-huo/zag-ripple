import { cn } from '@/lib/utils';

// Pure CSS perspective grid that scrolls toward the viewer.
// `animate-grid` is a bespoke keyframe not in the shared Tailwind theme, so it
// lives in the component <style> block (same pattern as spell/marquee).
// The grid's cell size, line colors, angle, and opacity are threaded via CSS
// custom properties so parents can override them without re-rendering.
export function RetroGrid({
	class: className,
	angle = 65,
	cellSize = 60,
	opacity = 0.5,
	lightLineColor = 'gray',
	darkLineColor = 'gray',
	...rest
}: any) @{
	const containerStyle = [
		`--grid-angle: ${angle}deg`,
		`--cell-size: ${cellSize}px`,
		`--opacity: ${opacity}`,
		`--light-line: ${lightLineColor}`,
		`--dark-line: ${darkLineColor}`,
	].join('; ');

	<>
	<div
		class={cn(
			'retro-grid pointer-events-none absolute size-full overflow-hidden perspective-[200px]',
			className,
		)}
		style={`${containerStyle}; opacity: var(--opacity);`}
		{...rest}
	>
		<div class="absolute inset-0 transform-[rotateX(var(--grid-angle))]">
			<div class="retro-grid__scroller inset-[0%_0px] ml-[-200%] h-[300vh] w-[600vw] origin-[100%_0_0] bg-[linear-gradient(to_right,var(--light-line)_1px,transparent_0),linear-gradient(to_bottom,var(--light-line)_1px,transparent_0)] bg-repeat dark:bg-[linear-gradient(to_right,var(--dark-line)_1px,transparent_0),linear-gradient(to_bottom,var(--dark-line)_1px,transparent_0)]" style="background-size: var(--cell-size) var(--cell-size);" />
		</div>
		<div class="absolute inset-0 bg-linear-to-t from-white to-transparent to-90% dark:from-black" />
	</div>

	<style>
		@keyframes retro-grid-scroll {
			0%   { transform: translateY(-50%); }
			100% { transform: translateY(0); }
		}
		.retro-grid__scroller {
			position: absolute;
			animation: retro-grid-scroll 15s linear infinite;
		}
	</style>
	</>
}
