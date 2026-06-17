import { cn } from '@/lib/utils';

// The shadow effect is purely CSS: the ::after pseudo-element mirrors the text
// via content:attr(data-text) and scrolls a diagonal hatched gradient behind it.
// No JS animation is needed — motion[as] in the Svelte source carried no
// animation props; it was used only for tag flexibility and class/style.
export function LineShadowText({
	content,
	class: className,
	shadowColor = 'black',
	as: Tag = 'span',
	...props
}: any) @{
	<>
	<{Tag}
		{...props}
		class={cn('magic-line-shadow-text', className)}
		data-text={content}
		style={`--shadow-color: ${shadowColor};`}
	>
		{content}
	</{Tag}>

	<style>
		@keyframes magic-line-shadow {
			0%   { background-position: 0 0; }
			100% { background-position: 100% -100%; }
		}

		.magic-line-shadow-text {
			position: relative;
			z-index: 0;
			display: inline-block;
			white-space: pre;
		}

		.magic-line-shadow-text::after {
			content: attr(data-text);
			position: absolute;
			top: 0.04em;
			left: 0.04em;
			z-index: -10;
			background-image: linear-gradient(
				45deg,
				transparent 45%,
				var(--shadow-color) 45%,
				var(--shadow-color) 55%,
				transparent 0
			);
			background-size: 0.06em 0.06em;
			-webkit-background-clip: text;
			background-clip: text;
			color: transparent;
			animation: magic-line-shadow 15s linear infinite;
		}
	</style>
	</>
}
