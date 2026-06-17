import { cn } from '@/lib/utils';

// No framework boundary needed — pure layout component with no client-side
// interactivity. Props mirror the Svelte source directly.

export type AvatarItem = {
	imageUrl: string;
	profileUrl: string;
};

export function AvatarCircles({
	class: className,
	numPeople,
	avatarUrls = [],
}: {
	class?: string;
	numPeople?: number;
	avatarUrls: AvatarItem[];
}) @{
	<>
	<div class={cn('z-10 flex -space-x-4 rtl:space-x-reverse', className)}>
		@for (const url of avatarUrls; index i) {
			<a href={url.profileUrl} target="_blank" rel="noopener noreferrer">
				<img
					class="h-10 w-10 rounded-full border-2 border-background"
					src={url.imageUrl}
					width="40"
					height="40"
					alt={`Avatar ${i + 1}`}
				/>
			</a>
		}
		@if ((numPeople ?? 0) > 0) {
			<a
				class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-background bg-foreground text-center text-xs font-medium text-background hover:bg-muted-foreground"
				href="/"
			>
				+{numPeople}
			</a>
		}
	</div>
	</>
}
