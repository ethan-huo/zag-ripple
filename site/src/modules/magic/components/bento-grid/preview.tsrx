import { BentoCard, BentoGrid } from './bento-grid.tsrx';
import {
	LuCode,
	LuSparkles,
	LuFileText,
	LuZap,
} from '@/lib/lucide-icons.tsrx';

// Decorative gradient backgrounds for each card — pure CSS, SSR-safe.
function GradientBlue() @{
	<>
	<div class="absolute inset-0 bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-blue-950/30 dark:to-indigo-900/20" />
	<div class="absolute right-4 top-4 h-24 w-24 rounded-full bg-blue-200/50 blur-2xl dark:bg-blue-500/10" />
	</>
}

function GradientPurple() @{
	<>
	<div class="absolute inset-0 bg-gradient-to-br from-purple-50 to-pink-100 dark:from-purple-950/30 dark:to-pink-900/20" />
	<div class="absolute left-6 top-6 h-20 w-20 rounded-full bg-purple-200/60 blur-xl dark:bg-purple-500/10" />
	</>
}

function GradientAmber() @{
	<>
	<div class="absolute inset-0 bg-gradient-to-br from-amber-50 to-orange-100 dark:from-amber-950/30 dark:to-orange-900/20" />
	<div class="absolute right-6 bottom-6 h-20 w-20 rounded-full bg-amber-200/60 blur-xl dark:bg-amber-500/10" />
	</>
}

function GradientEmerald() @{
	<>
	<div class="absolute inset-0 bg-gradient-to-br from-emerald-50 to-teal-100 dark:from-emerald-950/30 dark:to-teal-900/20" />
	<div class="absolute left-4 top-4 h-28 w-28 rounded-full bg-emerald-200/50 blur-2xl dark:bg-emerald-500/10" />
	</>
}

export function Preview() @{
	<>
	<div class="w-full max-w-4xl p-4">
		<BentoGrid class="grid-cols-3">
			<BentoCard
				name="Build Faster"
				class="col-span-2"
				background={GradientBlue}
				Icon={LuZap}
				description="Compose reactive UIs with Ripple's fine-grained reactivity — no virtual DOM overhead."
				href="#"
				cta="Explore Ripple"
			/>
			<BentoCard
				name="Type-safe"
				class="col-span-1"
				background={GradientPurple}
				Icon={LuCode}
				description="Full TypeScript inference across props, state, and effects."
				href="#"
				cta="Learn more"
			/>
			<BentoCard
				name="Animated"
				class="col-span-1"
				background={GradientAmber}
				Icon={LuSparkles}
				description="Motion primitives built on the web animations API."
				href="#"
				cta="See effects"
			/>
			<BentoCard
				name="Well documented"
				class="col-span-2"
				background={GradientEmerald}
				Icon={LuFileText}
				description="Every component comes with full source, props table, and live preview."
				href="#"
				cta="View docs"
			/>
		</BentoGrid>
	</div>
	</>
}
