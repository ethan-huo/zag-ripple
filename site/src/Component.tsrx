import { Navigation } from './components/navigation.tsrx';
import { OpenInStackblitz } from './components/open-in-stackblitz.tsrx';
import { Usage } from './components/usage.tsrx';
import { Code as CodeBlock } from './components/code.tsrx';
import { ContextTable } from './components/context-table.tsrx';
import { ApiTable } from './components/api-table.tsrx';
import { KeyboardInteractions } from './components/keyboard-interactions.tsrx';
import { DataAttributes } from './components/data-attributes.tsrx';
import { CSSVariables } from './components/css-variables.tsrx';
import { ComponentDemo } from './components/component-demo.tsrx';
import { ClientOnly } from './components/client-only.tsrx';
import { Button } from './components/ui/button.tsrx';
import { Card } from './components/ui/card.tsrx';
import { components } from './lib/components';
import { LuArrowLeft, LuCopy, LuCode, LuChevronLeft, LuChevronRight, LuExternalLink, LuFileText, LuCheck } from './lib/lucide-icons.tsrx';
import { useCopy } from "./lib/use-copy.tsrx";
import apiJson from "@zag-js/docs"
import { track } from "ripple";

// `id` is the route param (props.params.id), passed in by the page.
export function Component({ id }: { id: string }) @{
    const currentIndex = components.findIndex((comp) => comp.id === id)
    const comp = components[currentIndex]
    const prevComponent = currentIndex > 0 ? components[currentIndex - 1] : null
    const nextComponent = currentIndex >= 0 && currentIndex < components.length - 1 ? components[currentIndex + 1] : null
    let [copyInstall, copiedInstall] = useCopy();
    const code = `npm install zag-ripple @zag-js/${id}`;

    <>
    @if (comp) {
        <>
        <head>
            <title>{`${comp.label} | ZagRipple`}</title>
        </head>

        <Navigation section="components" />

        <main class="mx-auto max-w-[48rem] px-6 py-10">
            // Breadcrumb
            <div class="mb-8 flex items-center gap-2 text-sm text-muted-foreground">
                <a href="/components" class="hover:text-foreground">
                    {'Components'}
                </a>
                <span>{'/'}</span>
                <span class="text-foreground">{comp.label}</span>
            </div>


            // Header
            <div class="mb-12">
            <div class="mb-6 flex items-center gap-4">
                <a href="/components">
                <Button variant="ghost" size="sm">
                    <LuArrowLeft class="h-4 w-4 mr-2" />
                    {"Back to Components"}
                </Button>
                </a>
            </div>

            <h1 class="mb-3 text-[2.125rem] font-bold leading-tight">{comp.label}</h1>
            <p class="mb-8 text-[1rem] leading-7 text-muted-foreground">
                {comp.description}
            </p>

            // Component Demo
            <div class="mb-8 space-y-4">

                // Demo Badges
                <div class="flex flex-wrap gap-2">
                    <OpenInStackblitz id={id} />


                <Button
                    href={`https://zagjs.com/components/react/${id}`}
                    target="_blank"
                    variant="outline"
                    size="sm"
                    data-id="zag-docs"
                    >
                        <LuFileText class="h-3 w-3 mr-1.5" />
                        {"Zag.js Docs"}
                        <LuExternalLink class="h-3 w-3 ml-1.5" />
                    </Button>


                <Button
                    href={`https://github.com/chakra-ui/zag/blob/main/packages/machines/${id}/src/${id}.machine.ts`}
                    target="_blank"
                    variant="outline"
                    size="sm"
                    data-id="view-source"
                    >
                        <LuCode class="h-3 w-3 mr-1.5" />
                        {"View Source"}
                        <LuExternalLink class="h-3 w-3 ml-1.5" />
                    </Button>
                </div>
                <ClientOnly>
                    <ComponentDemo id={id} />
                </ClientOnly>
            </div>
            </div>

            // Installation
            <section class="mb-12" data-id="installation">
                <h2 class="mb-4 text-[1.3125rem] font-bold">{"Installation"}</h2>
                <Card class="p-4">
                    <div class="flex items-center justify-between">
                    <CodeBlock code={code} language="bash" />
                    <Button variant="ghost" size="sm" onClick={() => copyInstall(code)}>
                        @if (copiedInstall.value) {
                            <LuCheck class="h-4 w-4" />
                        } @else {
                            <LuCopy class="h-4 w-4" />
                        }
                    </Button>
                    </div>
                </Card>
            </section>

            // Usage
            <Usage id={id} />

            @if (id in apiJson) {
                <>
                    // Context
                    <ContextTable id={id} />
                    // API
                    <ApiTable id={id} />
                </>
            }

            // Accessibility
            <section class="mb-12">
                <h2 class="mb-4 text-[1.3125rem] font-bold">{'Accessibility'}</h2>

                <div class="space-y-6">
                        // Data Attributes
                    <DataAttributes id={comp.package || id} />

                        // CSS Variables
                    <CSSVariables id={comp.package || id} />

                        // Keyboard Interactions
                    <KeyboardInteractions id={comp.package || id} />
                </div>
            </section>

            // Navigation
            <section>
                <div class="flex justify-between items-center">
                    @if (prevComponent) {
                        <a href={`/components/${prevComponent.id}`} class="mr-auto">
                            <Button
                                variant="outline"
                                size="lg"
                                class="flex items-center gap-3 px-6 py-4 h-auto cursor-pointer"
                            >
                                <LuChevronLeft class="h-5 w-5" />
                                <div class="text-left">
                                <div class="text-sm text-muted-foreground">{"Previous"}</div>
                                <div class="font-semibold text-base">{prevComponent.label}</div>
                                </div>
                            </Button>
                        </a>
                    }
                    @if (nextComponent) {
                        <a href={`/components/${nextComponent.id}`} class="ml-auto">
                            <Button
                                variant="outline"
                                size="lg"
                                class="flex items-center gap-3 px-6 py-4 h-auto cursor-pointer"
                            >
                                <div class="text-right">
                                <div class="text-sm text-muted-foreground">{"Next"}</div>
                                <div class="font-semibold text-base">{nextComponent.label}</div>
                                </div>
                                <LuChevronRight class="h-5 w-5" />
                            </Button>
                        </a>
                    }
                </div>
            </section>

        </main>
        </>
    } @else {
        <>
        <Navigation section="components" />
        <div class="mx-auto max-w-3xl px-6 py-24 text-center">
            <h1 class="mb-3 text-2xl font-bold">{'Component not found'}</h1>
            <a href="/components" class="text-primary hover:underline">{'Back to Components'}</a>
        </div>
        </>
    }
    </>
}
