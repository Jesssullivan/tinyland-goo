# tofu/ — spoke OpenTofu (DORMANT on this personal spoke)

A **declare-only** composition of the GloriousFlywheel `spoke-*` OpenTofu
modules. On this **public personal-account** spoke it is carried
**wired-but-dormant** and **apply-incapable by construction** — no secrets, no
real hostnames, no state-backend endpoint are committed.

## Public-safe posture

- `blahaj_installation_id = 0` → the `blahaj_app_install` module never
  instantiates (`count = 0`).
- `gf_modules_source` defaults to a public-safe placeholder
  (`git::ssh://git@github.com/ORG/REPO.git//tofu/modules`); the concrete private
  path is **operator-injected** via a gitignored `*.auto.tfvars.local` on an
  apply-capable host — never committed.
- `ingress_target = ingress.invalid` (placeholder); no real cluster endpoint.
- The S3 backend endpoint + credentials are **env/operator authority** (`AWS_*`),
  supplied only from a gitignored `.envrc.local` / `*.backend.hcl`. `backend.tf`
  hard-codes none.

## What it would declare (apply-capable operator host only)

`state_namespace`, `cache_quota`, `runner_binding`, `dns_pr_env`, and — when
`blahaj_installation_id > 0` — `blahaj_app_install`. This is a **consumer**
composition: the spoke owns no cluster apply. `owns_gitops_apply` and
`owns_cloudflare_mutation` stay `false` in `tinyland.repo.json`; blahaj owns
admission + apply.

## Recipes

- `just tofu-fmt-check` — laptop-safe format check (the local gate).
- `just tofu-init` / `tofu-plan` / `tofu-apply` — **operator / cluster only**;
  never run here (the module source + backend are unreachable by construction).
