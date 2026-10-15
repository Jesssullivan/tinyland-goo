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
- [ ] Skeleton `5.0.1` exact pin preserved (no prerelease drift)
- [ ] RU1 exact pins preserved (Kit 3.0.1, Svelte 5.57.2, Vite 8.3.3,
      TypeScript 7.0.2, vitest 5.0.3); `patches/` matches site.scaffold
- [ ] If `tofu/` or the Flywheel binding changed: still public-safe + dormant
      (no real endpoints; `blahaj_installation_id` stays 0)

## Risk

<!-- What could break? What's the rollback path? -->
