import { OrbitingCircles } from './orbiting-circles.tsrx';

export function Preview() @{
	<>
	<div class="relative flex h-72 w-full flex-col items-center justify-center overflow-hidden rounded-xl border border-border bg-card">
		<span class="pointer-events-none bg-linear-to-b from-foreground to-foreground/40 bg-clip-text text-center text-5xl font-semibold leading-none text-transparent">
			{'Zag'}
		</span>

		{/* Inner orbit — two icons, offset by half duration */}
		<OrbitingCircles iconSize={36} duration={20} radius={80}>
			<svg viewBox="0 0 24 24" fill="currentColor" class="size-6 text-foreground">
				<path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm0 18a8 8 0 1 1 0-16 8 8 0 0 1 0 16zm-1-5h2v2h-2zm0-8h2v6h-2z"/>
			</svg>
		</OrbitingCircles>
		<OrbitingCircles iconSize={36} duration={20} radius={80} delay={-10} path>
			<svg viewBox="0 0 24 24" fill="currentColor" class="size-6 text-primary">
				<path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
			</svg>
		</OrbitingCircles>

		{/* Outer orbit — two icons reversed, offset by half duration */}
		<OrbitingCircles iconSize={44} radius={145} duration={20} reverse>
			<svg viewBox="0 0 24 24" fill="currentColor" class="size-7 text-muted-foreground">
				<path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2zm1 17.93V18a1 1 0 0 0-2 0v1.93A8 8 0 0 1 4.07 13H6a1 1 0 0 0 0-2H4.07A8 8 0 0 1 11 4.07V6a1 1 0 0 0 2 0V4.07A8 8 0 0 1 19.93 11H18a1 1 0 0 0 0 2h1.93A8 8 0 0 1 13 19.93z"/>
			</svg>
		</OrbitingCircles>
		<OrbitingCircles iconSize={44} radius={145} duration={20} reverse delay={-10} path>
			<svg viewBox="0 0 24 24" fill="currentColor" class="size-7 text-primary/70">
				<path d="M13 2.05v2.02c3.95.49 7 3.85 7 7.93 0 3.21-1.81 6-4.72 7.28L13 17v5h5l-1.22-1.22C19.91 19.07 22 15.76 22 12c0-5.18-3.95-9.45-9-9.95zM11 2.05C5.95 2.55 2 6.82 2 12c0 3.76 2.09 7.07 5.22 8.78L6 22h5v-5l-2.28 2.28C7.81 18 6 15.21 6 12c0-4.08 3.05-7.44 7-7.93V2.05z"/>
			</svg>
		</OrbitingCircles>
	</div>
	</>
}
