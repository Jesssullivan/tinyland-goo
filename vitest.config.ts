import { defineConfig } from 'vitest/config';

// Standalone (does NOT extend vite.config.ts) so the SvelteKit/Tailwind plugins
// are not loaded for the pure-logic unit tests under src/**/*.test.ts.
export default defineConfig({
	oxc: {
		tsconfigRaw: JSON.stringify({
			compilerOptions: {
				target: 'ES2022',
				module: 'ESNext',
				moduleResolution: 'bundler',
				esModuleInterop: true,
				resolveJsonModule: true,
				strict: true,
				skipLibCheck: true
			}
		})
	},
	test: {
		include: ['src/**/*.{test,spec}.{js,ts}'],
		environment: 'node'
	}
});
