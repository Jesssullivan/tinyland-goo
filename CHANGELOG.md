# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Changed

- **RU1 stack uplift (SvelteKit 3, TypeScript 7).** Exact pins: `@sveltejs/kit`
  3.0.1, `svelte` 5.57.2, `vite` 8.3.3, `typescript` 7.0.2, `vitest` and
  `@vitest/coverage-v8` 5.0.3, `@sveltejs/adapter-static` 4.0.0,
  `@sveltejs/vite-plugin-svelte` 7.3.1, `svelte-check` 4.7.6 (Skeleton 5.0.1
  unchanged). Kit 3 migration: `svelte.config.js` is gone and its config moves
  into `sveltekit({...})` in `vite.config.ts`; `$lib` imports become `#lib/...`
  (package.json `imports`); `base` from `$app/paths` becomes `resolve()`;
  tsconfig extends `$app/tsconfig` with an explicit `include`. Type checking is
  `svelte-check --tsgo` on TypeScript 7.0.2 (RU13), with the shared patch set
  (`patches/`, `.pnpmfile.cjs`) copied unchanged from site.scaffold. Bazel: Node
  22.22.0 (Kit 3 needs >= 22.17), `aspect_rules_ts` 3.10.1 with TypeScript
  7.0.2, a `--tsgo` canary test, and the build smoke copies inputs as real
  files (Node 22.22 `cpSync` nested-symlink EROFS). No forms or server data, so
  no remote functions; no in-house packages, so no `bazel_dep` links.
- `vitest.config.ts` drops the esbuild-era `oxc.tsconfigRaw` block, which Vite 8's
  oxc options do not accept (it now fails type checking); the Bazel unit test
  stays hermetic through the generated `src/lib/tsconfig.json`.

### Features

- **Flywheel uplift (site.scaffold derivation).** Migrated from a thin npm
  static leaf to a full scaffold-posture spoke: pnpm + local Nix devshell,
  public-safe internal-endpoint leak gate, toolchain-only Bazel module-graph
  proof (sha-pinned registry), a dormant endpoint-free GloriousFlywheel binding,
  self-contained CI (deploy stays on pinned Node), a scrubbed declare-only
  `tofu/` + single-lane `lanes.json`, and `scaffold_tag` provenance + an SBOM
  recipe. The org-only surfaces are carried wired-but-dormant; the GitHub Pages
  deploy and the bed-glue / chain-wax / hair-removal-wax content are unchanged.
