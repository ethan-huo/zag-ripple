import type { ComponentEntry } from '@/modules/types';
import { Preview } from './preview.tsrx';
import previewCode from './preview.tsrx?raw';
import source from './dither-shader.tsrx?raw';

export const data: ComponentEntry = {
	id: 'dither-shader',
	title: 'Dither Shader',
	description:
		'Canvas-based image dithering with Bayer, halftone, noise, and crosshatch patterns, multiple color modes, and optional animation.',
	group: 'Effects',
	preview: Preview,
	previewCode,
	source: [{ filename: 'dither-shader.tsrx', code: source, lang: 'tsx' }],
	props: [
		{ name: 'src', type: 'string', required: true, description: 'Source image URL.' },
		{ name: 'gridSize', type: 'number', default: '4', description: 'Size of dithering grid cells.' },
		{
			name: 'ditherMode',
			type: '"bayer" | "halftone" | "noise" | "crosshatch"',
			default: '"bayer"',
			description: 'Dithering pattern algorithm.',
		},
		{
			name: 'colorMode',
			type: '"original" | "grayscale" | "duotone" | "custom"',
			default: '"original"',
			description: 'Color processing mode.',
		},
		{ name: 'invert', type: 'boolean', default: 'false', description: 'Invert output colors.' },
		{
			name: 'pixelRatio',
			type: 'number',
			default: '1',
			description: 'Pixelation multiplier (higher = blockier).',
		},
		{ name: 'primaryColor', type: 'string', default: '"#000000"', description: 'Primary color for duotone mode.' },
		{
			name: 'secondaryColor',
			type: 'string',
			default: '"#ffffff"',
			description: 'Secondary color for duotone mode.',
		},
		{
			name: 'customPalette',
			type: 'string[]',
			default: '["#000000","#ffffff"]',
			description: 'Custom color palette for custom mode.',
		},
		{
			name: 'brightness',
			type: 'number',
			default: '0',
			description: 'Brightness adjustment (−1 to 1).',
		},
		{
			name: 'contrast',
			type: 'number',
			default: '1',
			description: 'Contrast adjustment (0 to 2, 1 = normal).',
		},
		{
			name: 'backgroundColor',
			type: 'string',
			default: '"transparent"',
			description: 'Canvas background color.',
		},
		{
			name: 'objectFit',
			type: '"cover" | "contain" | "fill" | "none"',
			default: '"cover"',
			description: 'Image fit behavior.',
		},
		{
			name: 'threshold',
			type: 'number',
			default: '0.5',
			description: 'Threshold bias for dithering (0 to 1).',
		},
		{ name: 'animated', type: 'boolean', default: 'false', description: 'Enable noise animation.' },
		{
			name: 'animationSpeed',
			type: 'number',
			default: '0.02',
			description: 'Animation speed (lower = slower).',
		},
		{ name: 'class', type: 'string', description: 'Additional CSS classes for the container.' },
	],
};
