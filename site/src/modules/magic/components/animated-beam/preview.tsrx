import { track } from 'ripple';
import { AnimatedBeam } from './animated-beam.tsrx';
import { cn } from '@/lib/utils';

// Small circle node used as beam anchor.
function BeamNode({ class: className, children }: any) @{
	<>
	<div
		class={cn(
			'z-10 flex size-12 items-center justify-center rounded-full border-2 border-border bg-card shadow-md',
			className,
		)}
	>
		{children}
	</div>
	</>
}

export function Preview() @{
	// All DOM refs held as track(null) — set via ref callbacks inside effects.
	// The container and node refs are plain reactive boxes passed to AnimatedBeam.
	const containerRef = track<HTMLDivElement | null>(null);
	const leftRef = track<HTMLDivElement | null>(null);
	const centerRef = track<HTMLDivElement | null>(null);
	const rightRef = track<HTMLDivElement | null>(null);
	const topRef = track<HTMLDivElement | null>(null);
	const bottomRef = track<HTMLDivElement | null>(null);

	<>
	<div
		ref={(el: HTMLDivElement) => { containerRef.value = el; }}
		class="relative flex h-64 w-full max-w-md items-center justify-center overflow-hidden rounded-xl border border-border bg-card p-6"
	>
		{/* Left column */}
		<div class="flex flex-col items-center gap-4">
			<BeamNode>
				<div
					ref={(el: HTMLDivElement) => { topRef.value = el; }}
					class="flex size-full items-center justify-center"
				>
					<svg class="size-5 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
						<circle cx="12" cy="12" r="10" />
						<path d="M12 8v4l3 3" />
					</svg>
				</div>
			</BeamNode>
			<BeamNode>
				<div
					ref={(el: HTMLDivElement) => { leftRef.value = el; }}
					class="flex size-full items-center justify-center"
				>
					<svg class="size-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
						<path d="M12 2L2 7l10 5 10-5-10-5zM2 17l10 5 10-5M2 12l10 5 10-5" />
					</svg>
				</div>
			</BeamNode>
			<BeamNode>
				<div
					ref={(el: HTMLDivElement) => { bottomRef.value = el; }}
					class="flex size-full items-center justify-center"
				>
					<svg class="size-5 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
						<rect x="3" y="3" width="18" height="18" rx="2" />
						<path d="M3 9h18M9 21V9" />
					</svg>
				</div>
			</BeamNode>
		</div>

		{/* Center node */}
		<div class="mx-8">
			<BeamNode class="size-16 border-primary/50">
				<div
					ref={(el: HTMLDivElement) => { centerRef.value = el; }}
					class="flex size-full items-center justify-center"
				>
					<svg class="size-7 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
						<circle cx="12" cy="12" r="3" />
						<path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83" />
					</svg>
				</div>
			</BeamNode>
		</div>

		{/* Right node */}
		<BeamNode>
			<div
				ref={(el: HTMLDivElement) => { rightRef.value = el; }}
				class="flex size-full items-center justify-center"
			>
				<svg class="size-5 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
					<path d="M22 11.08V12a10 10 0 11-5.93-9.14" />
					<polyline points="22 4 12 14.01 9 11.01" />
				</svg>
			</div>
		</BeamNode>

		{/* Beams from left-column nodes to center, and center to right */}
		<AnimatedBeam containerRef={containerRef} fromRef={topRef} toRef={centerRef} curvature={-50} duration={4} />
		<AnimatedBeam containerRef={containerRef} fromRef={leftRef} toRef={centerRef} duration={5} />
		<AnimatedBeam containerRef={containerRef} fromRef={bottomRef} toRef={centerRef} curvature={50} duration={6} />
		<AnimatedBeam containerRef={containerRef} fromRef={centerRef} toRef={rightRef} duration={4.5} gradientStartColor="#40c9ff" gradientStopColor="#40ff9c" />
	</div>
	</>
}
