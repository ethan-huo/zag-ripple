import { effect, track } from 'ripple';
import { animate } from '@/lib/motion';
import { cn } from '@/lib/utils';

// SVG `pathLength` + strikethrough `width` are animated imperatively via
// `animate()` because `<Motion>` only wraps `<div>`. We re-run the effect
// whenever `isChecked` changes so the animation responds to each toggle, not
// just mount.
export function AnimatedCheckbox({
	title = 'Implement Checkbox',
	checked,
	defaultChecked = false,
	class: className,
	onCheckedChange,
	...rest
}: any) @{
	const internalChecked = track(defaultChecked as boolean);
	const isControlled = track(() => checked !== undefined);
	const isChecked = track(() => (isControlled.value ? (checked as boolean) : internalChecked.value));

	let pathNode = track<SVGPathElement | null>(null);
	let strikeNode = track<HTMLElement | null>(null);

	// Animate the checkmark path whenever checked state or the ref changes.
	effect(() => {
		const path = pathNode.value;
		if (!path) return;
		const checked = isChecked.value;
		animate(
			path,
			{ pathLength: checked ? 1 : 0, opacity: checked ? 1 : 0 },
			{
				pathLength: { ease: 'easeOut', duration: 0.3 },
				// opacity snaps instantly via zero-duration — same as the source
				opacity: { duration: 0 },
			},
		);
	});

	// Animate the strikethrough line with a spring transition.
	effect(() => {
		const div = strikeNode.value;
		if (!div) return;
		const checked = isChecked.value;
		animate(
			div,
			{ width: checked ? '100%' : '0%', opacity: checked ? 1 : 0 },
			{ type: 'spring', duration: 0.4, bounce: 0.2 },
		);
	});

	function handleToggle() {
		const next = !isChecked.value;
		if (!isControlled.value) {
			internalChecked.value = next;
		}
		onCheckedChange?.(next);
	}

	<>
	<button
		type="button"
		class={cn(
			'group flex items-center gap-3 text-left select-none focus-visible:ring-2 focus-visible:ring-slate-400/70 focus-visible:ring-offset-2 focus-visible:ring-offset-white focus-visible:outline-none dark:focus-visible:ring-slate-500 dark:focus-visible:ring-offset-slate-950',
			className,
		)}
		role="checkbox"
		aria-checked={isChecked.value}
		onClick={handleToggle}
		{...rest}
	>
		<div
			class={cn(
				'flex size-[18px] items-center justify-center rounded-[6px] border-[1.5px] transition-colors duration-200',
				isChecked.value
					? 'border-transparent bg-slate-950 text-white dark:bg-slate-50 dark:text-slate-950'
					: 'border-slate-400/50 bg-transparent text-slate-950 group-hover:border-slate-500/70 dark:border-slate-500/60 dark:text-slate-50 dark:group-hover:border-slate-400',
			)}
		>
			<svg viewBox="0 0 20 20" class="size-full">
				<path
					ref={(el: SVGPathElement | null) => { pathNode.value = el; }}
					d="M 0 4.5 L 3.182 8 L 10 0"
					fill="transparent"
					stroke="currentColor"
					stroke-width="1.5"
					stroke-linecap="round"
					stroke-linejoin="round"
					transform="translate(5 6)"
					style={`opacity: ${defaultChecked ? 1 : 0};`}
				/>
			</svg>
		</div>

		<div class="relative">
			<span
				class={cn(
					'text-base font-medium transition-colors duration-200',
					isChecked.value
						? 'text-slate-500 dark:text-slate-400'
						: 'text-slate-950 dark:text-slate-50',
				)}
			>
				{title}
			</span>

			<div
				ref={(el: HTMLElement | null) => { strikeNode.value = el; }}
				class="absolute top-1/2 left-0 h-[1.5px] -translate-y-1/2 bg-slate-500 dark:bg-slate-400"
				style={`width: ${defaultChecked ? '100%' : '0%'}; opacity: ${defaultChecked ? 1 : 0};`}
			/>
		</div>
	</button>
	</>
}
