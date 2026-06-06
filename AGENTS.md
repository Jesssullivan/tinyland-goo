# Agent Notes — tinyland-goo

Working contract for coding agents and LLMs operating in this repo. Conforms to
the `tinyland-inc/site.scaffold` repo contract (static-spoke subset); spawned
2026-06-06. This is the deliberately-thin leaf variant — read the **Declined
surfaces** section before reaching for Bazel, Nix, or Flywheel.

## Repo Role

A **static brand/project site under the Tinyland enterprise** — a single
project page for a UV-reactive 3D-printer bed glue (recipe + interactive
scaler), an off-the-shelf UV coverage-sensing BOM, and a Klipper pre-print gate.
It is **not** an application backend: no user data, auth, payments, business
logic, or runtime API routes. `tinyland.repo.json` records this honestly
(every `owns_*` boundary is `false`).

## Authoritative Entrypoints

- **DX/AX**: `Justfile` is the single source of truth. Invoke through
  `just <recipe>`; do not call `npm` / `vite` directly outside the Justfile
  unless adding a recipe.
- **Toolchain**: npm + `.nvmrc` (Node 22). No Nix devshell, no `direnv` — see
  Declined surfaces. CI uses `actions/setup-node` against `.nvmrc`.
- **Build**: `just build` runs `npm run build` (SvelteKit **adapter-static**)
  and emits a fully static, prerendered site in `build/`. `BASE_PATH` sets the
  GitHub Pages project base (`/tinyland-goo`); `just build-local` builds at root.
- **Check**: `just check` runs `svelte-check`. `just conformance` runs the
  static-spoke conformance checklist.
- **Secrets**: `just secrets-scan-dir` (working tree) / `just secrets-scan`
  (git history) via gitleaks.

## Deploy — GitHub Pages (intentional divergence)

This spoke deploys to **GitHub Pages** under the personal `Jesssullivan`
account (`jesssullivan.github.io/tinyland-goo`), via
`.github/workflows/deploy-pages.yml` (`actions/deploy-pages` on `build/`).

Note: other Tinyland spokes (darkmap, software.tinyland.dev, tummycrypt.dev-site)
deploy to **Vercel** or a container/K8s target. GitHub Pages is a deliberate
choice for this leaf project page — it needs no runtime, no edge, and no vendor
credentials. There is no `static/CNAME` (the Pages route is the canonical URL)
and `static/.nojekyll` is required so `_app/` assets are served.

## Theme & Skeleton

- **Skeleton 4.15.2** (pinned exact). Do not upgrade casually.
- Tailwind v4 + the `skeletonTailwindV4Compat()` shim in `vite.config.ts`
  rewrites `@variant` / `@apply variant-` to stable equivalents. Do not remove.
- The omux house theme is vendored at `src/lib/styles/themes/omux.css`
  (from site.scaffold). Dark mode is the `data-mode` attribute set by the FOUC
  script in `src/app.html`.

## Declined surfaces (and why)

These site.scaffold/darkmap surfaces are intentionally **not** adopted; this is
documented conformance, not drift:

- **Bazel + `.bazelrc.flywheel` + RBE/GloriousFlywheel.** Across every Tinyland
  spoke the canonical build is `vite build` — Bazel/RBE is an optional CI cache
  accelerator, never on the static build's critical path. For a leaf `vite`
  build it is pure maintenance cost with no deploy-path benefit. RBE is N/A.
- **Nix flake + direnv.** npm + `.nvmrc` is adequate and simpler here; adopt a
  flake only if cross-spoke toolchain homogeneity becomes a stated goal.
- **OpenTofu / Kustomize / Containerfile / adapter-node / `/api/*` routes.**
  No runtime — this is a static site.
- **`lanes.json` / Blahaj ephemeral envs / ci-templates `spoke-ci`.** No
  multi-lane preview or cluster runner need; CI is hosted `ubuntu-latest`.

If any of these become warranted, copy them verbatim from
`tinyland-inc/site.scaffold` and update `tinyland.repo.json` (`taxonomy.layers`,
`contracts.nix`) and this section accordingly.

## What not to do

- Don't call `npm`/`vite` outside the Justfile (add a recipe instead).
- Don't add runtime/server code, secrets, or vendor credentials — this is static.
- Don't remove the Skeleton v4 compat shim or `static/.nojekyll`.
- Don't introduce raw `--remote_cache=` / `--remote_executor=` endpoints
  anywhere (endpoint-free wrapper contract); we don't use Bazel here at all.
