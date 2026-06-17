import { LabelInput } from './label-input.tsrx';

export function Preview() @{
	<>
	<div class="flex w-full max-w-sm flex-col gap-4 p-4">
		<LabelInput label="Email address" type="email" placeholder="you@example.com" />
		<LabelInput label="Password" type="password" placeholder="••••••••" ringColor="primary" />
		<LabelInput label="Username" placeholder="johndoe" ringColor="violet" />
	</div>
	</>
}
