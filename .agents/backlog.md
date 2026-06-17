# Backlog

- Streamdown parity: the Ripple package now covers streaming-safe markdown blocks, root-level caret, Streamdown-style `animated` options, KaTeX math, Mermaid diagram plugins, and stable completed-block rendering. It still needs native Shiki code highlighting/controls, link-safety controls, and official-style code/table/Mermaid control surfaces before it fully matches https://streamdown.ai/playground.
- Sigil icon sizing: the generated icons default to `1em` instead of the old script's `24px`. Bare icons (no `class`/`size`) are used in many demos; verify visually after deploy and add `size={24}` or `class="size-6"` anywhere the 24px default is required.

## 站点骨架迁移到官方 Ripple SSR(已完成,dev + production 均验证通过)

把站点从「常驻 Layout + `routing-machine` 客户端切换」迁移到**官方 `RenderRoute` + `@ripple-ts/adapter-node`(SSR/MPA)**(0.3.84 内置)。修复了「点击切换组件预览不变 / 白屏」的根因(脆弱客户端路由)。

**关键接线(踩过的坑,务必遵守):**
- `vite.config`:`appType:'custom'` + `plugins:[ripple(), tailwindcss()]`,**不要设任何 `build` 块**——会覆盖插件的 client 输入/outDir,导致 client 产到 `dist/` 根而非 `dist/client/`、`dist/server/index.html` 不生成、production preview 起不来。
- `src/routes.ts`:**不要 `import` `@ripple-ts/vite-plugin`**(`RenderRoute`)。`ripple.config.ts` 会被**客户端 hydrate 入口在浏览器里 import**,插件含 vite/node → 浏览器 import 失败 → **hydration 静默不发生**(只剩 SSR 静态 HTML、无 CSS、无交互)。改用同形纯对象 `{type:'render',path,entry,before:[]}`。
- `ripple.config.ts`:**不要用插件的 `defineConfig`**(它只是 identity);直接 `export default {…}`。`@ripple-ts/adapter-node` 浏览器 import 是安全的(node 内置被 stub),可保留。
- `/**` catch-all 404 **仅在 production 注入**(`import.meta.env.PROD ? [render('/**', …)] : []`)。插件 dev 中间件是 **pre-hook(在 Vite 之前)**,dev 下 `/**` 会拦截所有 `/@id/…`、`/src/…`、`/ripple.config.ts` 资源请求 → 全返回 404 HTML → hydrate 脚本拿到 HTML → 彻底不 hydrate。
- 全局 CSS 用 `index.html` 里**阻塞渲染的 `<link rel="stylesheet" href="/src/styles/index.css">`**(dev 由 Vite 服务、build 重写为 hashed asset 并拷进 `dist/server/index.html`)。**不要**改回 `Layout.tsrx` 模块 import——那样 dev 下 CSS 只在 hydrate 后注入 `<style>`,首帧是无样式 SSR HTML → **FOUC 闪一下大 logo**。`index.html` 还需 `<!--ssr-head-->`/`<div id="root"><!--ssr-body--></div>`,无手动 mount。
- 一页一路由 `src/pages/*.tsrx`(包 `Layout`),详情页经 `props.params.id` 取参;链接全用普通 `<a href>`;`route-context.ts`/旧 `src/index.ts` 已删;`search-docs` 的 `navigate` → `location.assign`。
- SSR 安全:`code.tsrx` 改用 npm `shiki`(非 esm.sh URL);`client-only.tsrx` 包裹 `SearchDocs`(`Portal→document.body`)与 Zag `ComponentDemo`、`StreamdownPlayground`。`motion` 服务端 import 安全。

**验证(全过):**
- `bun --filter ./site build`(client+server 两段)。
- `bun --filter ./site preview`(`ripple-preview`):SSR 内容 + manifest 预载样式 + hydrate 资源 + 未知路由 404 页 + assets 200。
- `bun site/tools/smoke.ts` 21 路由全过、0 console 错误;`bun site/tools/repro.ts` 点击切换预览随路由变(`PREVIEW CHANGED? true`);WebView 实测 Tailwind 注入(`.fixed→fixed`,logo 28px)。

**剩余(部署相关):** Vercel 上线时把 `ripple.config.ts` 的 `adapter` 换成 `@ripple-ts/adapter-vercel`,并相应调整/移除 `site/vercel.json` 的静态 SPA 重写。官方 SSR 层「相对临时」,后续升级(`sync-latest`)可能简化接线。

## animations 移植(magic / spell / fancy 模块)

