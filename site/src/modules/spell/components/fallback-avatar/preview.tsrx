import { FallbackAvatar } from './fallback-avatar.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-8">
		<div class="flex items-center gap-4">
			<FallbackAvatar name="Alice Johnson" size={64} />
			<FallbackAvatar name="Bob Smith" size={64} />
			<FallbackAvatar name="Carol White" size={64} />
			<FallbackAvatar name="David Lee" size={64} />
		</div>
		<div class="flex items-center gap-3">
			<FallbackAvatar name="Alice Johnson" size={32} />
			<FallbackAvatar name="Alice Johnson" size={48} />
			<FallbackAvatar name="Alice Johnson" size={64} />
			<FallbackAvatar name="Alice Johnson" size={80} />
			<FallbackAvatar name="Alice Johnson" size={96} />
		</div>
		<p class="text-xs text-muted-foreground">{'Hover an avatar to animate · Same name = same colors'}</p>
	</div>
	</>
}
