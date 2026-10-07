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
- Skeleton 5.0.1 pinned exact (RP1, TIN-5694); Tailwind v4 with no compat
  shim (the Skeleton 4 `skeletonTailwindV4Compat()` transform is deleted and
  stays deleted). Do not remove `static/.nojekyll`.
- `just check` (svelte-check), `just conformance` (static-spoke checklist),
  `just secrets-scan-dir` (gitleaks).
- Repo: https://github.com/Jesssullivan/tinyland-goo
