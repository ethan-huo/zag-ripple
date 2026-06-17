import { ArcTimeline } from './arc-timeline.tsrx';

const demoData = [
	{
		time: '2021',
		steps: [
			{ icon: '🚀', content: 'Project launched with a small team of three engineers.' },
			{ icon: '🎯', content: 'First 100 users onboarded within the first week.' },
		],
	},
	{
		time: '2022',
		steps: [
			{ icon: '💡', content: 'Core feature set finalized after extensive user research.' },
			{ icon: '🌐', content: 'Expanded to international markets across 12 countries.' },
			{ icon: '🤝', content: 'Series A funding secured — $4M raised.' },
		],
	},
	{
		time: '2023',
		steps: [
			{ icon: '⚡', content: 'Platform rewrite cut load times by 60%.' },
			{ icon: '🏆', content: 'Reached 50,000 active users milestone.' },
		],
	},
	{
		time: '2024',
		steps: [
			{ icon: '🔬', content: 'AI-powered features shipped in Q2.' },
			{ icon: '🎉', content: 'Named in Top 50 Startups to Watch.' },
		],
	},
];

export function Preview() @{
	<>
	<div class="relative w-full overflow-hidden rounded-xl border border-border bg-card">
		<div class="flex flex-col items-center py-6">
			<p class="mb-2 text-xs text-muted-foreground">Click a line to navigate</p>
			<ArcTimeline data={demoData} defaultActiveStep={{ time: '2022', stepIndex: 0 }} />
		</div>
	</div>
	</>
}
