import { AnimatedList } from './animated-list.tsrx';

// Sample notifications matching the classic Magic UI animated-list demo.
const NOTIFICATIONS = [
	{
		id: 'n1',
		icon: '🔔',
		title: 'New message',
		description: 'You have a new message from Alex',
		time: '2m ago',
		color: 'bg-blue-500',
	},
	{
		id: 'n2',
		icon: '💳',
		title: 'Payment received',
		description: '$299 credited to your account',
		time: '5m ago',
		color: 'bg-green-500',
	},
	{
		id: 'n3',
		icon: '🚀',
		title: 'Deploy complete',
		description: 'Your app shipped to production',
		time: '8m ago',
		color: 'bg-violet-500',
	},
	{
		id: 'n4',
		icon: '⭐',
		title: 'New review',
		description: 'Someone left a 5-star review',
		time: '12m ago',
		color: 'bg-yellow-500',
	},
	{
		id: 'n5',
		icon: '🔒',
		title: 'Security alert',
		description: 'Sign-in from a new device',
		time: '15m ago',
		color: 'bg-red-500',
	},
	{
		id: 'n6',
		icon: '📦',
		title: 'Order shipped',
		description: 'Your order is on its way',
		time: '20m ago',
		color: 'bg-orange-500',
	},
];

export function Preview() @{
	<>
	<div class="relative flex h-80 w-full max-w-sm mx-auto flex-col overflow-hidden rounded-xl border border-border bg-card p-4">
		<AnimatedList
			items={NOTIFICATIONS}
			delay={1200}
			renderItem={(item: any) => (
				<div class="flex items-center gap-3 rounded-lg border border-border bg-background px-3 py-2 shadow-sm">
					<span class={`flex h-8 w-8 shrink-0 items-center justify-center rounded-full text-sm ${item.color}`}>
						{item.icon}
					</span>
					<div class="flex min-w-0 flex-1 flex-col">
						<div class="flex items-center justify-between gap-2">
							<span class="truncate text-sm font-medium text-foreground">{item.title}</span>
							<span class="shrink-0 text-xs text-muted-foreground">{item.time}</span>
						</div>
						<span class="truncate text-xs text-muted-foreground">{item.description}</span>
					</div>
				</div>
			)}
		/>
	</div>
	</>
}
