import { effect, track } from "ripple"
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
  animated?: boolean
  animation?: {
    duration?: number
    easing?: string
    effect?: "fade" | "blur" | "slide"
    splitBy?: "word" | "character"
  }
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

function getCaretHtml(caret: StreamdownCaret) {
  return `<span class="ripple-streamdown-caret" aria-hidden="true">${getCaretText(caret)}</span>`
}

function getLastContentInsertionIndex(html: string) {
  const trailingWhitespace = html.match(/\s*$/)?.[0] ?? ""
  const body = html.slice(0, html.length - trailingWhitespace.length)
  const closeTargets = [
    "</code></pre>",
    "</p>",
    "</li>",
    "</h1>",
    "</h2>",
    "</h3>",
    "</h4>",
    "</h5>",
    "</h6>",
    "</td>",
    "</th>",
  ]

  let insertionIndex = -1

  for (const closeTarget of closeTargets) {
    const index = body.lastIndexOf(closeTarget)

    if (index > insertionIndex) {
      insertionIndex = index
    }
  }

  return {
    body,
    insertionIndex: insertionIndex === -1 ? body.length : insertionIndex,
    trailingWhitespace,
  }
}

function getAnimationStyle(props: StreamdownProps) {
  const duration = Math.max(0, props.animation?.duration ?? 150)
  const easing = props.animation?.easing ?? "ease"

  return `--ripple-streamdown-token-duration:${duration}ms;--ripple-streamdown-token-easing:${easing};`
}

function animateLastTextSegment(html: string, props: StreamdownProps) {
  const { body, insertionIndex, trailingWhitespace } = getLastContentInsertionIndex(html)
  const beforeInsertion = body.slice(0, insertionIndex)
  const afterInsertion = body.slice(insertionIndex)
  const lastTagEnd = beforeInsertion.lastIndexOf(">")
  const textStart = lastTagEnd + 1
  const text = beforeInsertion.slice(textStart)

  if (!text.trim()) {
    return html
  }

  const pattern = props.animation?.splitBy === "character" ? /(\S)(\s*)$/ : /(\S+)(\s*)$/
  const effect = props.animation?.effect ?? "fade"
  const style = getAnimationStyle(props)
  const animatedText = text.replace(
    pattern,
    `<span class="ripple-streamdown-token" data-effect="${effect}" style="${style}">$1</span>$2`
  )

  return `${beforeInsertion.slice(0, textStart)}${animatedText}${afterInsertion}${trailingWhitespace}`
}

function insertCaretIntoHtml(html: string, caret: StreamdownCaret) {
  const { body, insertionIndex, trailingWhitespace } = getLastContentInsertionIndex(html)
  const caretHtml = getCaretHtml(caret)

  return `${body.slice(0, insertionIndex)}${caretHtml}${body.slice(insertionIndex)}${trailingWhitespace}`
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
  const displayHtml = track(() => {
    const htmlWithAnimation = props.isAnimating && props.animated !== false
      ? animateLastTextSegment(html.value, props)
      : html.value

    if (!shouldShowCaret.value || !props.caret) {
      return htmlWithAnimation
    }

    return insertCaretIntoHtml(htmlWithAnimation, props.caret)
  })

  effect(() => {
    const node = root.value
    const htmlVersion = displayHtml.value

    if (!node) {
      return
    }

    node.innerHTML = htmlVersion

    if (props.isAnimating) {
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
    </div>
  )
}
