import { mount } from 'ripple';
import { Layout } from './Layout.tsrx';
import './styles/index.css';

mount(Layout, {
	target: document.getElementById('root')!,
});
