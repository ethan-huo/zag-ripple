import { Kbd } from './kbd.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6 text-lg">
		<div class="flex items-center gap-1">
			<Kbd keys={['cmd']} />
			<Kbd keys={['K']} />
		</div>
		<div class="flex items-center gap-2 text-sm text-muted-foreground">
			<span>{'Press and hold'}</span>
			<Kbd keys={['shift']} listenToKeyboard />
			<Kbd keys={['A']} listenToKeyboard />
		</div>
	</div>
	</>
}
