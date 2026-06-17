import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// Mac-style keycap. Renders symbol glyphs for modifiers and can light up either
// from the `active` prop or by listening to the real keyboard (`listenToKeyboard`).
// The upstream uses runed's PressedKeys; here we track pressed keys with a tiny
// keydown/keyup effect so there's no extra dependency.
const keySymbolMap: Record<string, string> = {
	command: '⌘', cmd: '⌘',
	control: '⌃', ctrl: '⌃',
	alt: '⌥', option: '⌥',
	space: '␣',
	arrowleft: '←', left: '←',
	arrowdown: '↓', down: '↓',
	arrowup: '↑', up: '↑',
	arrowright: '→', right: '→',
};

const keyMatchMap: Record<string, string> = {
	command: 'meta', cmd: 'meta',
	control: 'control', ctrl: 'control',
	alt: 'alt', option: 'alt',
	shift: 'shift',
	enter: 'enter', return: 'enter',
	space: ' ',
	arrowleft: 'arrowleft', left: 'arrowleft',
	arrowdown: 'arrowdown', down: 'arrowdown',
	arrowup: 'arrowup', up: 'arrowup',
	arrowright: 'arrowright', right: 'arrowright',
};

function getKeyDisplay(item: any): string {
	const key = typeof item === 'string' ? item : item.display;
	const lower = key.toLowerCase();
	return keySymbolMap[lower] || key.toUpperCase();
}

function getPressedKey(item: any): string {
	const key = typeof item === 'string' ? item : item.key;
	const lower = key.toLowerCase();
	return keyMatchMap[lower] || lower;
}

export function Kbd({
	keys = [],
	class: className,
	active = false,
	listenToKeyboard = false,
	...restProps
}: any) @{
	const pressed = track<string[]>([]);
	const normalizedKeys = track(() => keys.map(getPressedKey));

	effect(() => {
		if (!listenToKeyboard) return;
		const down = (e: KeyboardEvent) => {
			const k = e.key.toLowerCase();
			if (!pressed.value.includes(k)) pressed.value = [...pressed.value, k];
		};
		const up = (e: KeyboardEvent) => {
			const k = e.key.toLowerCase();
			pressed.value = pressed.value.filter((x) => x !== k);
		};
		window.addEventListener('keydown', down);
		window.addEventListener('keyup', up);
		return () => {
			window.removeEventListener('keydown', down);
			window.removeEventListener('keyup', up);
		};
	});

	const isPressed = track(
		() =>
			listenToKeyboard &&
			normalizedKeys.value.length > 0 &&
			normalizedKeys.value.every((k) => pressed.value.includes(k)),
	);
	const isActive = track(() => active || isPressed.value);

	<>
	<kbd
		data-slot="spell-kbd"
		class={cn(
			'relative -top-[0.03em] box-border inline-flex min-w-[1.75em] shrink-0 cursor-default items-center justify-center rounded-[0.35em] px-[0.5em] pb-[0.05em] align-text-top text-[0.75em] leading-[1.7em] font-normal tracking-tight whitespace-nowrap transition-all duration-100 select-none',
			isActive.value
				? 'bg-background text-foreground translate-y-[0.05em] shadow-[inset_0_0.05em_rgba(255,255,255,0.95),inset_0_0.05em_0.2em_rgba(0,0,0,0.1),0_0_0_0.05em_rgba(0,0,0,0.134)] dark:shadow-[inset_0_0.05em_0.2em_rgba(0,0,0,0.3),0_0_0_0.05em_rgba(255,255,255,0.134)]'
				: 'bg-background text-foreground shadow-[inset_0_-0.05em_0.5em_rgba(0,0,0,0.034),inset_0_0.05em_rgba(255,255,255,0.95),inset_0_0.25em_0.5em_rgba(0,0,0,0.034),inset_0_-0.05em_rgba(0,0,0,0.172),0_0_0_0.05em_rgba(0,0,0,0.134),0_0.08em_0.17em_rgba(0,0,0,0.231)] dark:shadow-[inset_0_-0.05em_0.5em_rgba(255,255,255,0.034),inset_0_0.05em_rgba(255,255,255,0.1),inset_0_0.25em_0.5em_rgba(255,255,255,0.034),inset_0_-0.05em_rgba(255,255,255,0.172),0_0_0_0.05em_rgba(255,255,255,0.134),0_0.08em_0.17em_rgba(255,255,255,0.231)]',
			className,
		)}
		{...restProps}
	>
		@for (const item of keys; index i) {
			<span class={i > 0 ? 'ml-0.5' : undefined}>{getKeyDisplay(item)}</span>
		}
	</kbd>
	</>
}
