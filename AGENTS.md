# Agent Notes — tinyland-goo

Working contract for coding agents and LLMs operating in this repo. **Spawned
from** the `tinyland-inc/site.scaffold` contract (static-spoke subset; original
spawn 2026-06-06), **scaffold tag `v0.1.0`** (`tinyland.repo.json`
`.scaffold_tag`). As of **2026-06-29** this leaf was **uplifted to the full
scaffold posture** — pnpm + Nix + toolchain-only Bazel + an endpoint-free
GloriousFlywheel binding + public-safe `tofu/`/lanes — with the org-only
surfaces carried **wired-but-dormant** (see *Personal posture*). The canonical
build + GitHub Pages deploy are unchanged.

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
- **Check**: `just check` runs `svelte-check` + the Flywheel enrollment
  contract. `just conformance` runs the 16-item scaffold conformance checklist;
  `just scaffold-doctor` adds the authority-boundary audit.
- **Secrets**: `just secrets-scan-dir` (working tree) / `just secrets-scan`
  (git history) via gitleaks. **Public-safe internal-endpoint scan**:
  `just scan-endpoints` (also conformance item 16) blocks internal cluster
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

## Adopted scaffold surfaces (overturning the prior "Declined" stance)

As of **2026-06-29** this leaf was uplifted from a deliberately-thin npm static
page to the **full scaffold posture**. The earlier "Declined surfaces" stance
(Bazel/Nix/Flywheel/tofu as "pure maintenance cost") is **deliberately
overturned** on house bazel-first / remote-everything fluency grounds:

- **Bazel — dependency SSOT / module-graph integrity proof (toolchain-only).**
  Bazel does **not** build the site — the canonical build stays `pnpm run build`
  (adapter-static), never on the deploy critical path. A toolchain-only
  `MODULE.bazel` (no `@tummycrypt/*` deps; 0 production deps) with the registry
  pinned to an **immutable** `tinyland-inc/bazel-registry` commit sha (not
  `main/`, per TIN-2235) is exercised via `just bazel-graph` as a gated proof.
- **Nix flake + direnv — local dev + non-deploy CI only.** Cross-spoke toolchain
  homogeneity + `CI == local` on low-power machines is now the stated goal. Nix
  is **never** on the GitHub Pages publish path (pinned Node + corepack pnpm).
- **GloriousFlywheel binding + `tofu/` + `.github/lanes.json` — wired-but-DORMANT.**
  Carried for house parity + a one-flip activation path; see *Personal posture*
  below for exactly how dormancy is encoded (no secrets, no live endpoints).

**Still declined** (genuinely N/A for a static GitHub Pages leaf): a runtime
backend, `adapter-node`, `/api/*` routes, `Containerfile` / Kustomize, and the
Vercel / container / K8s deploy targets other Tinyland spokes use. This spoke
has no runtime; `tinyland.repo.json` records every `owns_*` boundary as `false`.

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
- **Self-contained CI (no `ci-templates` reusable workflows).** A personal repo
  cannot reach the org `tinyland-inc/ci-templates@vX` reusable workflows, so
  `.github/workflows/ci.yml` runs a self-equivalent **Node + pnpm** gate
  (secrets + internal-endpoint scan + conformance + typecheck + Flywheel contract
  + build), with the `bazel-graph` job gated to non-PR events and the `flywheel`
  job gated on `vars.FLYWHEEL_ENABLED`. This is documented **MANUAL drift** from
  conformance item 2 (ci-templates SemVer pin); the re-home path is
  `tinyland-inc/ci-templates@v2.8.0`, referenced but deliberately not wired. The
  Pages **deploy** stays on pinned Node + corepack pnpm — no Nix on the publish
  path.
- **`tofu/` (declare-only spoke composition) + `.github/lanes.json`.** A thin
  public-safe `tofu/` composes the GloriousFlywheel `spoke-*` modules through a
  `gf_modules_source` variable (placeholder default; the concrete private path is
  operator-injected via a gitignored `*.auto.tfvars.local`), with
  `blahaj_installation_id = 0` (the `blahaj_app_install` module never
  instantiates), `ingress_target = ingress.invalid`, and an endpoint-free S3
  backend. `owns_gitops_apply` / `owns_cloudflare_mutation` stay `false` — blahaj
  owns admission + apply. Only `just tofu-fmt-check` is laptop-safe; **never** run
  `just tofu-init/plan/apply` here (the module source + backend are unreachable by
  construction). `.github/lanes.json` carries a single required `default` lane; no
  `repository_dispatch` into blahaj is wired. Only the `lanes` + repo-manifest
  schemas are vendored (`docs/schemas/`); the blahaj/reap/public-preview dispatch
  schemas are deliberately NOT carried.

## What not to do

- Don't call `npm`/`vite` outside the Justfile (add a recipe instead).
- Don't add runtime/server code, secrets, or vendor credentials — this is static.
- Don't remove the Skeleton v4 compat shim or `static/.nojekyll`.
- Don't introduce raw `--remote_cache=` / `--remote_executor=` endpoints
  anywhere — the GloriousFlywheel wrapper contract is endpoint-free (the only
  endpoint authority is `scripts/gloriousflywheel-bazel.sh`).
- Don't run `just tofu-init/plan/apply` or commit live endpoints/creds — the
  `tofu/` tree is dormant + apply-incapable here; live values belong only in the
  gitignored escape-hatch files (`.envrc.local`, `*.auto.tfvars.local`, ...).
