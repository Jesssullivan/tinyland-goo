import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

// Project-page base path. On GitHub Pages at jesssullivan.github.io/tinyland-goo
// the deploy workflow sets BASE_PATH=/tinyland-goo; local dev stays at root.
const base = process.env.BASE_PATH ?? '';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	preprocess: [vitePreprocess()],
	compilerOptions: { runes: true },
	kit: {
		adapter: adapter({
			pages: 'build',
			assets: 'build',
			fallback: '404.html',
			precompress: false,
			strict: true
		}),
		paths: { base },
		prerender: { handleHttpError: 'warn' }
	}
};

export default config;
