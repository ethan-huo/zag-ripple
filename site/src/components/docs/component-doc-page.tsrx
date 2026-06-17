import { Navigation } from '../navigation.tsrx';
import { ModuleSidebar } from './module-sidebar.tsrx';
import { ComponentPreview } from './component-preview.tsrx';
import { PropsTable } from './props-table.tsrx';
import { Code } from '../code.tsrx';
import { Button } from '../ui/button.tsrx';
import { Badge } from '../ui/badge.tsrx';
import { getModule, type ModuleId } from '@/modules';
import { LuChevronLeft, LuChevronRight, LuExternalLink } from '@/lib/lucide-icons.tsrx';

// `id` is delivered by the SSR router as a route param (props.params.id), passed
// in by the page. Under MPA each visit is a fresh render, so plain consts (no
// tracks) are correct here.
export function ComponentDocPage({ module, id }: { module: ModuleId; id: string }) @{
	const mod = getModule(module)!;
	const idx = mod.components.findIndex((c) => c.id === id);
	const entry = mod.components[idx];
	const prev = idx > 0 ? mod.components[idx - 1] : null;
	const next = idx >= 0 && idx < mod.components.length - 1 ? mod.components[idx + 1] : null;
	const installCmd = entry?.packages?.length ? `bun add ${entry.packages.join(' ')}` : '';

	<>
	@if (entry) {
		<>
		<head>
			<title>{`${entry.title} | ${mod.tagline} · ZagRipple`}</title>
		</head>

		<Navigation section={mod.id} />

		<div class="mx-auto flex w-full max-w-[89rem]">
			<ModuleSidebar module={module} activeId={id} />

			<main class="min-w-0 flex-1 px-6 py-10 lg:px-10">
				<div class="mx-auto max-w-3xl">
					// Breadcrumb
					<div class="mb-6 flex items-center gap-2 text-sm text-muted-foreground">
						<a href={`/${mod.id}`} class="hover:text-foreground">{mod.tagline}</a>
						<span>{'/'}</span>
						<span class="text-foreground">{entry.title}</span>
					</div>

					// Header
					<div class="mb-8">
						<div class="mb-3 flex items-center gap-3">
							<h1 class="text-[2rem] font-bold leading-tight">{entry.title}</h1>
							@if (entry.beta) {
								<Badge variant="secondary" class="text-xs">{'Beta'}</Badge>
							}
						</div>
						<p class="text-[1rem] leading-7 text-muted-foreground">{entry.description}</p>
					</div>

					// Preview
					<div class="mb-12">
						<ComponentPreview preview={entry.preview} code={entry.previewCode} lang="tsx" />
					</div>

					// Installation
					@if (installCmd || entry.source) {
						<section class="mb-12">
							<h2 class="mb-4 text-[1.3125rem] font-bold">{'Installation'}</h2>
							@if (installCmd) {
								<div class="mb-4 rounded-lg border border-border bg-card p-4">
									<Code code={installCmd} language="bash" />
								</div>
							}
							@if (entry.source) {
								<>
								@for (const file of entry.source) {
									<div class="mb-4 overflow-hidden rounded-lg border border-border bg-card">
										<div class="border-b border-border bg-muted/30 px-4 py-1.5 font-mono text-xs text-muted-foreground">
											{file.filename}
										</div>
										<div class="max-h-[28rem] overflow-auto">
											<Code code={file.code} language={file.lang ?? 'tsx'} />
										</div>
									</div>
								}
								</>
							}
						</section>
					}

					// Examples
					@if (entry.examples) {
						<section class="mb-12">
							<h2 class="mb-4 text-[1.3125rem] font-bold">{'Examples'}</h2>
							<div class="space-y-8">
								@for (const example of entry.examples) {
									<div>
										<h3 class="mb-3 text-base font-semibold">{example.name}</h3>
										<ComponentPreview
											preview={example.preview}
											code={example.code}
											lang={example.lang ?? 'tsx'}
										/>
									</div>
								}
							</div>
						</section>
					}

					// Props
					@if (entry.props) {
						<section class="mb-12">
							<h2 class="mb-4 text-[1.3125rem] font-bold">{'Props'}</h2>
							<PropsTable rows={entry.props} />
						</section>
					}

					// Credit
					@if (mod.credit) {
						<p class="mb-10 text-sm text-muted-foreground">
							{'Inspired by '}
							<a
								href={mod.credit.href}
								target="_blank"
								class="inline-flex items-center gap-1 text-primary hover:underline"
							>
								{mod.credit.label}
								<LuExternalLink class="h-3 w-3" />
							</a>
						</p>
					}

					// Prev / Next
					<div class="flex items-center justify-between gap-4 border-t border-border pt-6">
						@if (prev) {
							<a href={`/${mod.id}/${prev.id}`} class="mr-auto">
								<Button variant="outline" size="lg" class="h-auto gap-3 px-5 py-3">
									<LuChevronLeft class="h-5 w-5" />
									<div class="text-left">
										<div class="text-xs text-muted-foreground">{'Previous'}</div>
										<div class="font-semibold">{prev.title}</div>
									</div>
								</Button>
							</a>
						}
						@if (next) {
							<a href={`/${mod.id}/${next.id}`} class="ml-auto">
								<Button variant="outline" size="lg" class="h-auto gap-3 px-5 py-3">
									<div class="text-right">
										<div class="text-xs text-muted-foreground">{'Next'}</div>
										<div class="font-semibold">{next.title}</div>
									</div>
									<LuChevronRight class="h-5 w-5" />
								</Button>
							</a>
						}
					</div>
				</div>
			</main>
		</div>
		</>
	} @else {
		<>
		<Navigation section={mod.id} />
		<div class="mx-auto max-w-3xl px-6 py-24 text-center">
			<h1 class="mb-3 text-2xl font-bold">{'Component not found'}</h1>
			<a href={`/${mod.id}`} class="text-primary hover:underline">
				{`Back to ${mod.tagline}`}
			</a>
		</div>
		</>
	}
	</>
}
