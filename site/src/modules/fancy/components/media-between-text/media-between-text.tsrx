import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';
import { animate } from '@/lib/motion';
import { useInView } from '@/lib/motion';

// The media container animates from width:0 to a fixed width when the trigger
// fires, and reverses when it resets. We use a measured fixed width rather than
// `width: auto` because the DOM `animate()` engine cannot tween to "auto" — the
// content width is captured on mount inside an effect.
//
// `triggerType="ref"` lets the parent drive animation via the `isAnimating` prop
// (no Svelte binding equivalent; just pass a reactive value).

export function MediaBetweenText({
	firstText,
	secondText,
	mediaUrl,
	mediaType,
	mediaContainerClass,
	fallbackUrl,
	autoPlay = true,
	loop = true,
	muted = true,
	playsInline = true,
	alt,
	triggerType = 'hover',
	useInViewOptions = { once: true, amount: 0.5 },
	class: className,
	leftTextClass,
	rightTextClass,
	isAnimating = false,
	...props
}: any) @{
	const isHovered = track(false);

	// Capture container node for inView wiring.
	let containerNode = track<HTMLElement | null>(null);
	// Capture the media wrapper node to animate its width.
	let mediaNode = track<HTMLElement | null>(null);
	// Track natural (expanded) width so we can tween to it precisely.
	let expandedWidth = track(0);

	const { ref: inViewRef, visible } = useInView({
		once: useInViewOptions.once ?? true,
		amount: useInViewOptions.amount ?? 0.5,
		margin: useInViewOptions.margin,
	});

	// Derived: should the media be revealed right now?
	const shouldAnimate = track(() => {
		if (triggerType === 'hover') return isHovered.value;
		if (triggerType === 'inView') return visible.value;
		if (triggerType === 'ref') return isAnimating;
		return false;
	});

	// Measure the natural (unconstrained) width once the media element mounts.
	// We temporarily lift the width constraint off-screen so the browser can lay
	// the content out without a visible flash, then lock it back down before the
	// first paint of the collapsed state. `scrollWidth` forces a reflow and reads
	// the full intrinsic width regardless of the current overflow clip.
	effect(() => {
		const el = mediaNode.value;
		if (!el) return;
		const prev = el.style.cssText;
		el.style.cssText += ';position:absolute;visibility:hidden;width:auto;';
		expandedWidth.value = el.scrollWidth || 160;
		el.style.cssText = prev;
	});

	// Wire the container node to the inView ref.
	effect(() => {
		const el = containerNode.value;
		if (el) inViewRef(el);
	});

	// Animate width whenever shouldAnimate changes.
	effect(() => {
		const el = mediaNode.value;
		if (!el || expandedWidth.value === 0) return;
		const toWidth = shouldAnimate.value ? expandedWidth.value : 0;
		// spring(bounce: 0) ≈ a critically-damped ease. motion/dom supports
		// type:"spring" in its AnimationOptions.
		animate(el, { width: toWidth }, { duration: 0.4, type: 'spring', bounce: 0 } as any);
	});

	<>
	<div
		ref={(el) => {
			containerNode.value = el;
		}}
		class={cn('flex items-center', className)}
		onMouseEnter={() => {
			if (triggerType === 'hover') isHovered.value = true;
		}}
		onMouseLeave={() => {
			if (triggerType === 'hover') isHovered.value = false;
		}}
		{...props}
	>
		<span class={cn(leftTextClass)}>{firstText}</span>

		{/* width starts at 0; animated to natural width via effect */}
		<div
			ref={(el) => {
				mediaNode.value = el;
			}}
			class={cn('overflow-hidden', mediaContainerClass)}
			style="width: 0px;"
		>
			@if (mediaType === 'video') {
				<video
					class="h-full w-full object-cover"
					autoPlay={autoPlay}
					loop={loop}
					muted={muted}
					playsInline={playsInline}
					poster={fallbackUrl}
				>
					<source src={mediaUrl} type="video/mp4" />
				</video>
			} @else {
				<img
					src={mediaUrl}
					alt={alt || `${firstText} ${secondText}`}
					class="h-full w-full object-cover"
				/>
			}
		</div>

		<span class={cn(rightTextClass)}>{secondText}</span>
	</div>
	</>
}
