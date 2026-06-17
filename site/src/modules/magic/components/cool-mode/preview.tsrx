import { CoolMode } from './cool-mode.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6 py-8">
		<p class="text-sm text-muted-foreground">{'Press and drag over the buttons to spawn particles'}</p>
		<div class="flex gap-4">
			<CoolMode>
				<button class="rounded-lg bg-primary px-6 py-3 text-sm font-semibold text-primary-foreground shadow transition-opacity hover:opacity-90 active:scale-95 select-none cursor-pointer">
					{'Click me!'}
				</button>
			</CoolMode>
			<CoolMode options={{ particle: '🎉' }}>
				<button class="rounded-lg bg-card border border-border px-6 py-3 text-sm font-semibold text-foreground shadow transition-opacity hover:bg-muted active:scale-95 select-none cursor-pointer">
					{'🎉 Party'}
				</button>
			</CoolMode>
			<CoolMode options={{ particle: '⭐' }}>
				<button class="rounded-lg bg-card border border-border px-6 py-3 text-sm font-semibold text-foreground shadow transition-opacity hover:bg-muted active:scale-95 select-none cursor-pointer">
					{'⭐ Stars'}
				</button>
			</CoolMode>
		</div>
	</div>
	</>
}
