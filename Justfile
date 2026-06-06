# tinyland-goo — UV-reactive bed glue project site (static SvelteKit SPA)
# Single authoritative entrypoint. Quick start: just setup && just dev
# Drawn from tinyland-inc/site.scaffold; npm-based for GitHub Pages portability.

set shell := ["bash", "-euo", "pipefail", "-c"]
root := justfile_directory()

# List available recipes
default:
    @just --list --unsorted

# Install dependencies
setup:
    cd {{ root }} && npm install
    @echo "Setup complete. Run 'just dev'."

# Start the dev server
dev:
    cd {{ root }} && npm run dev

# Start the dev server and open a browser
dev-open:
    cd {{ root }} && npm run dev -- --open

# Type-check (svelte-check)
check:
    cd {{ root }} && npm run check

# Production static build. BASE_PATH defaults to the GitHub Pages project path.
build base_path="/tinyland-goo":
    cd {{ root }} && BASE_PATH="{{ base_path }}" npm run build

# Build for local root preview (no base path)
build-local:
    cd {{ root }} && npm run build

# Preview the production build locally (root base)
preview: build-local
    cd {{ root }} && npm run preview

# ─────────────────────────────────────────────
# Conformance & security (site.scaffold static-spoke subset)
# ─────────────────────────────────────────────

# Static-spoke conformance checklist
conformance:
    cd {{ root }} && bash scripts/check-conformance.sh

# Validate the repo manifest parses and declares a static-spoke role
repo-manifest-validate:
    cd {{ root }} && node -e 'const m=require("./tinyland.repo.json"); if(m.taxonomy.primary_role!=="static-spoke"){console.error("primary_role must be static-spoke");process.exit(1)} console.log("tinyland.repo.json OK:",m.repo.github)'

# Gitleaks scan of the working tree
secrets-scan-dir:
    cd {{ root }} && gitleaks dir --config .gitleaks.toml --redact --verbose .

# Gitleaks scan of git history
secrets-scan:
    cd {{ root }} && gitleaks git --config .gitleaks.toml --redact --verbose .

# Cold-landing orientation: what this repo is and its entrypoints
whoami:
    @echo "tinyland-goo — Tinyland static-spoke (adapter-static -> GitHub Pages)"
    @echo "Deploy:  jesssullivan.github.io/tinyland-goo"
    @echo "Entry:   just <recipe>  (npm; no Nix/Bazel — see AGENTS.md)"

# Pre-push gate: conformance + typecheck + secrets + build
ci: conformance check secrets-scan-dir build-local
    @echo "Local CI passed."

# Remove build artifacts
clean:
    rm -rf {{ root }}/build {{ root }}/.svelte-kit

# Deep clean including node_modules
clean-all: clean
    rm -rf {{ root }}/node_modules
