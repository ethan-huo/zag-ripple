import { effect, track } from 'ripple';
import { cn } from '@/lib/utils';

// ─── Uniforms / color maths (ported verbatim from utils.ts) ─────────────────
// Keeping these pure helpers co-located avoids a separate import that would
// expose the canvas/WebGL internals to the module graph before tree-shaking.

type RGBColor = [number, number, number];

interface Uniforms {
	S: number;
	H: number;
	P: [number, number, number, number];
	Q: [number, number, number, number];
	C1: [number, number, number];
	C2: [number, number, number];
}

function hashString(value: string): [number, number] {
	let h1 = 0xdeadbeef;
	let h2 = 0x41c6ce57;
	for (let i = 0; i < value.length; i += 1) {
		const c = value.charCodeAt(i);
		h1 = Math.imul(h1 ^ c, 2654435761);
		h2 = Math.imul(h2 ^ c, 1597334677);
	}
	h1 = Math.imul(h1 ^ (h1 >>> 16), 2246822507);
	h1 ^= Math.imul(h2 ^ (h2 >>> 13), 3266489909);
	h2 = Math.imul(h2 ^ (h2 >>> 16), 2246822507);
	h2 ^= Math.imul(h1 ^ (h1 >>> 13), 3266489909);
	return [h1 >>> 0, h2 >>> 0];
}

function mulberry32(seed: number) {
	return () => {
		seed |= 0;
		seed = (seed + 0x6d2b79f5) | 0;
		let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
		t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
		return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
	};
}

function deriveHue(hash: [number, number]): number {
	const bytes: number[] = [];
	for (let i = 0; i < 4; i += 1) {
		bytes.push((hash[0] >> (i * 8)) & 0xff);
		bytes.push((hash[1] >> (i * 8)) & 0xff);
	}
	return bytes.reduce((sum, b) => sum + b, 0) % 360;
}

function oklchToRgb(L: number, C: number, H: number): RGBColor {
	const rad = (H * Math.PI) / 180;
	const a = C * Math.cos(rad);
	const b = C * Math.sin(rad);
	const lp = L + 0.3963377774 * a + 0.2158037573 * b;
	const mp = L - 0.1055613458 * a - 0.0638541728 * b;
	const sp = L - 0.0894841775 * a - 1.291485548 * b;
	const l3 = lp * lp * lp;
	const m3 = mp * mp * mp;
	const s3 = sp * sp * sp;
	const r = +4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
	const g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
	const bv = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.707614701 * s3;
	const gc = (ch: number) =>
		ch <= 0.0031308 ? 12.92 * ch : 1.055 * Math.pow(ch, 1 / 2.4) - 0.055;
	return [
		Math.round(Math.max(0, Math.min(1, gc(r))) * 255),
		Math.round(Math.max(0, Math.min(1, gc(g))) * 255),
		Math.round(Math.max(0, Math.min(1, gc(bv))) * 255),
	];
}

function computeUniforms(name: string): Uniforms {
	const hash = hashString(name);
	const random = mulberry32(hash[0]);
	const hue = deriveHue(hash);
	const c1 = oklchToRgb(0.8, 0.18, hue);
	const c2 = oklchToRgb(0.45, 0.18, hue);
	const pts: number[] = [];
	for (let i = 0; i < 8; i += 1) pts.push(random());
	return {
		S: hash[0] / 4294967296,
		H: hue / 360,
		P: [pts[0], pts[1], pts[2], pts[3]],
		Q: [pts[4], pts[5], pts[6], pts[7]],
		C1: [c1[0] / 255, c1[1] / 255, c1[2] / 255],
		C2: [c2[0] / 255, c2[1] / 255, c2[2] / 255],
	};
}

// ─── WebGL renderer (module-level singleton; ported verbatim from webgl.ts) ──
// The GL context is kept off-screen so multiple avatars on the same page
// share a single tiny context without accumulating contexts.

