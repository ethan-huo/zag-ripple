import { expect, test } from "bun:test"
import {
  completeMarkdown,
  parseMarkdownIntoBlocks,
  renderMarkdownToHtml,
} from "../src/core"

test("completeMarkdown repairs incomplete inline formatting", () => {
  expect(completeMarkdown("**bold")).toBe("**bold**")
})

test("renderMarkdownToHtml handles incomplete fenced code blocks", () => {
  const html = renderMarkdownToHtml("```ts\nconst value = 1")

  expect(html).toContain("<pre><code")
  expect(html).toContain("language-ts")
  expect(html).toContain("const value = 1")
})

test("parseMarkdownIntoBlocks keeps footnotes in one document block", () => {
  const markdown = "A reference[^1]\n\n[^1]: Footnote text"

  expect(parseMarkdownIntoBlocks(markdown)).toEqual([markdown])
})

test("renderMarkdownToHtml supports gfm tables and task lists", () => {
  const html = renderMarkdownToHtml("- [x] Done\n\n| A | B |\n| - | - |\n| 1 | 2 |")

  expect(html).toContain("<table>")
  expect(html).toContain("type=\"checkbox\"")
  expect(html).toContain("checked")
})

test("renderMarkdownToHtml renders math with katex markup", () => {
  const html = renderMarkdownToHtml("Inline math $$E = mc^2$$.")

  expect(html).toContain("katex")
  expect(html).toContain("E")
})

test("renderMarkdownToHtml strips unsafe script content", () => {
  const html = renderMarkdownToHtml("[bad](javascript:alert(1))<script>alert(1)</script>")

  expect(html).not.toContain("javascript:")
  expect(html).not.toContain("<script")
})
