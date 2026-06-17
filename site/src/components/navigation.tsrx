import { Button } from "./ui/button.tsrx";
import { SiGithub } from '../lib/lucide-icons.tsrx';
import { ThemeToggle } from "./theme-toggle.tsrx";
import { SearchDocs } from "./search-docs.tsrx";
import { ClientOnly } from "./client-only.tsrx";
import { cn } from "../lib/utils";

// Plain MPA links (real <a href>) — navigation is full-page under the official
// SSR router. `section` highlights the active top-level area.
const links = [
	{ to: '/components', label: 'Components', section: 'components' },
	{ to: '/magic', label: 'Magic', section: 'magic' },
	{ to: '/spell', label: 'Spell', section: 'spell' },
	{ to: '/fancy', label: 'Fancy', section: 'fancy' },
	{ to: '/streamdown', label: 'Streamdown', section: 'streamdown' },
];

export function Navigation({ noSearch, section }: { noSearch?: boolean; section?: string }) @{
	<>
	<nav class="sticky top-0 z-40 border-b border-border bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/80">
	<div class="mx-auto max-w-[89rem] px-6">
        <div class="flex h-12 items-center justify-between">
		<a class='flex items-center gap-2 rounded-md px-2 py-1 -ml-2 hover:bg-muted focus-visible:outline-2 focus-visible:outline-ring focus-visible:outline-offset-[-1px]' href="/">
			<img src='https://cdn.jsdelivr.net/gh/ethan-huo/zag-ripple@main/site/src/assets/logo.svg' alt='logo' class='size-7 rounded-sm' />
			<span class='font-semibold text-[0.9375rem]'>{'ZagRipple'}</span>
		</a>

		<div class={cn("hidden md:flex items-center gap-2", noSearch && "[&_[data-scope='combobox']]:hidden!")}>
			@for (const link of links) {
				<a
					class={cn(
						"rounded-md px-2 py-1 text-sm hover:bg-muted hover:text-foreground focus-visible:outline-2 focus-visible:outline-ring focus-visible:outline-offset-[-1px]",
						section === link.section ? "text-foreground font-medium" : "text-muted-foreground",
					)}
					href={link.to}
				>
					{link.label}
				</a>
			}
			// SearchDocs uses a Portal to document.body + a Zag machine — client-only.
			<ClientOnly fallback={<div class="hidden h-8 w-64 md:block" />}>
				<SearchDocs />
			</ClientOnly>
            <ThemeToggle />
            <Button variant="ghost" size="sm">
			<a href="https://github.com/ethan-huo/zag-ripple" target="_blank">
                <SiGithub class="h-4 w-4" />
			</a>
            </Button>
		</div>
        </div>
	</div>
    </nav>
	</>
}
