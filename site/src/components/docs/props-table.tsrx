import type { PropRow } from '@/modules/types';

export function PropsTable({ rows }: { rows: PropRow[] }) @{
	<>
	<div class="overflow-x-auto rounded-lg border border-border">
		<table class="w-full text-left text-sm">
			<thead class="bg-muted/40 text-muted-foreground">
				<tr>
					<th class="px-4 py-2 font-medium">{'Prop'}</th>
					<th class="px-4 py-2 font-medium">{'Type'}</th>
					<th class="px-4 py-2 font-medium">{'Default'}</th>
				</tr>
			</thead>
			<tbody>
				@for (const row of rows) {
					<tr class="border-t border-border align-top">
						<td class="whitespace-nowrap px-4 py-2 font-mono text-xs">
							<span class="text-foreground">{row.name}</span>
							@if (row.required) {
								<span class="ml-1 text-destructive">{'*'}</span>
							}
							@if (row.description) {
								<div class="mt-1 font-sans text-xs text-muted-foreground">
									{row.description}
								</div>
							}
						</td>
						<td class="px-4 py-2 font-mono text-xs text-primary">{row.type}</td>
						<td class="whitespace-nowrap px-4 py-2 font-mono text-xs text-muted-foreground">
							{row.default ?? '—'}
						</td>
					</tr>
				}
			</tbody>
		</table>
	</div>
	</>
}
