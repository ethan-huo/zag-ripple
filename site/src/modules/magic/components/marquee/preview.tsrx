import { Marquee } from './marquee.tsrx';

const reviews = [
	{ name: 'Alice', body: 'Absolutely seamless animations. Love it!' },
	{ name: 'Bob', body: 'The smoothest marquee I have ever seen.' },
	{ name: 'Carol', body: 'Perfect for landing pages.' },
	{ name: 'Dave', body: 'Pause on hover is chef\'s kiss.' },
	{ name: 'Eve', body: 'Ripple + Magic UI = perfection.' },
];

const firstRow = reviews.slice(0, 3);
const secondRow = reviews.slice(2);

function ReviewCard({ name, body }: { name: string; body: string }) @{
	<>
	<div class="relative mx-2 w-48 shrink-0 rounded-xl border border-border bg-card p-4 shadow-sm">
		<p class="text-sm font-semibold text-foreground">{name}</p>
		<p class="mt-1 text-xs text-muted-foreground">{body}</p>
	</div>
	</>
}

export function Preview() @{
	<>
	<div class="relative flex w-full max-w-xl flex-col gap-4 overflow-hidden rounded-xl border border-border bg-background p-4">
		<Marquee pauseOnHover duration={30} repeat={3}>
			@for (const r of firstRow) {
				<ReviewCard name={r.name} body={r.body} />
			}
		</Marquee>
		<Marquee reverse pauseOnHover duration={30} repeat={3}>
			@for (const r of secondRow) {
				<ReviewCard name={r.name} body={r.body} />
			}
		</Marquee>
		<div class="pointer-events-none absolute inset-y-0 left-0 w-16 bg-gradient-to-r from-background" />
		<div class="pointer-events-none absolute inset-y-0 right-0 w-16 bg-gradient-to-l from-background" />
	</div>
	</>
}
