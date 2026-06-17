import { NumberTicker } from './number-ticker.tsrx';

export function Preview() @{
	<>
	<div class="flex items-center gap-10 text-5xl font-bold tracking-tight">
		<NumberTicker value={1280} />
		<NumberTicker value={99.9} decimalPlaces={1} suffix="%" class="text-primary" />
		<NumberTicker value={0} startValue={100} direction="down" />
	</div>
	</>
}
