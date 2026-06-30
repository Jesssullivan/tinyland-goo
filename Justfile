# tinyland-goo — UV-reactive bed glue project site (static SvelteKit SPA)
# Single authoritative entrypoint. Quick start: just setup && just dev
# Drawn from tinyland-inc/site.scaffold. pnpm inside a Nix devshell (`nix
# develop`); CI and the GitHub Pages publish job run `nix develop --command just
# <recipe>` — CI == local == deploy (the house default deploy lane).

set shell := ["bash", "-euo", "pipefail", "-c"]
root := justfile_directory()

# List available recipes
default:
    @just --list --unsorted

# Install dependencies (frozen lockfile — pnpm is the dependency SSOT)
setup:
    cd {{ root }} && pnpm install --frozen-lockfile
    @echo "Setup complete. Run 'just dev'."

# Start the dev server
dev:
    cd {{ root }} && pnpm run dev

# Start the dev server and open a browser
dev-open:
    cd {{ root }} && pnpm run dev -- --open

# Type-check (svelte-check) + unit tests + prove the Flywheel enrollment contract
check:
    cd {{ root }} && pnpm run check
    cd {{ root }} && pnpm run test:unit
    cd {{ root }} && bash scripts/flywheel-enrollment-contract-test.sh

# Unit tests (vitest, pure-logic; see src/lib/*.test.ts)
test-unit:
    cd {{ root }} && pnpm run test:unit

# Production static build. BASE_PATH defaults to the GitHub Pages project path.
build base_path="/tinyland-goo":
    cd {{ root }} && BASE_PATH="{{ base_path }}" pnpm run build

# Build for local root preview (no base path)
build-local:
    cd {{ root }} && pnpm run build

# Preview the production build locally (root base)
preview: build-local
    cd {{ root }} && pnpm run preview

# ─────────────────────────────────────────────
# Conformance & security (site.scaffold static-spoke subset)
# ─────────────────────────────────────────────

# Static-spoke conformance checklist
conformance:
    cd {{ root }} && bash scripts/check-conformance.sh

# Validate tinyland.repo.json against the vendored schema (needs jsonschema; nix develop)
repo-manifest-validate:
    cd {{ root }} && python3 scripts/validate-lanes.py --schema docs/schemas/tinyland-repo-manifest.schema.json --instance tinyland.repo.json

# Validate .github/lanes.json against the vendored lanes schema
lanes-validate:
    cd {{ root }} && python3 scripts/validate-lanes.py

# Print resolved lanes as a table
lanes-list:
    @cd {{ root }} && jq -r '.lanes[] | [.name, (.trigger // "pull_request"), (.runner_class // "(default)"), (.e2e // false | tostring), .theme] | @tsv' .github/lanes.json | column -t -s $'\t'

# Verify @tummycrypt/@tinyland npm versions match MODULE.bazel (toolchain-only: 0 pkgs)
inhouse-package-parity:
    cd {{ root }} && python3 scripts/check-inhouse-package-parity.py

# Generate local SBOM artifacts under ignored build/sbom/ (syft; via the Nix devshell)
sbom out_dir="build/sbom":
    cd {{ root }} && mkdir -p "{{ out_dir }}" && version="$(jq -r '.version' package.json)" && \
      syft scan dir:. \
        --source-name tinyland-goo \
        --source-version "$version" \
        --exclude './.git/**' \
        --exclude './.direnv/**' \
        --exclude './node_modules/**' \
        --exclude './build/**' \
        --exclude './.svelte-kit/**' \
        --exclude './bazel-*' \
        -o cyclonedx-json="{{ out_dir }}/tinyland-goo.cyclonedx.json" \
        -o spdx-json="{{ out_dir }}/tinyland-goo.spdx.json"

# House-style drift audit: conformance + validations + authority-boundary audit (devshell)
scaffold-doctor:
    @cd {{ root }} && echo "=== Layer 1: checks ===" && \
      just conformance && \
      just repo-manifest-validate && \
      just lanes-validate && \
      just inhouse-package-parity && \
      just scan-endpoints && \
      just secrets-scan-dir && \
      echo "" && echo "=== Layer 3: authority-boundary audit ===" && \
      bash scripts/scaffold-doctor-boundary.sh

# Gitleaks scan of the working tree
secrets-scan-dir:
    cd {{ root }} && gitleaks dir --config .gitleaks.toml --redact --verbose .

# Gitleaks scan of git history
secrets-scan:
    cd {{ root }} && gitleaks git --config .gitleaks.toml --redact --verbose .

# Public-safe: scan the tracked tree for leaked internal cluster endpoints/hostnames
# (catches what gitleaks' token-shape rules miss; also asserts tofu/ slug-correctness)
scan-endpoints:
    cd {{ root }} && bash scripts/scan-internal-endpoints.sh

# ─────────────────────────────────────────────
# Bazel (toolchain-only module-graph integrity proof; site build stays pnpm)
# ─────────────────────────────────────────────

# Prove the dependency/toolchain module graph resolves (gated/optional in CI)
bazel-graph:
    cd {{ root }} && bazelisk mod graph

# Fail if MODULE.bazel.lock drifts from MODULE.bazel + the pinned registry
bazel-lock-verify:
    cd {{ root }} && bazelisk mod graph --lockfile_mode=error >/dev/null && echo "MODULE.bazel.lock in sync"

