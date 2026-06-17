import { effect, track } from 'ripple';
import { animate, stagger } from '@/lib/motion';
import { cn } from '@/lib/utils';
import { splitGraphemes } from '@/lib/text-utils';

// Each character rises into view from a clipped track, staggered across the
// text. The visible text is read from a hidden probe of `children`, so it works
// with arbitrary markup.
const defaultTransition = { type: 'spring', stiffness: 190, damping: 22 };

export function VerticalCutReveal({
	children,
	reverse = false,
	transition = defaultTransition,
	splitBy = 'words',
	staggerDuration = 0.2,
	staggerFrom = 'first',
	containerClass,
	wordLevelClass,
	elementLevelClass,
	autoStart = true,
	class: className,
	...props
}: any) @{
	let probe = track<HTMLElement | null>(null);
	let root = track<HTMLElement | null>(null);
	const text = track('');

	const normalize = (raw: string) =>
		splitBy === 'lines' ? raw.replace(/\r\n?/g, '\n').trim() : raw.replace(/\s+/g, ' ').trim();

	// Mirror text out of the hidden probe.
	effect(() => {
		const el = probe.value;
		if (!el) {
			text.value = '';
			return;
		}
		const sync = () => {
			text.value = normalize(el.textContent ?? '');
		};
		sync();
		const observer = new MutationObserver(sync);
		observer.observe(el, { childList: true, characterData: true, subtree: true });
		return () => observer.disconnect();
	});

	const renderGroups = track(() => {
		const t = text.value;
		if (!t) return [] as { characters: string[]; needsSpace: boolean; index: number }[];
		if (splitBy === 'characters') {
			const words = t.split(' ');
			return words.map((word, index) => ({
				characters: splitGraphemes(word),
				needsSpace: index !== words.length - 1,
				index,
			}));
		}
		const segments =
			splitBy === 'words' ? t.split(' ') : splitBy === 'lines' ? t.split('\n') : t.split(splitBy);
		return segments.map((segment, index) => ({
			characters: [segment],
			needsSpace: splitBy === 'words' && index !== segments.length - 1,
			index,
		}));
	});

	// Animate the characters up once they're in the DOM.
	effect(() => {
		const host = root.value;
		const groups = renderGroups.value;
		if (!host || groups.length === 0 || !autoStart) return;
		const chars = host.querySelectorAll('.vcr-char');
		if (chars.length === 0) return;
		animate(
			chars,
			{ y: [reverse ? '-100%' : '100%', '0%'] },
			{ ...transition, delay: stagger(staggerDuration, { from: staggerFrom }) },
		);
	});

	<>
	<span
		ref={(el) => {
			root.value = el;
		}}
		class={cn(
			'flex flex-wrap whitespace-pre-wrap',
			splitBy === 'lines' && 'flex-col',
			containerClass,
			className,
		)}
		{...props}
	>
		<span class="sr-only">{text.value}</span>

		<span
			ref={(el) => {
				probe.value = el;
			}}
			aria-hidden="true"
			class="pointer-events-none absolute whitespace-pre-wrap opacity-0"
		>
			{children}
		</span>

		@for (const group of renderGroups.value; index gi) {
			<span aria-hidden="true" class={cn('inline-flex overflow-hidden', wordLevelClass)}>
				@for (const character of group.characters; index ci) {
					<span class={cn('relative whitespace-pre-wrap', elementLevelClass)}>
						<span class="vcr-char inline-block">{character}</span>
					</span>
				}
				@if (group.needsSpace) {
					<span aria-hidden="true" class="whitespace-pre">{' '}</span>
				}
			</span>
		}
	</span>
	</>
}
