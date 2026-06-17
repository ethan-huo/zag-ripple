import { track } from 'ripple';
import { cn } from '@/lib/utils';

// ArcTimeline renders an arc-shaped interactive timeline.
// All tick elements are absolutely positioned inside a giant circle div;
// rotating that div changes which step is "centered" at the 12-o'clock position.
//
// Svelte's {#each} allows outputting N sibling elements per iteration (via
// consecutive {#if} blocks). TSRX @for must produce exactly one root per
// iteration, so we pre-flatten all ticks (placeholder lines + step lines) into
// a single array and render them in one @for pass.
export function ArcTimeline({
	class: className,
	data = [],
	arcConfig = {},
	defaultActiveStep = {},
	...restProps
}: any) @{
	const circleWidth = (arcConfig.circleWidth ?? 5000) as number;
	const angleBetweenMinorSteps = (arcConfig.angleBetweenMinorSteps ?? 0.35) as number;
	const lineCountFillBetweenSteps = (arcConfig.lineCountFillBetweenSteps ?? 10) as number;
	const boundaryPlaceholderLinesCount = (arcConfig.boundaryPlaceholderLinesCount ?? 50) as number;

	function getInitialCircleRotation() {
		const defaultActiveTime = defaultActiveStep.time ?? data[0]?.time;
		const defaultActiveStepIdx = defaultActiveStep.stepIndex ?? 0;

		let count = 0;
		for (const timelineItem of data) {
			if (timelineItem.time === defaultActiveTime) {
				count += defaultActiveStepIdx;
				break;
			}
			count += timelineItem.steps.length;
		}

		return (
			-count * angleBetweenMinorSteps * (lineCountFillBetweenSteps + 1) -
			angleBetweenMinorSteps * boundaryPlaceholderLinesCount
		);
	}

	const circleRot = track(getInitialCircleRotation());

	// Pre-flatten all tick descriptors into one array so @for emits one root each.
	type TickPlaceholder = {
		kind: 'placeholder';
		id: string;
		fillAngle: number;
	};
	type TickStep = {
		kind: 'step';
		id: string;
		line: any;
		step: any;
		lineIndex: number;
		stepIndex: number;
		angle: number;
		isFirstStep: boolean;
		isLastStep: boolean;
	};
	type Tick = TickPlaceholder | TickStep;

	const ticks = track((): Tick[] => {
		const result: Tick[] = [];
		let stepsBeforeCurrentLine = 0;

		data.forEach((line: any, lineIndex: number) => {
			line.steps.forEach((step: any, stepIndex: number) => {
				const isFirstStep = lineIndex === 0 && stepIndex === 0;
				const isLastStep = lineIndex === data.length - 1 && stepIndex === line.steps.length - 1;
				const angle =
					angleBetweenMinorSteps *
						(lineCountFillBetweenSteps + 1) *
						(stepsBeforeCurrentLine + stepIndex) +
					angleBetweenMinorSteps * boundaryPlaceholderLinesCount;

				// Boundary / gap placeholder ticks before this step.
				const beforeCount = isFirstStep ? boundaryPlaceholderLinesCount : 0;
				for (let i = 0; i < beforeCount; i++) {
					result.push({
						kind: 'placeholder',
						id: `before-${lineIndex}-${stepIndex}-${i}`,
						fillAngle: i * angleBetweenMinorSteps,
					});
				}

				// The step tick itself.
				result.push({ kind: 'step', id: `step-${lineIndex}-${stepIndex}`, line, step, lineIndex, stepIndex, angle, isFirstStep, isLastStep });

				// Fill / boundary placeholder ticks after this step.
				const afterCount = isLastStep ? boundaryPlaceholderLinesCount : lineCountFillBetweenSteps;
				for (let i = 0; i < afterCount; i++) {
					result.push({
						kind: 'placeholder',
						id: `after-${lineIndex}-${stepIndex}-${i}`,
						fillAngle: angle + (i + 1) * angleBetweenMinorSteps,
					});
				}
			});
			stepsBeforeCurrentLine += line.steps.length;
		});

		return result;
	});

	function isActive(angle: number) {
		return Math.abs(angle + circleRot.value) < 0.01;
	}

	function setActiveAngle(angle: number) {
		circleRot.value = -angle;
	}

	function handleStepKeydown(event: KeyboardEvent, angle: number) {
		if (event.key === 'Enter' || event.key === ' ') {
			event.preventDefault();
			setActiveAngle(angle);
		}
	}

	<>
	<div
		class={cn('relative h-[380px] w-full overflow-hidden', className)}
		{...restProps}
	>
		<div
			class="absolute top-28 left-1/2 aspect-square origin-center rounded-full transition-all duration-500 ease-in-out"
			style={`transform: translateX(-50%) rotate(${circleRot.value}deg); width: ${circleWidth}px;`}
		>
			@for (const tick of ticks.value) {
				@if (tick.kind === 'placeholder') {
					<div
						class="absolute top-0 left-1/2 h-[34px] w-[1px] -translate-x-1/2"
						style={`transform-origin: 50% ${circleWidth / 2}px; transform: rotate(${tick.fillAngle}deg);`}
					>
						<div
							class="h-full w-full bg-[var(--placeholder-line-color,#a1a1a1)] dark:bg-[var(--placeholder-line-color,#737373)]"
							style={`transform-origin: center top; transform: rotate(${-tick.fillAngle - circleRot.value}deg);`}
						/>
					</div>
				} @else {
					<div
						class={cn(
							'absolute top-0 left-1/2 -translate-x-1/2 cursor-pointer transition-all duration-200',
							isActive(tick.angle) ? 'h-[120px] w-[2px]' : 'h-16 w-[1.5px]',
						)}
						role="button"
						tabindex={0}
						style={`transform-origin: 50% ${circleWidth / 2}px; transform: rotate(${tick.angle}deg);`}
						onClick={() => setActiveAngle(tick.angle)}
						onKeyDown={(event: KeyboardEvent) => handleStepKeydown(event, tick.angle)}
					>
						<div
							class={cn(
								'h-full w-full transition-colors duration-200',
								isActive(tick.angle)
									? 'bg-[var(--step-line-active-color,#888888)] dark:bg-[var(--step-line-active-color,#9780ff)]'
									: 'bg-[var(--step-line-inactive-color,#b1b1b1)] dark:bg-[var(--step-line-inactive-color,#737373)]',
							)}
							style={`transform-origin: center top; transform: rotate(${-tick.angle - circleRot.value}deg);`}
						>
							<div
								class={cn(
									'absolute bottom-0 left-1/2 aspect-square -translate-x-1/2',
									isActive(tick.angle)
										? 'translate-y-[calc(100%_+_14px)] scale-[1.2] text-[var(--icon-active-color,#555555)] dark:text-[var(--icon-active-color,#d4d4d4)]'
										: 'translate-y-[calc(100%_+_4px)] scale-100 text-[var(--icon-inactive-color,#a3a3a3)] dark:text-[var(--icon-inactive-color,#a3a3a3)]',
								)}
							>
								{tick.step.icon}
							</div>

							<p
								class={cn(
									'absolute bottom-0 left-1/2 line-clamp-3 flex w-[240px] -translate-x-1/2 translate-y-[calc(100%_+_42px)] items-center justify-center text-center text-sm transition-opacity duration-300 ease-in',
									'text-[var(--description-color,#555555)] dark:text-[var(--description-color,#d4d4d4)]',
									isActive(tick.angle) ? 'opacity-100' : 'opacity-0',
								)}
							>
								{tick.step.content}
							</p>
						</div>

						@if (tick.stepIndex === 0) {
							<div
								class={cn(
									'absolute top-0 left-1/2 z-10 -translate-x-1/2 translate-y-[calc(-100%-24px)] whitespace-nowrap',
									isActive(tick.angle)
										? 'text-[var(--time-active-color,#555555)] dark:text-[var(--time-active-color,#d4d4d4)]'
										: 'text-[var(--time-inactive-color,#a3a3a3)] dark:text-[var(--time-inactive-color,#a3a3a3)]',
								)}
							>
								{tick.line.time}
							</div>
						}
					</div>
				}
			}
		</div>
	</div>
	</>
}