# ─────────────────────────────────────────────
# GloriousFlywheel (cache-first; executor opt-in). DORMANT on this personal
# spoke: enrollment.substrateMode = compatibility-local-only (no reachable org
# BAZEL_REMOTE_CACHE), so the flywheel-* recipes fail-fast HONESTLY off-cluster.
# Endpoint authority lives ONLY in scripts/gloriousflywheel-bazel.sh;
# .bazelrc.flywheel is endpoint-free. See AGENTS.md §Personal posture.
# ─────────────────────────────────────────────

# Advertised enrollment front door. Does not mint tokens.
flywheel-enroll *args:
    cd {{ root }} && bash scripts/flywheel-enroll.sh {{ args }}

# Cold-landing diagnostic: what env an agent needs before flywheel work.
# Off-cluster (no BAZEL_REMOTE_CACHE) it fail-fasts — the dormant-but-wired proof.
flywheel-doctor:
    cd {{ root }} && bash scripts/flywheel-doctor.sh

# Fail-closed enrollment verifier for agents and CI.
flywheel-verify:
    cd {{ root }} && bash scripts/flywheel-verify.sh

# Prove the advertised enroll/doctor/verify contract stays wired (in `just check`).
flywheel-enrollment-contract-check:
    cd {{ root }} && bash scripts/flywheel-enrollment-contract-test.sh

# OPT-IN (NOT in `just check`): self-verify shared-cache attachment, fail-closed.
# Reads enrollment.substrateMode from tinyland.repo.json as the expected mode;
# compatibility-local-only here, so this is meaningful only post-re-home.
cache-contract-strict:
    cd {{ root }} && \
      GF_BAZEL_SUBSTRATE_MODE="$(jq -r '.enrollment.substrateMode // "shared-cache-backed"' tinyland.repo.json)" \
      GF_BAZEL_RUNNER_LABELS="${GF_BAZEL_RUNNER_LABELS:-tinyland-nix}" \
      bash scripts/cache-attachment-contract.sh --strict

# Validate cache attachment and print Bazel info through the wrapper.
flywheel-info:
    cd {{ root }} && bash scripts/gloriousflywheel-bazel.sh info

# Bazel test via flywheel (defaults to the toolchain check suite).
flywheel-test target="//:ci_validation_suite":
    cd {{ root }} && bash scripts/gloriousflywheel-bazel.sh test {{ target }}

# Cache-first, READ-ONLY remote typecheck (svelte-check). Never selects an
# executor; off-cluster the wrapper fail-fasts honestly. Endpoint stays env auth.
flywheel-check *targets="//:svelte_check_test":
    cd {{ root }} && \
      GF_BAZEL_SUBSTRATE_MODE=shared-cache-backed \
      GF_BAZEL_REMOTE_UPLOAD=false \
      BAZEL_REMOTE_EXECUTOR= \
      bash scripts/gloriousflywheel-bazel.sh test --config=ci-cached {{ targets }}

# Executor-backed RBE check/test (the PROOF lane). Needs an in-cluster executor:
# BAZEL_REMOTE_CACHE + BAZEL_REMOTE_EXECUTOR must be present (the wrapper fails
# fast otherwise). Runs the full validation suite (check + unit + vite-build
# smoke) as remotely-executed actions — the local machine is a thin Bazel driver.
flywheel-executor-check *targets="//:ci_validation_suite":
    cd {{ root }} && \
      GF_BAZEL_SUBSTRATE_MODE=executor-backed \
      GF_BAZEL_REMOTE_UPLOAD=false \
      bash scripts/gloriousflywheel-bazel.sh test --config=flywheel-executor {{ targets }}

# Populate external repos through the same cache/input-authority contract.
flywheel-fetch target="//...":
    cd {{ root }} && bash scripts/gloriousflywheel-bazel.sh fetch {{ target }}

# ─────────────────────────────────────────────
# OpenTofu (declare-only spoke composition; DORMANT — never init/plan/apply here.
# blahaj_installation_id=0; gf_modules_source is a placeholder; see tofu/README.md)
# ─────────────────────────────────────────────

# Laptop-safe format check (the local tofu gate).
tofu-fmt-check:
    cd {{ root }}/tofu && tofu fmt -check -diff

# Validate syntax/types if modules are reachable; else fmt-check is the gate.
tofu-validate:
    @cd {{ root }}/tofu && tofu fmt -check -diff && \
      if tofu init -backend=false -input=false >/dev/null 2>&1; then tofu validate; \
      else echo "[tofu-validate] module fetch unavailable (placeholder source); fmt-check passed"; fi

# OPERATOR / CLUSTER ONLY — never run on this personal spoke (apply-incapable here).
tofu-init:
    cd {{ root }}/tofu && tofu init -upgrade

tofu-plan:
    cd {{ root }}/tofu && tofu plan -out=tfplan

tofu-apply:
    cd {{ root }}/tofu && tofu apply tfplan

# Cold-landing orientation: what this repo is and its entrypoints
whoami:
    @echo "tinyland-goo — Tinyland static-spoke (adapter-static -> GitHub Pages)"
    @echo "Deploy:  jesssullivan.github.io/tinyland-goo"
    @echo "Entry:   just <recipe>  (pnpm; local Nix devshell — see AGENTS.md)"

# Pre-push gate: conformance + typecheck + secrets + build
ci: conformance check secrets-scan-dir build-local
    @echo "Local CI passed."

# Remove build artifacts
clean:
    rm -rf {{ root }}/build {{ root }}/.svelte-kit

# Deep clean including node_modules
clean-all: clean
    rm -rf {{ root }}/node_modules
