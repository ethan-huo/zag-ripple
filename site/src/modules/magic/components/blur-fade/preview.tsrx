import { BlurFade } from './blur-fade.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center justify-center gap-6 py-8 text-center">
		<BlurFade delay={0} direction="down">
			<h2 class="text-4xl font-bold tracking-tight text-foreground">Blur Fade</h2>
		</BlurFade>
		<BlurFade delay={0.1} direction="down">
			<p class="max-w-sm text-muted-foreground text-sm leading-relaxed">
				Content that fades in with a soft blur and directional slide as it
				enters the viewport. Compose multiple instances with staggered delays.
			</p>
		</BlurFade>
		<div class="flex gap-3">
			<BlurFade delay={0.2} direction="up">
				<span class="rounded-full bg-primary px-4 py-1.5 text-xs font-medium text-primary-foreground">
					Ripple
				</span>
			</BlurFade>
			<BlurFade delay={0.25} direction="up">
				<span class="rounded-full bg-primary px-4 py-1.5 text-xs font-medium text-primary-foreground">
					Motion
				</span>
			</BlurFade>
			<BlurFade delay={0.3} direction="up">
				<span class="rounded-full bg-primary px-4 py-1.5 text-xs font-medium text-primary-foreground">
					TSRX
				</span>
			</BlurFade>
		</div>
	</div>
	</>
}
