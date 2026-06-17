import { track } from 'ripple';
import { animate, stagger } from '@/lib/motion';
import { cn } from '@/lib/utils';

// On hover, each letter slides out while a duplicate slides in from the opposite
// edge — staggered across the word. Two stacked copies per letter (`.letter` and
// `.letter-secondary`) make the swap seamless.
export function LetterSwap({
	label,
	reverse = true,
	transition = { type: 'spring', duration: 0.7 },
	staggerDuration = 0.03,
	staggerFrom = 'first',
	class: className,
	...props
}: any) @{
	let scope = track<HTMLElement | null>(null);
	let blocked = false;
	const letters = label.split('');

	const merge = (base: any) => ({
		...base,
		delay: stagger(staggerDuration, { from: staggerFrom }),
	});

	const hoverStart = () => {
		const root = scope.value;
		if (!root || blocked) return;
		blocked = true;

		const primaries = root.querySelectorAll('.letter');
		const secondaries = root.querySelectorAll('.letter-secondary');

		animate(primaries, { y: reverse ? '100%' : '-100%' }, merge(transition)).then(() => {
			animate(primaries, { y: 0 }, { duration: 0 }).then(() => {
				blocked = false;
			});
		});

		animate(secondaries, { top: '0%' }, merge(transition)).then(() => {
			animate(secondaries, { top: reverse ? '-100%' : '100%' }, { duration: 0 });
		});
	};

	<>
	<span
		ref={(el) => {
			scope.value = el;
		}}
		class={cn('relative flex items-center justify-center overflow-hidden', className)}
		onMouseEnter={hoverStart}
		{...props}
	>
		<span class="sr-only">{label}</span>

		@for (const letter of letters) {
			<span class="relative flex whitespace-pre" aria-hidden="true">
				<span class="letter relative" style="top: 0">{letter}</span>
				<span class="letter-secondary absolute" style={`top: ${reverse ? '-100%' : '100%'}`}>
					{letter}
				</span>
			</span>
		}
	</span>
	</>
}
