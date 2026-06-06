# Claude — tinyland-goo

This is the `tinyland-goo` static project site. Read `AGENTS.md` first for the
authoritative operating contract.

Quick reminders:

- Use `just <recipe>` for every operation — do not invoke npm/vite directly
  unless extending the Justfile.
- Static SvelteKit **adapter-static** → **GitHub Pages**
  (`jesssullivan.github.io/tinyland-goo`). No runtime, no Nix, no Bazel — see
  `AGENTS.md` §Declined surfaces for the rationale (conforms to the
  site.scaffold static-spoke subset, intentionally thin).
- Skeleton 4.15.2 pinned exact; Tailwind v4 with the `skeletonTailwindV4Compat()`
  shim in `vite.config.ts`. Do not remove it or `static/.nojekyll`.
- `just check` (svelte-check), `just conformance` (static-spoke checklist),
  `just secrets-scan-dir` (gitleaks).
- Repo: https://github.com/Jesssullivan/tinyland-goo
