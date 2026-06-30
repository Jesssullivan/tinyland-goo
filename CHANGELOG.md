# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Features

- **Flywheel uplift (site.scaffold derivation).** Migrated from a thin npm
  static leaf to a full scaffold-posture spoke: pnpm + local Nix devshell,
  public-safe internal-endpoint leak gate, toolchain-only Bazel module-graph
  proof (sha-pinned registry), a dormant endpoint-free GloriousFlywheel binding,
  self-contained CI (deploy stays on pinned Node), a scrubbed declare-only
  `tofu/` + single-lane `lanes.json`, and `scaffold_tag` provenance + an SBOM
  recipe. The org-only surfaces are carried wired-but-dormant; the GitHub Pages
  deploy and the bed-glue / chain-wax / hair-removal-wax content are unchanged.
