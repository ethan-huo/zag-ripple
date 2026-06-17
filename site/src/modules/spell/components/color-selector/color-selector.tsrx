import { track } from 'ripple';
import { cn } from '@/lib/utils';

// Color map mirrors the upstream preset list; CSS vars are resolved at paint
// time, so there's no SSR mismatch between the `background-color` value and
// the rendered ring color.
export const colorMap: Record<string, string> = {
	default: 'var(--foreground)',
	red: 'var(--color-red-500)',
	green: 'var(--color-green-500)',
	blue: 'var(--color-blue-500)',
	yellow: 'var(--color-yellow-500)',
	purple: 'var(--color-purple-500)',
	pink: 'var(--color-pink-500)',
	indigo: 'var(--color-indigo-500)',
	orange: 'var(--color-orange-500)',
	teal: 'var(--color-teal-500)',
	cyan: 'var(--color-cyan-500)',
	lime: 'var(--color-lime-500)',
	emerald: 'var(--color-emerald-500)',
	violet: 'var(--color-violet-500)',
	fuchsia: 'var(--color-fuchsia-500)',
	rose: 'var(--color-rose-500)',
	sky: 'var(--color-sky-500)',
	amber: 'var(--color-amber-500)',
};

// The `value` prop is controlled: callers that need uncontrolled behavior pass
// `defaultValue` instead and let the component own internal state.
export function ColorSelector({
	colors,
	size,
	defaultValue,
	value: controlledValue,
	name,
	onColorSelect,
	class: className,
	...props
}: any) @{
	const colorList: string[] = colors ?? [];
	const dotSize: string = size ?? 'default';

	// Internal selection state; only relevant in uncontrolled mode.
	const internalSelected = track<string | undefined>(undefined);

	const selectedColor = track(() => {
		if (controlledValue !== undefined) return controlledValue as string;
		if (internalSelected.value !== undefined) return internalSelected.value;
		if (defaultValue !== undefined) return defaultValue as string;
		return colorList[0];
	});

	function getColorValue(color: string): string {
		return colorMap[color] ?? color;
	}

	function selectColor(color: string) {
		internalSelected.value = color;
		onColorSelect?.(color);
	}

	// Full literal class strings — Tailwind must see these statically.
	const sizeClass = track(() => {
		if (dotSize === 'sm') return 'size-4';
		if (dotSize === 'lg') return 'size-6';
		return 'size-5';
	});

	<>
	<div
		data-slot="spell-color-selector"
		role="radiogroup"
		class={cn('flex gap-2', className)}
		{...props}
	>
		@if (name) {
			<input type="hidden" name={name} value={selectedColor.value ?? ''} />
		}

		@for (const color of colorList) {
			<button
				type="button"
				role="radio"
				class={cn(
					'cursor-pointer rounded-full border border-transparent transition-transform duration-200',
					'focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:outline-none',
					'active:scale-90 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50',
					selectedColor.value === color ? 'ring-2 ring-offset-2' : '',
					sizeClass.value,
				)}
				style={`background-color: ${getColorValue(color)};${selectedColor.value === color ? ` box-shadow: inset 0 0 0 2px var(--background), 0 0 0 2px ${getColorValue(color)};` : ''}`}
				aria-label={`Select ${color} color`}
				aria-checked={selectedColor.value === color}
				onclick={() => selectColor(color)}
			/>
		}
	</div>
	</>
}
