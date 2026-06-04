import { effect, Fragment, track } from "ripple"
import type { MermaidConfig } from "mermaid"
import {
  renderMarkdownToHtml,
  type StreamdownCaret,
  type StreamdownMode,
  type StreamdownOptions,
} from "./core"

export type StreamdownProps = StreamdownOptions & {
  value?: string
  children?: string
  class?: string
  className?: string
  mermaid?: {
    config?: MermaidConfig
  }
}

let mermaidModulePromise: Promise<typeof import("mermaid")> | null = null
let mermaidId = 0

function getContent(props: StreamdownProps) {
  if (typeof props.value === "string") {
    return props.value
  }

  if (typeof props.children === "string") {
    return props.children
  }

  return ""
}

function getCaretText(caret: StreamdownCaret) {
  return caret === "circle" ? "●" : "▋"
}

function mergeClasses(...classes: Array<string | undefined | false>) {
  return classes.filter(Boolean).join(" ")
}

function getMermaidModule() {
  mermaidModulePromise ??= import("mermaid")
  return mermaidModulePromise
}

async function renderMermaidBlocks(root: HTMLElement, config?: MermaidConfig) {
  const blocks = Array.from(root.querySelectorAll("pre > code.language-mermaid"))

  if (blocks.length === 0) {
    return
  }

  const mermaidModule = await getMermaidModule()
  const mermaid = mermaidModule.default

  mermaid.initialize({
    startOnLoad: false,
    securityLevel: "strict",
    ...config,
  })

  for (const block of blocks) {
    const pre = block.parentElement

    if (!pre || pre.dataset.rippleStreamdownMermaid === "rendered") {
      continue
    }

    pre.dataset.rippleStreamdownMermaid = "rendered"
    const source = block.textContent ?? ""
    const container = document.createElement("div")
    container.className = "ripple-streamdown-mermaid"

    try {
      const result = await mermaid.render(`ripple-streamdown-mermaid-${mermaidId++}`, source)
      container.innerHTML = result.svg
    } catch (error) {
      container.classList.add("ripple-streamdown-mermaid-error")
      container.textContent = error instanceof Error ? error.message : "Unable to render Mermaid diagram."
    }

    pre.replaceWith(container)
  }
}

export function Streamdown(props: StreamdownProps) {
  const root = track<HTMLElement | null>(null)
  const html = track(() =>
    renderMarkdownToHtml(getContent(props), {
      parseIncompleteMarkdown: props.parseIncompleteMarkdown,
      remend: props.remend,
    })
  )
  const mode = track<StreamdownMode>(() => props.mode ?? "static")
  const shouldShowCaret = track(() => Boolean(props.caret && props.isAnimating))

  effect(() => {
    const node = root.value
    const htmlVersion = html.value

    if (!node || props.isAnimating) {
      return
    }

    queueMicrotask(() => {
      void htmlVersion
      void renderMermaidBlocks(node, props.mermaid?.config)
    })
  })

  return (
    <div
      ref={root}
      class={mergeClasses(
        "ripple-streamdown",
        mode.value === "streaming" && "ripple-streamdown-streaming",
        props.class,
        props.className
      )}
      data-ripple-streamdown=""
      data-mode={mode.value}
    >
      <Fragment innerHTML={html.value} />
      if (shouldShowCaret.value && props.caret) {
        <span class="ripple-streamdown-caret" aria-hidden="true">
          {getCaretText(props.caret)}
        </span>
      }
    </div>
  )
}
