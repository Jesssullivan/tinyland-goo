import { defineConfig } from 'vitest/config';

// Standalone (does NOT extend vite.config.ts) so the SvelteKit/Tailwind plugins
// are not loaded for the pure-logic unit tests under src/**/*.test.ts.
export default defineConfig({
	test: {
		include: ['src/**/*.{test,spec}.{js,ts}'],
		environment: 'node'
	}
});
