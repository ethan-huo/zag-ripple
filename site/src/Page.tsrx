import { Navigation } from './components/navigation.tsrx';
import { HeroSection } from './components/hero-section.tsrx';
import { HomeModules } from './components/home-modules.tsrx';

export function Page() @{
	<>
	<head>
		<title>{'ZagRipple — Components & animations for Ripple TS'}</title>
	</head>

	<Navigation noSearch />
	<main>
		<HeroSection />
		<HomeModules />
	</main>
	</>
}