import type { MermaidConfig } from "mermaid"
import type { StreamdownBlockRenderer } from "./types"

let mermaidId = 0

export type StreamdownMermaidRendererOptions = {
  config?: MermaidConfig
  name?: string
}

export function createMermaidRenderer(options: StreamdownMermaidRendererOptions = {}): StreamdownBlockRenderer {
  return {
    language: "mermaid",
    name: options.name ?? "mermaid",
    async render(props) {
      const mermaidModule = await import("mermaid")
      const mermaid = mermaidModule.default

      mermaid.initialize({
        startOnLoad: false,
        securityLevel: "strict",
        ...options.config,
      })

      const result = await mermaid.render(`ripple-streamdown-mermaid-${mermaidId++}`, props.block.code)

      return result.svg
    },
  }
}
