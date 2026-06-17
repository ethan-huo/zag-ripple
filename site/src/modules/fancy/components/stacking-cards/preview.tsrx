import { StackingCards } from './stacking-cards.tsrx';

// Build items with full literal class strings so Tailwind can scan them.
const items = [
	{
		index: 0,
		children: (
			<div class="flex h-64 w-full flex-col items-start justify-end rounded-2xl p-8 shadow-xl bg-gradient-to-br from-violet-500 to-purple-700">
				<p class="text-2xl font-bold text-white">Design</p>
				<p class="mt-1 text-sm text-white/80">Craft pixel-perfect interfaces that delight users.</p>
			</div>
		),
	},
	{
		index: 1,
		children: (
			<div class="flex h-64 w-full flex-col items-start justify-end rounded-2xl p-8 shadow-xl bg-gradient-to-br from-sky-500 to-blue-700">
				<p class="text-2xl font-bold text-white">Develop</p>
				<p class="mt-1 text-sm text-white/80">Build fast, reactive components with Ripple & TSRX.</p>
			</div>
		),
	},
	{
		index: 2,
		children: (
			<div class="flex h-64 w-full flex-col items-start justify-end rounded-2xl p-8 shadow-xl bg-gradient-to-br from-emerald-500 to-teal-700">
				<p class="text-2xl font-bold text-white">Animate</p>
				<p class="mt-1 text-sm text-white/80">Add motion that feels natural and purposeful.</p>
			</div>
		),
	},
	{
		index: 3,
		children: (
			<div class="flex h-64 w-full flex-col items-start justify-end rounded-2xl p-8 shadow-xl bg-gradient-to-br from-amber-500 to-orange-700">
				<p class="text-2xl font-bold text-white">Deploy</p>
				<p class="mt-1 text-sm text-white/80">Ship with confidence using Bun and Vite.</p>
			</div>
		),
	},
];

export function Preview() @{
	<>
	<div class="relative overflow-hidden rounded-xl border border-border bg-card" style="height: 480px;">
		<StackingCards
			items={items}
			scrollable
			class="h-full w-full px-6 pt-6"
		/>
	</div>
	</>
}
