# Security policy

This repository is the source for the static lab-notebook site at
<https://jesssullivan.github.io/tinyland-goo/>. The site is purely static — no
server runtime, no user accounts, no inbound data, no analytics, and no vendor
credentials. The org-only infrastructure surfaces it carries (`tofu/`, the
Flywheel binding, lanes) are **dormant and apply-incapable by construction** on
this personal account (see `AGENTS.md` §Personal posture).

## Reporting a vulnerability

Please report security issues via a **private GitHub security advisory**:

<https://github.com/Jesssullivan/tinyland-goo/security/advisories/new>

## Scope

In scope:

- Build / CI supply-chain issues
- Secrets **or internal cluster endpoints** accidentally committed to history
  (the `just scan-endpoints` gate exists to prevent the latter)
- Third-party dependency vulnerabilities affecting the build pipeline

Out of scope:

- Cosmetic / SEO / accessibility issues — please open a normal issue
- DDoS / availability — the site is on GitHub Pages with no privileged routes

## What we won't do

- Bug bounties (no programme yet)
- Public discussion of unfixed issues until a coordinated disclosure date
