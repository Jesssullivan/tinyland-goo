# CI schema — tinyland-goo (personal static spoke)

The abbreviated, spoke-local CI contract. The full org contract lives in
`tinyland-inc/site.scaffold` / `tinyland-inc/ci-templates`; this leaf carries
only what it actually exercises, public-safe.

## Posture

- **Deploy:** GitHub Pages (`adapter-static`), pinned Node + corepack pnpm. No
  Nix on the publish path.
- **CI (`.github/workflows/ci.yml`):** a self-contained Node gate — secrets +
  internal-endpoint scan + conformance + typecheck + Flywheel enrollment
  contract + build. `bazel-graph` is gated to non-PR events; `flywheel` is gated
  on `vars.FLYWHEEL_ENABLED` (dormant).
- **Bazel:** toolchain-only module-graph integrity proof; registry pinned to an
  immutable commit sha. The site build is pnpm/vite, never Bazel.
- **Flywheel / tofu / lanes:** carried wired-but-dormant — see `AGENTS.md`
  §Personal posture. `enrollment.substrateMode = compatibility-local-only`
  (no reachable org cache). The live remote-build/cache win is contingent on
  re-homing under `tinyland-inc`.

## §5 endpoint-free wrapper contract

Cache/executor endpoints are runtime env authority, injected only by
`scripts/gloriousflywheel-bazel.sh`. `.bazelrc.flywheel` and every committed
file are endpoint-free; `just scan-endpoints` + conformance enforce it.

## §6 runner classes

`tinyland-nix` only (`.github/lanes.json` `allowed_runner_classes`). Public-repo
CI runs on hosted `ubuntu-latest` (no self-hosted ARC on a personal account).

## §7 ephemeral-env / tofu contract

`tofu/` is declare-only and dormant: `blahaj_installation_id = 0`,
`gf_modules_source` is a placeholder, `ingress_target = ingress.invalid`. No
`repository_dispatch` into blahaj is wired. Only `just tofu-fmt-check` is
laptop-safe.

## §12 conformance checklist

`just conformance` (`scripts/check-conformance.sh`) is the mechanical checklist.
Items requiring org context (org ruleset, required-check config, tailnet DNS,
ci-templates SemVer pin) are reported **MANUAL** on this personal spoke.
`just scaffold-doctor` adds the authority-boundary audit.
