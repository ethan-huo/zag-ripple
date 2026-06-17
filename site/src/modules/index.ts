import type { ComponentEntry, ModuleDef, ModuleId } from './types';
import { spell } from './spell/registry';
import { magic } from './magic/registry';
import { fancy } from './fancy/registry';

export const modules: Record<ModuleId, ModuleDef> = { magic, spell, fancy };

export const moduleList: ModuleDef[] = [magic, spell, fancy];

export function getModule(id: string): ModuleDef | undefined {
	return modules[id as ModuleId];
}

export function getComponent(
	moduleId: string,
	componentId: string,
): ComponentEntry | undefined {
	return getModule(moduleId)?.components.find((c) => c.id === componentId);
}

// Sidebar/landing grouping: preserve registry order within each group.
export function groupComponents(
	mod: ModuleDef,
): { group: string; items: ComponentEntry[] }[] {
	const order: string[] = [];
	const byGroup = new Map<string, ComponentEntry[]>();
	for (const c of mod.components) {
		const g = c.group ?? 'Components';
		if (!byGroup.has(g)) {
			byGroup.set(g, []);
			order.push(g);
		}
		byGroup.get(g)!.push(c);
	}
	return order.map((group) => ({ group, items: byGroup.get(group)! }));
}

export type { ComponentEntry, ModuleDef, ModuleId };
