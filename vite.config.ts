import adapter from '@sveltejs/adapter-static';
import { sveltekit } from '@sveltejs/kit/vite';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig, type Plugin, type PluginOption } from 'vite';

// Skeleton is exact-pinned at 5.0.1 (RP1, TIN-5694). The Skeleton 4 era
// skeletonTailwindV4Compat() transform and the skeleton-colors plugin are
// deleted and must not come back: Skeleton 5 emits `@variant` on purpose
// (rewriting `@variant dark` would detach its dark rules from the data-mode
// switcher) and declares every colour-pair token itself.

// Bundle profiling: `ANALYZE=1 pnpm run build` (or `just analyze`) emits an
// interactive treemap at .bundle-stats/stats.html. Loaded lazily at module
// scope so ordinary builds never touch the plugin (it is a devDependency
// only). BUILD_ANALYZE is honored for parity with site.scaffold (TIN-2224).
const analyzePlugins: PluginOption[] = [];
const analyzeRequested =
	process.env.ANALYZE === '1' ||
	process.env.ANALYZE === 'true' ||
	process.env.BUILD_ANALYZE === '1' ||
	process.env.BUILD_ANALYZE === 'true';
if (analyzeRequested) {
	const { visualizer } = await import('rollup-plugin-visualizer');
	analyzePlugins.push(
		visualizer({
			filename: '.bundle-stats/stats.html',
			template: 'treemap',
			gzipSize: true,
			brotliSize: true
		}) as Plugin
	);
}

// NOTE: no manualChunks splitter here — skipped by design. goo's client vendor
// graph is trivial (SvelteKit runtime + Skeleton CSS; no effect/shiki-class
// heavyweights), so the site.scaffold rolldownOptions splitter would create
// empty/no-op chunks. Revisit if a large client-side dependency lands.
export default defineConfig({
	plugins: [
		tailwindcss(),
		// SvelteKit 3 reads its configuration from the sveltekit() plugin;
		// svelte.config.js is no longer supported (RU1, Kit 3.0.1).
		sveltekit({
			preprocess: [vitePreprocess()],
			compilerOptions: { runes: true },
			adapter: adapter({
				pages: 'build',
				assets: 'build',
				fallback: '404.html',
				precompress: false,
				strict: true
			}),
			// Project-page base path. On GitHub Pages at jesssullivan.github.io/tinyland-goo
			// the deploy workflow sets BASE_PATH=/tinyland-goo; local dev stays at root.
			paths: { base: (process.env.BASE_PATH ?? '') as '' | `/${string}` },
			prerender: { handleHttpError: 'warn' }
		}),
		...analyzePlugins
	],
	// Web-perf backfeed (TIN-2224). lightningcss ships under vite 8's hard deps,
	// so this adds 0 package.json deps and preserves the 0-prod-dep invariant.
	build: {
		cssMinify: 'lightningcss',
		reportCompressedSize: true,
		chunkSizeWarningLimit: 250
	}
});