const VERT_SRC = 'attribute vec2 a;void main(){gl_Position=vec4(a,0,1);}';
const FRAG_SRC = `precision mediump float;
uniform vec2 R;
uniform float S,H;
uniform vec4 P,Q;
uniform vec3 C1,C2;
uniform float T;
#define UV (gl_FragCoord.xy/R)
void main(){
  vec2 uv=UV;
  vec2 b1=vec2(P.x,P.y);
  vec2 b2=vec2(P.z,P.w);
  vec2 b3=vec2(Q.x,Q.y);
  vec2 c1=b1+vec2(sin(T*.7+b1.x*6.)*.08, cos(T*.9+b1.y*6.)*.08);
  vec2 c2=b2+vec2(sin(T*.6+2.1)*.1, cos(T*.8+1.3)*.07);
  vec2 c3=b3+vec2(sin(T*.5+4.2)*.07, cos(T*1.1+3.7)*.09);
  float breath=1.+sin(T*1.3)*.06;
  float d1=(1.-length(uv-c1)*1.5)*breath;
  float d2=(1.-length(uv-c2)*1.5)*(1.+sin(T*1.7+1.)*.05);
  float d3=(1.-length(uv-c3)*1.5)*(1.+sin(T*1.1+2.)*.05);
  vec3 col=vec3(0);
  col=1.-(1.-col)*(1.-C1*max(d1,0.));
  col=1.-(1.-col)*(1.-C2*max(d2,0.));
  vec3 c3col=mix(C1,C2,.5+sin(T*.4)*.15);
  col=1.-(1.-col)*(1.-c3col*max(d3,0.));
  col=clamp(col,0.,1.);
  gl_FragColor=vec4(col,1);
}`;

interface WebGLRenderer {
	gl: WebGLRenderingContext;
	canvas: HTMLCanvasElement;
	program: WebGLProgram;
	vertexBuffer: WebGLBuffer;
	positionAttribute: number;
	resolutionUniform: WebGLUniformLocation | null;
	seedUniform: WebGLUniformLocation | null;
	hueUniform: WebGLUniformLocation | null;
	pointsPUniform: WebGLUniformLocation | null;
	pointsQUniform: WebGLUniformLocation | null;
	colorOneUniform: WebGLUniformLocation | null;
	colorTwoUniform: WebGLUniformLocation | null;
	timeUniform: WebGLUniformLocation | null;
}

// Module-scope renderer singleton — safe because the component never accesses
// this at render time; it is only referenced inside effect callbacks.
let cachedRenderer: WebGLRenderer | null = null;
let rendererInitAttempted = false;

function ensureWebGLRenderer(): WebGLRenderer | null {
	if (rendererInitAttempted) return cachedRenderer;
	rendererInitAttempted = true;

	const offscreen = document.createElement('canvas');
	offscreen.width = 64;
	offscreen.height = 64;
	const gl = offscreen.getContext('webgl', { antialias: false, depth: false, preserveDrawingBuffer: true });
	if (!gl) return null;

	const compile = (type: number, src: string) => {
		const sh = gl.createShader(type);
		if (!sh) return null;
		gl.shaderSource(sh, src);
		gl.compileShader(sh);
		if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) { gl.deleteShader(sh); return null; }
		return sh;
	};

	const vs = compile(gl.VERTEX_SHADER, VERT_SRC);
	const fs = compile(gl.FRAGMENT_SHADER, FRAG_SRC);
	if (!vs || !fs) { if (vs) gl.deleteShader(vs); if (fs) gl.deleteShader(fs); return null; }

	const program = gl.createProgram();
	if (!program) return null;
	gl.attachShader(program, vs);
	gl.attachShader(program, fs);
	gl.linkProgram(program);
	gl.deleteShader(vs);
	gl.deleteShader(fs);
	if (!gl.getProgramParameter(program, gl.LINK_STATUS)) { gl.deleteProgram(program); return null; }

	const buf = gl.createBuffer();
	if (!buf) { gl.deleteProgram(program); return null; }
	gl.bindBuffer(gl.ARRAY_BUFFER, buf);
	gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1,-1,1,-1,-1,1,-1,1,1,-1,1,1]), gl.STATIC_DRAW);

	const posAttr = gl.getAttribLocation(program, 'a');
	if (posAttr < 0) { gl.deleteBuffer(buf); gl.deleteProgram(program); return null; }

	cachedRenderer = {
		gl, canvas: offscreen, program, vertexBuffer: buf, positionAttribute: posAttr,
		resolutionUniform: gl.getUniformLocation(program, 'R'),
		seedUniform: gl.getUniformLocation(program, 'S'),
		hueUniform: gl.getUniformLocation(program, 'H'),
		pointsPUniform: gl.getUniformLocation(program, 'P'),
		pointsQUniform: gl.getUniformLocation(program, 'Q'),
		colorOneUniform: gl.getUniformLocation(program, 'C1'),
		colorTwoUniform: gl.getUniformLocation(program, 'C2'),
		timeUniform: gl.getUniformLocation(program, 'T'),
	};
	return cachedRenderer;
}

