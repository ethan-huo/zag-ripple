import { AnimatedTabs } from './animated-tabs.tsrx';

const DEMO_TABS = ['Dashboard', 'Analytics', 'Settings', 'Profile'];

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-8 p-8">
		<AnimatedTabs tabs={DEMO_TABS} />
		<p class="text-xs text-muted-foreground">{'Click a tab to animate'}</p>
	</div>
	</>
}
