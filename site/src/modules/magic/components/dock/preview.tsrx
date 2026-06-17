import { Dock } from './dock.tsrx';

export function Preview() @{
	// Icons are defined inside the function so JSX is valid in this scope.
	const items = [
		{ label: 'Finder',   icon: <span class="text-xl select-none" aria-hidden="true">{'🗂️'}</span> },
		{ label: 'Safari',   icon: <span class="text-xl select-none" aria-hidden="true">{'🧭'}</span> },
		{ label: 'Messages', icon: <span class="text-xl select-none" aria-hidden="true">{'💬'}</span> },
		{ label: 'Mail',     icon: <span class="text-xl select-none" aria-hidden="true">{'✉️'}</span> },
		{ label: 'Maps',     icon: <span class="text-xl select-none" aria-hidden="true">{'🗺️'}</span> },
		{ label: 'Photos',   icon: <span class="text-xl select-none" aria-hidden="true">{'🖼️'}</span> },
		{ label: 'Music',    icon: <span class="text-xl select-none" aria-hidden="true">{'🎵'}</span> },
		{ label: 'Settings', icon: <span class="text-xl select-none" aria-hidden="true">{'⚙️'}</span> },
	];

	<>
	<div class="relative flex h-64 w-full items-end justify-center overflow-hidden rounded-xl border border-border bg-card pb-4">
		<div
			class="absolute inset-0 opacity-20"
			style="background: radial-gradient(ellipse at 50% 120%, hsl(var(--primary)), transparent 70%);"
		/>
		<Dock items={items} iconSize={40} iconMagnification={64} iconDistance={120} />
	</div>
	</>
}