function renderWebGLToCanvas(target: HTMLCanvasElement, uniforms: Uniforms, time: number): boolean {
	const r = ensureWebGLRenderer();
	if (!r) return false;
	const { gl, canvas, program, vertexBuffer } = r;
	const w = Math.max(1, target.width);
	const h = Math.max(1, target.height);
	if (canvas.width !== w || canvas.height !== h) { canvas.width = w; canvas.height = h; }
	gl.viewport(0, 0, w, h);
	gl.useProgram(program);
	gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
	gl.enableVertexAttribArray(r.positionAttribute);
	gl.vertexAttribPointer(r.positionAttribute, 2, gl.FLOAT, false, 0, 0);
	gl.uniform2f(r.resolutionUniform, w, h);
	gl.uniform1f(r.seedUniform, uniforms.S);
	gl.uniform1f(r.hueUniform, uniforms.H);
	gl.uniform4fv(r.pointsPUniform, uniforms.P);
	gl.uniform4fv(r.pointsQUniform, uniforms.Q);
	gl.uniform3fv(r.colorOneUniform, uniforms.C1);
	gl.uniform3fv(r.colorTwoUniform, uniforms.C2);
	gl.uniform1f(r.timeUniform, time);
	gl.drawArrays(gl.TRIANGLES, 0, 6);
	const ctx = target.getContext('2d');
	if (!ctx) return false;
	ctx.clearRect(0, 0, w, h);
	ctx.drawImage(canvas, 0, 0);
	return true;
}

function renderFallback2D(target: HTMLCanvasElement, uniforms: Uniforms, time = 0): boolean {
	const ctx = target.getContext('2d');
	if (!ctx) return false;
	const w = Math.max(1, target.width);
	const h = Math.max(1, target.height);
	const radius = Math.max(w, h) * 0.55;
	const c1: RGBColor = [Math.round(uniforms.C1[0]*255), Math.round(uniforms.C1[1]*255), Math.round(uniforms.C1[2]*255)];
	const c2: RGBColor = [Math.round(uniforms.C2[0]*255), Math.round(uniforms.C2[1]*255), Math.round(uniforms.C2[2]*255)];
	const mix = (a: RGBColor, b: RGBColor, t: number): RGBColor =>
		[Math.round(a[0]+(b[0]-a[0])*t), Math.round(a[1]+(b[1]-a[1])*t), Math.round(a[2]+(b[2]-a[2])*t)];
	const c3 = mix(c1, c2, 0.5 + Math.sin(time * 0.4) * 0.15);

	const centers = [
		{ x: uniforms.P[0] + Math.sin(time*.7+uniforms.P[0]*6)*.08, y: uniforms.P[1] + Math.cos(time*.9+uniforms.P[1]*6)*.08 },
		{ x: uniforms.P[2] + Math.sin(time*.6+2.1)*.1,              y: uniforms.P[3] + Math.cos(time*.8+1.3)*.07 },
		{ x: uniforms.Q[0] + Math.sin(time*.5+4.2)*.07,             y: uniforms.Q[1] + Math.cos(time*1.1+3.7)*.09 },
	];

	const blob = (cx: number, cy: number, color: RGBColor, alpha: number) => {
		const g = ctx.createRadialGradient(cx, cy, 0, cx, cy, radius);
		const rgb = `${color[0]},${color[1]},${color[2]}`;
		g.addColorStop(0,    `rgba(${rgb},${alpha})`);
		g.addColorStop(0.45, `rgba(${rgb},${alpha*.55})`);
		g.addColorStop(1,    `rgba(${rgb},0)`);
		ctx.fillStyle = g;
		ctx.beginPath();
		ctx.arc(cx, cy, radius, 0, Math.PI * 2);
		ctx.fill();
	};

	ctx.clearRect(0, 0, w, h);
	ctx.fillStyle = 'rgb(0,0,0)';
	ctx.fillRect(0, 0, w, h);
	ctx.globalCompositeOperation = 'screen';
	blob(centers[0].x * w, centers[0].y * h, c1, 0.92);
	blob(centers[1].x * w, centers[1].y * h, c2, 0.88);
	blob(centers[2].x * w, centers[2].y * h, c3, 0.84);
	ctx.globalCompositeOperation = 'source-over';
	return true;
}

