#!/usr/bin/env bash
# Static-spoke conformance check for tinyland-goo.
#
# A deliberately trimmed subset of the site.scaffold conformance harness — only
# the items that apply to a no-Bazel, no-Nix, GitHub-Pages static spoke. See
# AGENTS.md §Declined surfaces for what is intentionally omitted.
#
# Usage: scripts/check-conformance.sh   (exit 0 = pass, 1 = fail)

set -euo pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT"

pass=0; fail=0
ok() { printf "  \xe2\x9c\x93 %s\n" "$1"; pass=$((pass+1)); }
no() { printf "  \xe2\x9c\x97 %s\n" "$1"; fail=$((fail+1)); }

echo "Static-spoke conformance (tinyland-goo)"
echo

# 0. repo manifest exists, parses, declares static-spoke, secrets_scan=gitleaks
if [[ -f tinyland.repo.json ]]; then
  if node -e 'const m=require("./tinyland.repo.json");
    if(m.taxonomy.primary_role!=="static-spoke")process.exit(3);
    if(m.contracts.secrets_scan!=="gitleaks")process.exit(4);
    if(Object.entries(m.boundaries).filter(([k])=>k!=="owns_static_projection_ingest").some(([,v])=>v!==false))process.exit(5);
    ' 2>/dev/null; then
    ok "tinyland.repo.json: static-spoke role, gitleaks, backend boundaries all false"
  else
    no "tinyland.repo.json present but fails static-spoke invariants (role/secrets_scan/boundaries)"
  fi
else
  no "tinyland.repo.json is missing"
fi

# 1. AGENTS.md + CLAUDE.md present, and AGENTS.md cites the scaffold contract
if [[ -f AGENTS.md ]] && grep -qE 'site\.scaffold' AGENTS.md && grep -qiE 'conforms to|spawned' AGENTS.md; then
  ok "AGENTS.md cites the site.scaffold contract"
else
  no "AGENTS.md must exist and cite the site.scaffold contract"
fi
[[ -f CLAUDE.md ]] && ok "CLAUDE.md present" || no "CLAUDE.md is missing"

# 2. gitleaks baseline extends the default ruleset
if [[ -f .gitleaks.toml ]] && grep -qE '^\[extend\]' .gitleaks.toml && grep -qE 'useDefault[[:space:]]*=[[:space:]]*true' .gitleaks.toml; then
  ok ".gitleaks.toml extends the default ruleset"
else
  no ".gitleaks.toml must extend the default gitleaks ruleset"
fi

# 3. Justfile exposes working-tree and git-history gitleaks scans
if [[ -f Justfile ]] && grep -qE '^secrets-scan-dir:' Justfile && grep -qE '^secrets-scan:' Justfile; then
  ok "Justfile exposes secrets-scan-dir and secrets-scan"
else
  no "Justfile must expose secrets-scan-dir and secrets-scan recipes"
fi

# 4. adapter-static (this spoke is genuinely static)
if grep -qE 'adapter-static' svelte.config.js 2>/dev/null; then
  ok "svelte.config.js uses adapter-static"
else
  no "svelte.config.js must use @sveltejs/adapter-static"
fi

# 5. GitHub Pages hygiene: .nojekyll present, no CNAME claim
[[ -f static/.nojekyll ]] && ok "static/.nojekyll present" || no "static/.nojekyll is required for GitHub Pages"
if [[ -f static/CNAME ]]; then
  no "static/CNAME present — this spoke serves at the Pages route, no custom domain"
else
  ok "no static/CNAME (Pages route is canonical)"
fi

# 6. Pages deploy workflow present
if [[ -f .github/workflows/deploy-pages.yml ]] && grep -qE 'actions/deploy-pages' .github/workflows/deploy-pages.yml; then
  ok ".github/workflows/deploy-pages.yml uses actions/deploy-pages"
else
  no ".github/workflows/deploy-pages.yml must deploy via actions/deploy-pages"
fi

# 7. Bazel is adopted as the dependency-SSOT / module-graph integrity proof
# (toolchain-only; the canonical site build stays pnpm/vite, never on deploy).
# Assert the binding is endpoint-free — no raw remote cache/executor endpoints in
# .bazelrc / .bazelrc.flywheel (endpoint authority lives only in the wrapper) —
# and that the registry is pinned to an IMMUTABLE commit sha, not main/.
if [[ -f MODULE.bazel ]]; then
  if grep -hnE '(--remote_cache=|--remote_executor=)' .bazelrc .bazelrc.flywheel 2>/dev/null | grep -qvE '^[[:space:]]*#'; then
    no "raw --remote_cache=/--remote_executor= endpoint in .bazelrc(.flywheel) — must stay endpoint-free (wrapper-only)"
  elif grep -qE 'bazel-registry/[0-9a-f]{40}/' .bazelrc 2>/dev/null; then
    ok "Bazel adopted (toolchain-only); registry pinned to an immutable sha; rc files endpoint-free"
  else
    no ".bazelrc must pin tinyland-inc/bazel-registry to an immutable commit sha (not main/)"
  fi
else
  ok "no Bazel files (Bazel intentionally not adopted)"
fi

# 8. Public-safe: no internal cluster endpoints / hostnames leak into the tree.
# gitleaks only catches token shapes; this guards the private blahaj / tool-bus
# topology (and slug-correctness on tofu/) before any org-only fragment is copied.
if [[ -f scripts/scan-internal-endpoints.sh ]] && bash scripts/scan-internal-endpoints.sh >/dev/null 2>&1; then
  ok "no internal cluster endpoints/hostnames in tree (public-safe scan)"
else
  no "internal cluster endpoint/hostname leak — run scripts/scan-internal-endpoints.sh"
fi

echo
echo "summary: ${pass} pass, ${fail} fail"
(( fail == 0 ))
