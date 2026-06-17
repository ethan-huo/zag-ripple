import { AnimatedThemeToggler } from './animated-theme-toggler.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-4">
		<div class="flex items-center gap-3 rounded-xl border border-border bg-card px-6 py-4 shadow-sm">
			<span class="text-sm text-muted-foreground">Toggle theme</span>
			<AnimatedThemeToggler class="rounded-md p-2 text-foreground hover:bg-muted transition-colors" />
		</div>
		<p class="text-xs text-muted-foreground">
			Uses the View Transition API for a radial reveal effect
		</p>
	</div>
	</>
}
