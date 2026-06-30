# Agent Notes — tinyland-goo

Working contract for coding agents and LLMs operating in this repo. Conforms to
the `tinyland-inc/site.scaffold` repo contract (static-spoke subset); spawned
2026-06-06. This is the deliberately-thin leaf variant — read the **Declined
surfaces** section before reaching for Bazel, Nix, or Flywheel.

## Repo Role

A **static brand/project site under the Tinyland enterprise** — a lab-notebook
style project page for UV-reactive 3D-printer bed glue (recipe + interactive
scaler), an off-the-shelf UV coverage-sensing BOM, and a Klipper pre-print gate,
plus adjacent paraffin-wax research pages for bike chain wax and depilatory wax.
It is **not** an application backend: no user data, auth, payments, business
logic, or runtime API routes. `tinyland.repo.json` records this honestly
(every `owns_*` boundary is `false`).

## Authoritative Entrypoints

- **DX/AX**: `Justfile` is the single source of truth. Invoke through
  `just <recipe>`; do not call `npm` / `vite` directly outside the Justfile
  unless adding a recipe.
- **Toolchain**: **pnpm** (pinned via `packageManager` in `package.json`) + a
  Nix `flake.nix`/`direnv` devshell for **local** dev (`nix develop`). `.nvmrc`
  (Node 22) is retained for the Pages publish job. The GitHub Pages deploy and CI
  build run on **pinned Node + corepack pnpm** — Nix is local-dev-only and never
  on the publish path (see Deploy + Declined surfaces).
- **Build**: `just build` runs `pnpm run build` (SvelteKit **adapter-static**)
  and emits a fully static, prerendered site in `build/`. `BASE_PATH` sets the
  GitHub Pages project base (`/tinyland-goo`); `just build-local` builds at root.
- **Check**: `just check` runs `svelte-check`. `just conformance` runs the
  static-spoke conformance checklist.
- **Secrets**: `just secrets-scan-dir` (working tree) / `just secrets-scan`
  (git history) via gitleaks. **Public-safe internal-endpoint scan**:
  `just scan-endpoints` (also conformance item 8) blocks internal cluster
  hostnames / `grpc://` endpoints / RFC1918 hosts that gitleaks' token-shape
  rules miss — the gate that keeps the private blahaj / tool-bus topology out of
  this public repo. Run it before copying any org-only scaffold fragment.

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

- **Bazel — ADOPTED as the dependency SSOT / module-graph integrity proof
  (toolchain-only, 2026-06-29).** Bazel does **not** build the site — the
  canonical build stays `pnpm run build` (adapter-static), never on the deploy
  critical path. What is adopted is a toolchain-only `MODULE.bazel` (no
  `@tummycrypt/*` deps; this leaf has 0 production deps) with the registry chain
  pinned to an **immutable** `tinyland-inc/bazel-registry` commit sha (not
  `main/`, per TIN-2235), exercised via `just bazel-graph` (`bazelisk mod
  graph`) as a gated/optional proof. The old "pure maintenance cost" stance is
  overturned on house bazel-first / remote-everything fluency grounds. The
  Flywheel RBE/cache binding (`.bazelrc.flywheel` + the wrapper) is wired
  **endpoint-free but DORMANT** — see *Personal posture*; RBE never selects an
  executor for this leaf.
- **Nix flake + direnv — ADOPTED (local dev only, 2026-06-29).** Cross-spoke
  toolchain homogeneity + `CI == local` on low-power machines became the stated
  goal (the original escape clause), so a `flake.nix` devshell now backs local
  development and the non-deploy CI accelerator jobs. It is **not** on the
  GitHub Pages publish path, which stays on pinned Node + corepack pnpm.
- **OpenTofu / Kustomize / Containerfile / adapter-node / `/api/*` routes.**
  No runtime — this is a static site.
- **`lanes.json` / Blahaj ephemeral envs / ci-templates `spoke-ci`.** No
  multi-lane preview or cluster runner need; CI is hosted `ubuntu-latest`.

If any of these become warranted, copy them verbatim from
`tinyland-inc/site.scaffold` and update `tinyland.repo.json` (`taxonomy.layers`,
`contracts.nix`) and this section accordingly.

## Personal posture — dormant org surfaces

This is a **public personal-account** spoke, so org-only surfaces are carried
**wired-but-dormant** — real house parity + a one-flip activation path, with no
secrets and no live endpoints:

- **GloriousFlywheel RBE/cache binding.** `.bazelrc.flywheel` (endpoint-free) +
  `scripts/gloriousflywheel-bazel.sh` (the **only** endpoint authority) + the
  `just flywheel-*` recipes are present but inert. `enrollment.substrateMode` is
  `compatibility-local-only` (no reachable org `BAZEL_REMOTE_CACHE`), so
  `just flywheel-doctor` fail-fasts honestly and the `flywheel-*` recipes do no
  work off-cluster. The live remote-build / cache-first speed win is
  **contingent on re-homing under `tinyland-inc`**, not a property of this repo.
  `just cache-contract-strict` is **opt-in** and deliberately NOT in `just check`
  (it would assert an unattained cache). Never write raw `--remote_cache=` /
  `--remote_executor=` endpoints anywhere — the wrapper contract is endpoint-free
  (conformance item 7 + `just scan-endpoints` enforce this).

## What not to do

- Don't call `npm`/`vite` outside the Justfile (add a recipe instead).
- Don't add runtime/server code, secrets, or vendor credentials — this is static.
- Don't remove the Skeleton v4 compat shim or `static/.nojekyll`.
- Don't introduce raw `--remote_cache=` / `--remote_executor=` endpoints
  anywhere (endpoint-free wrapper contract); we don't use Bazel here at all.
