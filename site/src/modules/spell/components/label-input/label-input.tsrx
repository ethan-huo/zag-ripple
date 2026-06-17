import { track } from 'ripple';
import { tv } from 'tailwind-variants';
import { cn } from '@/lib/utils';
import { LuEye, LuEyeOff } from '@/lib/lucide-icons.tsrx';

// The floating label relies on Tailwind's `peer` pattern: the label reads
// `peer-placeholder-shown` / `peer-focus` from the sibling input. This is
// pure CSS — no JS animation needed. The password toggle is the only stateful
// piece, and the eye icon swap is the only dynamic class change.

const labelInputVariants = tv({
	base: 'peer text-primary block h-10 w-full rounded-lg border px-3.5 text-sm shadow-xs transition-[color,box-shadow,border-color] outline-none autofill:shadow-[inset_0_0_0px_1000px_var(--color-background)] focus:ring-[2px] disabled:cursor-not-allowed disabled:opacity-50 dark:border-neutral-700/75 dark:bg-neutral-950',
	variants: {
		ringColor: {
			muted: 'border-input bg-background focus:ring-muted!',
			primary: 'border-input bg-background focus:ring-primary',
			secondary: 'border-input bg-background focus:ring-secondary',
			destructive: 'border-input bg-background focus:ring-destructive',
			red: 'border-input bg-background focus:ring-red-600',
			blue: 'border-input bg-background focus:ring-blue-600',
			green: 'border-input bg-background focus:ring-green-600',
			yellow: 'border-input bg-background focus:ring-yellow-600',
			purple: 'border-input bg-background focus:ring-purple-600',
			pink: 'border-input bg-background focus:ring-pink-600',
			orange: 'border-input bg-background focus:ring-orange-600',
			cyan: 'border-input bg-background focus:ring-cyan-600',
			indigo: 'border-input bg-background focus:ring-indigo-600',
			violet: 'border-input bg-background focus:ring-violet-600',
			rose: 'border-input bg-background focus:ring-rose-600',
			amber: 'border-input bg-background focus:ring-amber-600',
			lime: 'border-input bg-background focus:ring-lime-600',
			emerald: 'border-input bg-background focus:ring-emerald-600',
			sky: 'border-input bg-background focus:ring-sky-600',
			slate: 'border-input bg-background focus:ring-slate-600',
			fuchsia: 'border-input bg-background focus:ring-fuchsia-600',
		},
		hasPasswordToggle: {
			true: 'pr-9',
		},
	},
	defaultVariants: {
		ringColor: 'muted',
	},
});

// Module-level counter so each instance gets a stable, unique id without
// touching `crypto` or `Math.random` (both are SSR-safe, but a counter is
// cheaper and gives deterministic hydration ids).
let _idCounter = 0;

export function LabelInput({
	label = '',
	ringColor = 'muted',
	type = 'text',
	placeholder = '',
	disabled = false,
	class: className,
	containerClass,
	inputClass,
	...restProps
}: any) @{
	// Generate the id once at construction time, not inside a reactive context.
	const inputId = `label-input-${++_idCounter}`;

	const isVisible = track(false);
	const isPasswordType = track(() => type === 'password');
	const inputType = track(() => isPasswordType.value ? (isVisible.value ? 'text' : 'password') : type);

	function toggleVisibility() {
		isVisible.value = !isVisible.value;
	}

	<>
	<div class={cn('group relative w-full', className, containerClass)}>
		<input
			data-slot="label-input"
			class={cn(
				labelInputVariants({ ringColor, hasPasswordToggle: isPasswordType.value }),
				inputClass,
				'placeholder:opacity-0 placeholder:transition-opacity focus:placeholder:opacity-100 focus:placeholder:delay-100 focus:placeholder:duration-200',
			)}
			placeholder={placeholder}
			type={inputType.value}
			disabled={disabled}
			id={inputId}
			{...restProps}
		/>

		<label
			class="bg-background text-muted-foreground pointer-events-none absolute inset-y-0 left-1.75 my-auto block h-fit origin-top-left -translate-y-[19px] scale-[.8] px-2 text-sm whitespace-nowrap transition-transform duration-200 will-change-transform peer-placeholder-shown:translate-y-0 peer-placeholder-shown:scale-100 peer-focus:-translate-y-[19px] peer-focus:scale-[.8] dark:bg-neutral-950"
			for={inputId}
		>
			{label}
		</label>

		@if (isPasswordType.value) {
			<button
				class="text-muted-foreground/80 hover:text-foreground focus-visible:border-ring focus-visible:ring-ring/50 absolute inset-y-0 end-0 flex h-full w-9 items-center justify-center rounded-e-md transition-[color,box-shadow] outline-none focus:z-10 focus-visible:ring-[3px] disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50"
				type="button"
				onClick={toggleVisibility}
				aria-label={isVisible.value ? 'Hide password' : 'Show password'}
				aria-pressed={isVisible.value}
				disabled={disabled}
			>
				@if (isVisible.value) {
					<LuEyeOff size="1rem" aria-hidden="true" />
				} @else {
					<LuEye size="1rem" aria-hidden="true" />
				}
			</button>
		}
	</div>
	</>
}