// ─── Component ───────────────────────────────────────────────────────────────
// All canvas/WebGL work happens inside effect — never at render time (SSR-safe).
export function FallbackAvatar({
	name,
	size = 32,
	animated = true,
	class: className,
	style,
	...restProps
}: any) @{
	// Canvas element reference — captured via ref callback, read inside effects.
	const canvasRef = track<HTMLCanvasElement | null>(null);

	// Inline style string is computed purely from props; no DOM access needed.
	const rootStyle = track(() =>
		[style ? String(style) : '', 'display: block', `width: ${size}px`, `height: ${size}px`]
			.filter(Boolean)
			.join('; '),
	);

	// Client-only rendering state (all DOM/RAF work isolated here).
	effect(() => {
		const canvas = canvasRef.value;
		if (!canvas) return;

		// Cache uniforms per name so multiple draws for the same avatar are cheap.
		let uniformsCache: Uniforms | null = null;
		let shouldUse2DFallback = false;
		let rafId: number | null = null;
		let isHovering = false;
		let animationTime = 0;
		let hoverStartTimestamp: number | null = null;

		const getUniforms = () => {
			if (!uniformsCache) uniformsCache = computeUniforms(name);
			return uniformsCache;
		};

		// Scale canvas bitmap with DPR; CSS box stays tied to the `size` prop.
		const syncResolution = () => {
			const dpr = window.devicePixelRatio || 1;
			const px = Math.max(1, Math.round(size * dpr));
			canvas.width = px;
			canvas.height = px;
		};

		const stopRaf = () => {
			if (rafId !== null) { cancelAnimationFrame(rafId); rafId = null; }
			hoverStartTimestamp = null;
		};

		const draw = (time: number) => {
			if (!shouldUse2DFallback) {
				const ok = renderWebGLToCanvas(canvas, getUniforms(), time);
				if (ok) return;
				shouldUse2DFallback = true;
			}
			renderFallback2D(canvas, getUniforms(), time);
		};

		const animate = (ts: number) => {
			if (!isHovering) { stopRaf(); return; }
			if (hoverStartTimestamp === null) hoverStartTimestamp = ts - animationTime * 1000;
			animationTime = (ts - hoverStartTimestamp) / 1000;
			draw(animationTime);
			rafId = requestAnimationFrame(animate);
		};

		const handlePointerEnter = () => {
			if (!animated || isHovering) return;
			isHovering = true;
			hoverStartTimestamp = null;
			rafId = requestAnimationFrame(animate);
		};

		const handlePointerLeave = () => {
			isHovering = false;
			stopRaf();
			draw(animationTime);
		};

		syncResolution();
		draw(0);

		canvas.addEventListener('pointerenter', handlePointerEnter);
		canvas.addEventListener('pointerleave', handlePointerLeave);

		return () => {
			isHovering = false;
			stopRaf();
			canvas.removeEventListener('pointerenter', handlePointerEnter);
			canvas.removeEventListener('pointerleave', handlePointerLeave);
		};
	});

	<>
	<canvas
		ref={(el) => { canvasRef.value = el as HTMLCanvasElement | null; }}
		data-slot="fallback-avatar"
		width={size}
		height={size}
		class={cn('rounded-full', className)}
		style={rootStyle.value}
		{...restProps}
	/>
	</>
}
