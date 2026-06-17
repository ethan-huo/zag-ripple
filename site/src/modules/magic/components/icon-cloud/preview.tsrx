import { IconCloud } from './icon-cloud.tsrx';

// A curated set of tech-brand logos from simple-icons CDN used as a meaningful demo.
const IMAGES = [
	'https://cdn.simpleicons.org/typescript/3178C6',
	'https://cdn.simpleicons.org/react/61DAFB',
	'https://cdn.simpleicons.org/svelte/FF3E00',
	'https://cdn.simpleicons.org/vuedotjs/4FC08D',
	'https://cdn.simpleicons.org/nextdotjs/000000',
	'https://cdn.simpleicons.org/nuxtdotjs/00DC82',
	'https://cdn.simpleicons.org/vite/646CFF',
	'https://cdn.simpleicons.org/vitest/6E9F18',
	'https://cdn.simpleicons.org/bun/000000',
	'https://cdn.simpleicons.org/deno/000000',
	'https://cdn.simpleicons.org/nodedotjs/5FA04E',
	'https://cdn.simpleicons.org/prisma/2D3748',
	'https://cdn.simpleicons.org/tailwindcss/06B6D4',
	'https://cdn.simpleicons.org/drizzle/C5F74F',
	'https://cdn.simpleicons.org/pnpm/F69220',
	'https://cdn.simpleicons.org/docker/2496ED',
	'https://cdn.simpleicons.org/github/181717',
	'https://cdn.simpleicons.org/vercel/000000',
	'https://cdn.simpleicons.org/cloudflare/F38020',
	'https://cdn.simpleicons.org/postgresql/4169E1',
];

export function Preview() @{
	<>
	<div class="relative flex h-80 w-full items-center justify-center overflow-hidden rounded-xl border border-border bg-card">
		<IconCloud images={IMAGES} />
	</div>
	</>
}
