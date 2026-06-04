export type StreamdownCodeBlock = {
  code: string
  isStreamingTail: boolean
  language: string
  meta?: string
  source: string
}

export type StreamdownBlockRenderProps = {
  block: StreamdownCodeBlock
}

export type StreamdownBlockRendererResult = string | Promise<string>

export type StreamdownBlockRenderer = {
  fallback?: (props: StreamdownBlockRenderProps) => unknown
  language?: string | string[]
  match?: (block: StreamdownCodeBlock) => boolean
  name: string
  render: (props: StreamdownBlockRenderProps) => StreamdownBlockRendererResult
}

export type StreamdownPlugins = {
  renderers?: StreamdownBlockRenderer[]
}

export type StreamdownBlockErrorProps = StreamdownBlockRenderProps & {
  error: unknown
}
