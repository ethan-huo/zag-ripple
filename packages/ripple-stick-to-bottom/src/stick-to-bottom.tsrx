import { effect } from "ripple"
import {
  createStickToBottomController,
  type StickToBottomAnimation,
  type StickToBottomController,
  type StickToBottomOptions,
  type StickToBottomStateSnapshot,
  type StickToBottomTargetScrollTop,
} from "./controller"

export type StickToBottomProps = StickToBottomOptions & {
  children?: unknown
  class?: string
  className?: string
  contentClass?: string
  contentClassName?: string
  contentRef?: (element: HTMLElement | null) => void
  contextRef?: (controller: StickToBottomController | null) => void
  onStateChange?: (snapshot: StickToBottomStateSnapshot) => void
  scrollClass?: string
  scrollClassName?: string
  scrollRef?: (element: HTMLElement | null) => void
  style?: string
  bottomInset?: number | string
}

function getInsetValue(value: number | string | undefined) {
  if (value === undefined) {
    return undefined
  }

  return typeof value === "number" ? `${value}px` : value
}

function getOptions(props: StickToBottomProps): StickToBottomOptions {
  return {
    bottomThreshold: props.bottomThreshold,
    damping: props.damping,
    initial: props.initial,
    mass: props.mass,
    resize: props.resize,
    stiffness: props.stiffness,
    targetScrollTop: props.targetScrollTop,
  }
}

function mergeStyle(base: string, style: string | undefined) {
  return style ? `${base};${style}` : base
}

export function createStickToBottom(options?: StickToBottomOptions) {
  return createStickToBottomController(options)
}

export function StickToBottom(props: StickToBottomProps) {
  const controller = createStickToBottomController(getOptions(props))

  props.contextRef?.(controller)
  effect(() => {
    controller.setOptions(getOptions(props))
  })
  effect(() => {
    if (!props.onStateChange) {
      return
    }

    return controller.onStateChange(props.onStateChange)
  })
  effect(() => () => {
    props.contextRef?.(null)
    controller.dispose()
  })

  const setScrollElement = (element: HTMLElement | null) => {
    controller.setScrollElement(element)
    props.scrollRef?.(element)
  }
  const setContentElement = (element: HTMLElement | null) => {
    controller.setContentElement(element)
    props.contentRef?.(element)
  }
  const bottomInset = getInsetValue(props.bottomInset)

  return (
    <div
      class={["ripple-stick-to-bottom", props.class, props.className, props.scrollClass, props.scrollClassName]
        .filter(Boolean)
        .join(" ")}
      ref={setScrollElement}
      style={mergeStyle("height:100%;overflow:auto;scrollbar-gutter:stable both-edges;width:100%", props.style)}
    >
      <div
        class={["ripple-stick-to-bottom-content", props.contentClass, props.contentClassName]
          .filter(Boolean)
          .join(" ")}
        ref={setContentElement}
        style="min-height:100%"
      >
        {props.children}
        if (bottomInset) {
          <div class="ripple-stick-to-bottom-spacer" style={`flex-shrink:0;height:${bottomInset}`} aria-hidden="true" />
        }
      </div>
    </div>
  )
}

export type {
  StickToBottomAnimation,
  StickToBottomController,
  StickToBottomOptions,
  StickToBottomStateSnapshot,
  StickToBottomTargetScrollTop,
}
