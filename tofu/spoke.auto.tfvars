# Spoke-specific inputs. Schema: docs/CI-SCHEMA.md §7.
#
# DORMANT on this personal Pages spoke: blahaj_installation_id = 0 (the
# blahaj_app_install module never instantiates) and gf_modules_source defaults
# to a public-safe placeholder. Never run `just tofu-init/plan/apply` here.

spoke_slug   = "tinyland-goo"
brand_domain = "jesssullivan.github.io/tinyland-goo"
github_org   = "Jesssullivan"

# Blahaj GitHub App installation ID. 0 = skip the blahaj_app_install module.
blahaj_installation_id = 0

# Subset of the master runner-class enum the spoke may dispatch to (hard-deny
# enforced operator-side).
allowed_runner_classes = ["tinyland-nix"]

# Stable lane names this spoke pre-creates DNS for. Per-PR lanes use the wildcard.
lane_allowlist = []

# Aggregate cache quota in GiB.
cache_quota_gib = 50

# Cluster ingress CNAME target — PUBLIC-SAFE PLACEHOLDER. The real target is
# operator-injected via a gitignored *.auto.tfvars.local; never committed.
ingress_target = "ingress.invalid"
