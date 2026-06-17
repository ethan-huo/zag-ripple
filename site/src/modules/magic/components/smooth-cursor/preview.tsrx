import { SmoothCursor } from './smooth-cursor.tsrx';

// The cursor is fixed-positioned and replaces the native cursor globally.
// The demo card serves as a visual prompt — move the mouse over it to see
// the spring-physics cursor in action.
export function Preview() @{
	<>
	<div class="relative flex h-64 w-full flex-col items-center justify-center overflow-hidden rounded-xl border border-border bg-card gap-3">
		<SmoothCursor />
		<p class="text-sm font-medium text-foreground">{'Move your cursor here'}</p>
		<p class="text-xs text-muted-foreground">{'Spring-physics cursor with velocity-driven rotation'}</p>
	</div>
	</>
}
