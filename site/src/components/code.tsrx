
// npm `shiki` (not the esm.sh URL build) so the module is resolvable during SSR.
// codeToHtml still only runs in the client ref callback below.
import { codeToHtml } from 'shiki'
import { cn } from '../lib/utils'

export function Code({code, language, ...rest}:any) @{

	const divRef = async (node) => {
		const html = await codeToHtml(code, {
			lang: language,
			themes: { 
				light: 'min-light',
				dark: 'vitesse-dark',
			  }
		});
		node.innerHTML = html;
	};
    
    <>
    <div ref={divRef} data-code="" {...rest}  />
    </>
}
