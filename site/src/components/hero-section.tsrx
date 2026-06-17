import { Button } from './ui/button.tsrx';
import { LuArrowRight, LuSparkles, LuCheck, LuCodeXml, LuCopy } from '../lib/lucide-icons.tsrx';
import { useCopy } from '../lib/use-copy.tsrx';

// Home hero — reframed from a single "component library" into the entry point of
// a multi-module Ripple TS playground. The module index (HomeModules) carries
// the rest of the message, so this stays tight and sits above the fold.
export function HeroSection() @{
	let [copy, copied] = useCopy();

	<>
	<section class="mx-auto max-w-[89rem] px-6 pt-16 pb-10 md:pt-24 md:pb-14">
		<div class="max-w-[46rem]">
			<div class="mb-6 inline-flex items-center gap-2 rounded-full border border-border bg-card px-3 py-1 text-sm text-muted-foreground">
				<LuSparkles class="h-3.5 w-3.5 text-primary" />
				<span>{'A Ripple TS playground'}</span>
			</div>

			<h1 class="mb-5 text-[2.5rem] font-bold leading-[1.04] tracking-tight text-balance md:text-[3.5rem]">
				<span class="text-primary">{'ZagRipple'}</span>
				<br />
				{'Components & animations for Ripple TS'}
			</h1>

			<p class="mb-8 max-w-[40rem] text-[1.0625rem] leading-7 text-muted-foreground text-balance">
				{`Headless Zag.js components, animation modules ported from Magic UI, Spell and Fancy, plus a Streamdown playground — built on Ripple TS, all in one place.`}
			</p>

			<div class="flex flex-col gap-3 sm:flex-row sm:items-center">
				<Button size="lg" href="/components">
					{'Browse Components'}
					<LuArrowRight class="ml-2 h-5 w-5" />
				</Button>

				<div class="inline-flex h-9 items-center gap-3 rounded-md border border-border bg-card px-3 font-mono text-sm">
					<span class="text-muted-foreground">{'$'}</span>
					<span>{'npm install zag-ripple'}</span>
					<Button
						variant="ghost"
						size="sm"
						class="h-6 w-6 p-0"
						onClick={() => copy('npm install zag-ripple')}
					>
						@if (copied.value) {
							<LuCheck class="h-3 w-3" />
						} @else {
							<LuCopy class="h-3 w-3" />
						}
					</Button>
				</div>
			</div>
		</div>
	</section>
	</>
}
