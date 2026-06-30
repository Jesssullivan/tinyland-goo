# Agent Notes — tinyland-goo

Working contract for coding agents and LLMs operating in this repo. **Spawned
from** the `tinyland-inc/site.scaffold` contract (static-spoke subset; original
spawn 2026-06-06), **scaffold tag `v0.1.0`** (`tinyland.repo.json`
`.scaffold_tag`). As of **2026-06-29** this leaf was **uplifted to the full
scaffold posture** — pnpm + Nix + toolchain-only Bazel + an endpoint-free
GloriousFlywheel binding + public-safe `tofu/`/lanes — with the org-only
surfaces carried **wired-but-dormant** (see *Personal posture*). The canonical
build (`pnpm run build`) + GitHub Pages deploy target are unchanged; the publish
job runs it through the **Nix devshell** (`nix develop --command just build`) —
CI == local == deploy, the house default deploy lane (TIN-2230).

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
- **Toolchain**: **pnpm** (pinned via `packageManager` in `package.json`) inside
  a Nix `flake.nix`/`direnv` devshell (`nix develop`). The devshell backs local
  dev, **CI, and the Pages publish job** alike — every CI + deploy step runs
  `nix develop --command just <recipe>`, so **CI == local == deploy** (the house
  default; `cachix/install-nix-action@v31` on the runners). `.nvmrc` is a local
  convenience only; the publish path no longer pins Node directly.
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

## Deploy — GitHub Pages, the house default deploy lane

This spoke deploys to **GitHub Pages** under the personal `Jesssullivan`
account (`jesssullivan.github.io/tinyland-goo`), via
`.github/workflows/deploy-pages.yml` (`actions/deploy-pages` on `build/`). The
build job runs **through the Nix devshell** (`cachix/install-nix-action@v31` +
`nix develop --command just build`) on a GitHub-hosted runner — this is the
canonical **House DEFAULT deploy lane** (TIN-2230 Option A), the same Nix path
the canonical `site.scaffold` and the live cousin `formal_transfemme_sewing`
use. (An earlier revision wrongly built on pinned Node + corepack pnpm; that was
a self-inflicted divergence, not a sanctioned exception — the only pinned-Node
precedent, `jesssullivan.github.io`, is legacy non-scaffold lineage.)

Other Tinyland spokes (darkmap, software.tinyland.dev) deploy to **Vercel** or a
container/K8s target; adapter-static → GitHub Pages is the house default for a
static leaf — no runtime, no edge, no vendor credentials. There is no
`static/CNAME` (the Pages route is the canonical URL) and `static/.nojekyll` is
required so `_app/` assets are served.

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
  chain on `tinyland-inc/bazel-registry/**main**` (matching the fleet — the
  canonical scaffold, the hub, and the cousin all track main) is exercised via
  `just bazel-graph` as a gated proof. (TIN-2235 is an *upstream* append-only
  registry guard + lock re-cut, **not** a consumer-side sha-pin — an earlier
  revision miscited it to pin a sha and was the lone fleet outlier.)
- **Nix flake + direnv — local dev, CI, AND the Pages publish path.** Cross-spoke
  toolchain homogeneity + `CI == local == deploy` is the stated goal, so every CI
  and deploy step runs `nix develop --command just <recipe>` (the house default).
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

- **GloriousFlywheel RBE/cache binding — dormant by economics, NOT by re-home.**
  `.bazelrc.flywheel` (endpoint-free) + `scripts/gloriousflywheel-bazel.sh` (the
  **only** endpoint authority) + the `just flywheel-*` recipes are present but
  inert; `enrollment.substrateMode = compatibility-local-only`, so
  `just flywheel-doctor` fail-fasts honestly. **Attach does NOT require
  re-homing** under `tinyland-inc`: a personal Jesssullivan repo enrolls as a
  first-class GloriousFlywheel consumer via the **`jesssullivan-infra` operator
  overlay** (an ARC `extra_runner_sets` anchor in the personal account + a
  one-PR consumer-registry line in the `tinyland-inc/GloriousFlywheel` org repo
  that *records* the repo, does not move it) plus a **GitHub-OIDC →
  gf-reapi token exchange** (TIN-2219). NB: that overlay is **ARC / OpenTofu /
  IAM**, *not* a "bzlmod overlay" — never add a `jesssullivan` or
  `@gloriousflywheel` Bazel registry or `bazel_dep` (no such module exists; the
  framing was retired by ADR `2026-06-consumer-latch.md` and it breaks config
  load). It stays dormant here for two honest reasons: (a) the cache/RBE **data
  plane** is **cluster-internal** (a gRPC service reachable only inside the
  cluster network), so a hosted runner mints a token but cannot reach it —
  a real cache hit needs CI on the in-cluster `tinyland-nix` ARC lane; and (b)
  Bazel is toolchain-only and never builds the site (`pnpm run build` does), so
  the realized build win is **~nil**. The post-enrollment baseline is
  `shared-cache-backed` (executor-backed is GF-dogfood-first). `just
  cache-contract-strict` is **opt-in** (not in `just check`). Never write raw
  `--remote_cache=` / `--remote_executor=` endpoints — the wrapper contract is
  endpoint-free (conformance item 7 + `just scan-endpoints` enforce this).
- **CI runs through the Nix devshell (CI == local == deploy).**
  `.github/workflows/ci.yml` runs every gate via `nix develop --command just
  <recipe>` (secrets + internal-endpoint scan + conformance + check + build),
  with a `bazel-graph` job (Nix) and a `flywheel` job that is gated on
  `vars.FLYWHEEL_ENABLED` and `runs-on: tinyland-nix` (the in-cluster ARC lane
  where the cache is reachable). The org `tinyland-inc/ci-templates@vX` reusable
  workflows are not consumed (a personal repo's `uses:` reach is a separate
  GitHub-permissions question from cache-attach, which the OIDC exchange
  dissolves); this is documented **MANUAL drift** from conformance item 2. The
  Pages **deploy** also runs through the Nix devshell — no pinned-Node divergence.
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
