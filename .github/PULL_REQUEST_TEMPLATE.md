## Summary

<!-- One-paragraph description of what this PR changes and why. -->

## Linear

<!-- Optional: Linear ticket(s). Format: TIN-XXX -->

## Validation

- [ ] `just conformance` is green
- [ ] `just check` is green (svelte-check + Flywheel enrollment contract)
- [ ] `just build` is green and the routes render
- [ ] `just scan-endpoints` is clean (no internal cluster endpoints leaked)
- [ ] No new gitleaks findings
- [ ] Skeleton `4.15.2` exact pin preserved (no v5 / prerelease drift)
- [ ] If `tofu/` or the Flywheel binding changed: still public-safe + dormant
      (no real endpoints; `blahaj_installation_id` stays 0)

## Risk

<!-- What could break? What's the rollback path? -->
