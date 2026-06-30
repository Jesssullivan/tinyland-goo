import { sveltekit } from '@sveltejs/kit/vite';
import tailwindcss from '@tailwindcss/vite';
import { defineConfig, type Plugin } from 'vite';

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

export default defineConfig({
	plugins: [skeletonTailwindV4Compat(), tailwindcss(), sveltekit()],
	// Web-perf backfeed (TIN-2224). lightningcss ships under vite 8's hard deps,
	// so this adds 0 package.json deps and preserves the 0-prod-dep invariant.
	build: {
		cssMinify: 'lightningcss',
		reportCompressedSize: true,
		chunkSizeWarningLimit: 250
	}
});
