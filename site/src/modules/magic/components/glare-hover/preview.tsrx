import { GlareHover } from './glare-hover.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-6">
		<GlareHover
			background="#18181b"
			color="#ffffff"
			opacity={0.5}
			angle={-45}
			size={250}
			duration={650}
			class="rounded-xl p-8"
		>
			<div class="flex flex-col items-center gap-3 text-center">
				<span class="text-4xl">{'✨'}</span>
				<h3 class="text-xl font-bold text-white">{'Glare Hover'}</h3>
				<p class="max-w-xs text-sm text-white/60">{'Hover me to see the glare sweep across.'}</p>
			</div>
		</GlareHover>

		<GlareHover
			background="#0f172a"
			color="#818cf8"
			opacity={0.6}
			angle={-60}
			size={300}
			duration={800}
			playOnce={true}
			class="rounded-2xl p-6"
		>
			<div class="flex items-center gap-4 text-white">
				<div class="flex size-12 items-center justify-center rounded-full bg-indigo-500/20">
					<span class="text-2xl">{'🚀'}</span>
				</div>
				<div>
					<div class="font-semibold">{'Play Once'}</div>
					<div class="text-sm text-white/50">{'Triggers only on hover start'}</div>
				</div>
			</div>
		</GlareHover>
	</div>
	</>
}
