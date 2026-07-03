import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig, type Plugin, type PluginOption } from 'vite';

// Skeleton 4.15.2 still ships CSS using Tailwind v3-era `@variant` / `@apply
// variant-*` syntax. Rewrite to Tailwind v4 stable equivalents during transform.
// Lifted from the Tinyland site.scaffold (no external dependency).
function skeletonTailwindV4Compat(): Plugin {
	return {
		name: 'skeleton-tailwind-v4-compat',
		enforce: 'pre',
		transform(code, id) {
			if (id.includes('@skeletonlabs/skeleton') && id.endsWith('.css')) {
				code = code
					.replace(/@variant\s+sm\s*{/g, '@media (min-width: 640px) {')
					.replace(/@variant\s+md\s*{/g, '@media (min-width: 768px) {')
					.replace(/@variant\s+lg\s*{/g, '@media (min-width: 1024px) {')
					.replace(/@variant\s+xl\s*{/g, '@media (min-width: 1280px) {')
					.replace(/@variant\s+2xl\s*{/g, '@media (min-width: 1536px) {')
					.replace(/@variant\s+dark\s*{/g, '.dark & {')
					.replace(/@apply\s+variant-/g, '@apply ');
				return { code, map: null };
			}
		}
	};
}

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
	plugins: [skeletonTailwindV4Compat(), tailwindcss(), sveltekit(), ...analyzePlugins],
	// Web-perf backfeed (TIN-2224). lightningcss ships under vite 8's hard deps,
	// so this adds 0 package.json deps and preserves the 0-prod-dep invariant.
	build: {
		cssMinify: 'lightningcss',
		reportCompressedSize: true,
		chunkSizeWarningLimit: 250
	}
});
