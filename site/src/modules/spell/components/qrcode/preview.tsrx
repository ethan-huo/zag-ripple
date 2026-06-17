import { QRCode } from './qrcode.tsrx';

export function Preview() @{
	<>
	<div class="flex flex-col items-center gap-4">
		<QRCode value="https://ripple-ts.com" size={200} />
		<p class="text-sm text-muted-foreground">{'https://ripple-ts.com'}</p>
	</div>
	</>
}
