// App shell. Routing is the official RenderRoute/SSR layer (src/routes.ts +
// ripple.config.ts), so this is a plain layout wrapper that paints the page
// background. Global CSS is a render-blocking <link> in index.html (avoids the
// dev FOUC that a module-import CSS causes — it would only inject on hydrate).
// Each page wraps its content in <Layout>.
export function Layout({ children }: { children: any }) @{
	<>
	<div class="fixed inset-0 grid-pattern opacity-50 -z-10" />
	<div class="min-h-screen">
		{children}
	</div>
	</>
}