参照 [SikandarJODD/animations](https://github.com/SikandarJODD/animations) 把 magic-ui / spell-ui / fancy 移植为站点的三个独立模块。本轮交付了**多模块站点骨架 + Ripple Motion 适配层 + 17 个试点组件**。

### 本轮已交付
- 骨架:`/magic` `/spell` `/fancy` 路由 + 落地页 + 通用文档页(Preview/Code 标签、安装、props、上下页)+ 分组侧边栏(`site/src/components/docs/`、`site/src/modules/`)。
- 动画底层:`site/src/lib/motion/`(基于 `motion@12.40` 封装 `Motion` / `animate` / `inView` / `stagger` / `useInView`)。
- 17 组件:spell 7(highlighted-text, gradient-wave-text, badge, tilt-card, marquee, bar-spinner, kbd)、fancy 4(vertical-cut-reveal, letter-swap, scramble-hover, scramble-in)、magic 6(word-rotate, number-ticker, animated-shiny-text, border-beam, meteors, ripple)。
- 验证:`bun site/tools/smoke.ts`(Bun.WebView 无头冒烟,21 路由全过)+ `bun --filter ./site build`。

### 取舍 / 已知缺口
- **完整 `AnimatePresence` 未实现**:word-rotate 用「单元素 exit→swap→enter」自行编排;多子节点 keyed 进出场(text-rotate 需要)尚未抽象成通用原语。
- **fancy/text-rotate 延后**:依赖 AnimatePresence(mode=wait)+ layout 宽度测量。
- **`<Motion>` 入场闪烁**:`initial` 在 effect 内吸附,首帧可能有一帧自然态闪烁;如需消除改为渲染时内联初始 style。
- **kbd `listenToKeyboard`**:轻量 keydown/keyup 实现,未完全复刻 runed `PressedKeys` 多键边界。
- **去掉了命令式实例方法**:scramble-in / vertical-cut-reveal 源组件导出的 start/reset 改为 `autoStart` 驱动(Ripple 不以实例方法暴露)。
- **prettier 配置失效(既有,非本次引入)**:`site/.prettierrc` 引用未安装的 `prettier-plugin-ripple`,实际依赖是 `@tsrx/prettier-plugin`,导致 `format`/`prettier --check` 报错。建议改 `.prettierrc` 的 plugin 名为 `@tsrx/prettier-plugin`。

### 移植已全部完成 ✅(2026-06,multi-agent workflow + Opus 验证修复)
**106 个组件全覆盖**:spell 24(含 luxe 的 animated-tabs)、fancy 17、magic 65。源仓库 magic+spell+fancy+luxe 全部移植。
- 依赖已装齐:motion, qrcode, canvas-confetti, piri, cobe, opentype.js(WebGL/3D 硬骨头如 globe/dither-shader/light-rays/icon-cloud/dotted-map/pixel-image 均真实渲染,非占位)。
- 1 个近似实现:`magic/animated-list`(无 AnimatePresence/layout FLIP,仅入场动画)。
- registry 改为 `import.meta.glob('./components/*/data.ts')` 自动收集(每个 data.ts `export const data`),加目录即注册,无需手改。
- 验证:`bun --filter ./site build`(client+server)绿;`bun site/tools/smoke-all.ts` **106/106** 路由 SSR+hydrate+预览非空+0 console 错误。
- 移植期发现并修复的运行时坑见下方「TSRX 语法坑」。

### TSRX 语法坑(移植时必读)

经本轮 dotted-map 移植踩出的额外限制:

- `key={expr}` 作为 JSX 属性 **无效**。`@for (... ; key expr)` 或 `@for (... ; index i)` 才是正确语法,不要在 JSX 元素上加 `key={...}`。
- `children` **不能作为可调用函数** (`children(ctx)`)。需要 render-prop 时改用显式命名 prop(如 `renderChildren`)。
- **`@if/@else` 块内不能有多个兄弟节点**,需用 `<>...</>` fragment 包裹。
- TypeScript **`as Type`** 在默认值中不可用(`blur = 'light' as BlurStrength` → 改为 `blur = 'light'`);在表达式中(非参数默认值)可用。
- TypeScript **`type alias`** 若包含 union type(`string | undefined`)作为 `track<...>` 泛型参数,建议直接用 `track(init)` 不加泛型。
- `<style>` 块内容必须是**原始文本**,不能用 `{&#96;...&#96;}` 模板字面量。
- **`async` 函数在 effect 内部** 会被 TSRX 编译器错误地处理 `await`。改用 Promise 链 (`.then()`) 替代 async IIFE。
- `el.children` 作为数据模型属性访问 **可能与 Ripple 的 `children` 关键字冲突**,改名为 `nodes`/`items` 等。
- `(el: HTMLElement | null)` ref 回调参数类型标注会导致 "Expected identifier"——去掉类型标注改用 `(el)`。
- `{@if (...) {...}}` 语法**无效**,正确是 `@if (...) { ... }`(不带外层花括号)。
- **动态标签**:`as` prop(字符串如 `'div'`/`'h3'`)不能写成 `<Tag>`(大写变量会被当成组件 → SSR 崩 "not-mounted")。必须用 `<{Tag}>...</{Tag}>` 动态标签语法。(hyper-text / stagger-text 踩过)
- `check-tsrx-directives.mjs` 对 render-prop 模式(`@if (fn) { {fn(ctx)} } @else { {children} }`,两分支都是 `{表达式}` 容器)会**误报** "no JSX in body";若 build + 运行均正常即为假阳性(见 motion-grid)。

### 复用约定(给后续波次)
- 每组件目录 `site/src/modules/{group}/components/{id}/`:`<id>.tsrx` + `preview.tsrx` + `data.ts`(`ComponentEntry`);把 `data` 加进 `site/src/modules/{group}/registry.ts`。
- 源码 Tab 用 `?raw` 导入(`vite/client` 已提供类型)。
- Svelte→Ripple:`$state`→`track`、`$derived`→`track(()=>…)`、`$effect`/`onMount`→`effect`(返回清理)、`motion.x`/`AnimatePresence`→`@/lib/motion`。
- 自定义 keyframes/utilities 放 `site/src/styles/magic.css`(Tailwind v4 `@theme inline`)。
- 新路由记得追加进 `site/tools/smoke.ts` 的 routes 数组再跑冒烟。
