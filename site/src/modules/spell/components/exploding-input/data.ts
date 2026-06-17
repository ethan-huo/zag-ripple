import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './exploding-input.tsrx?raw';

export const data: ComponentEntry = {
	id: 'exploding-input',
	title: 'Exploding Input',
	description: 'A physics-based particle emitter that bursts confetti from the text caret on every keystroke.',
	group: 'Inputs',
	preview: Preview,
	previewCode,
	source: [{ filename: 'exploding-input.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'target', type: 'HTMLInputElement | null', default: 'null', description: 'Explicit input to attach to. Falls back to nearest <label> > input.' },
		{ name: 'items', type: 'any[]', default: '[]', description: 'Content pool cycled per particle. Defaults to colored squares.' },
		{ name: 'itemRenderer', type: '(item: any, idx: number) => any', description: 'Custom render function for each item particle.' },
		{ name: 'count', type: 'number', default: '1', description: 'Particles spawned per keystroke (clamped 1–5).' },
		{ name: 'duration', type: 'number', default: '3', description: 'Particle lifetime in seconds.' },
		{ name: 'gravity', type: 'number', default: '0.7', description: 'Downward pull (−1 to 1).' },
		{ name: 'direction', type: '{ horizontal?: "left"|"center"|"right"; vertical?: "top"|"center"|"bottom" }', default: '{ horizontal: "center", vertical: "top" }' },
		{ name: 'scale', type: '{ value?: number; randomize?: boolean; randomVariation?: number }', default: '{ value: 1 }' },
		{ name: 'rotation', type: '{ value?: number; animate?: boolean }', default: '{ value: 0 }' },
	],
};
