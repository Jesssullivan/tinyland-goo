import { defineConfig } from 'vitest/config';

// Standalone (does NOT extend vite.config.ts) so the SvelteKit/Tailwind plugins
// are not loaded for the pure-logic unit tests under src/**/*.test.ts.
// Vite 8 transforms TypeScript with oxc, whose options have no esbuild-style
// `tsconfigRaw`; Bazel keeps //:unit_tests hermetic with the generated
// src/lib/tsconfig.json (:test_lib_tsconfig) instead.
export default defineConfig({
	test: {
		include: ['src/**/*.{test,spec}.{js,ts}'],
		environment: 'node'
	}
});
