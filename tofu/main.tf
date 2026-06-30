# tinyland-goo spoke infrastructure composition (DECLARE-ONLY; dormant here).
#
# Composes the five GloriousFlywheel spoke-facing OpenTofu modules. The concrete
# private module source is PUBLIC-SAFE-ABSTRACTED behind var.gf_modules_source
# (placeholder default below); an apply-capable operator host injects the real
# path via a gitignored *.auto.tfvars.local. The spoke owns NO cluster apply —
# blahaj owns admission + apply. See docs/CI-SCHEMA.md and tofu/README.md.

variable "gf_modules_source" {
  description = "Base source for the GloriousFlywheel spoke-* OpenTofu modules. PUBLIC-SAFE PLACEHOLDER default — the concrete private path is operator-injected via a gitignored *.auto.tfvars.local on an apply-capable host. Never committed."
  type        = string
  default     = "git::ssh://git@github.com/ORG/REPO.git//tofu/modules"
}

variable "gf_modules_ref" {
  description = "Git ref (version tag) for the spoke-* modules."
  type        = string
  default     = "spoke-tofu-modules-v1.0.0"
}

variable "spoke_slug" {
  description = "Spoke slug (matches .github/lanes.json spoke.name)."
  type        = string
}

variable "brand_domain" {
  description = "Spoke brand domain (matches .github/lanes.json spoke.domain)."
  type        = string
}

variable "github_org" {
  description = "GitHub account/org that owns the spoke repo."
  type        = string
  default     = "Jesssullivan"
}

variable "blahaj_installation_id" {
  description = "Blahaj GitHub App installation ID. 0 = skip blahaj wiring (dormant)."
  type        = number
  default     = 0
}

variable "allowed_runner_classes" {
  description = "Runner classes the spoke may dispatch to (subset of the CI-SCHEMA §6 enum)."
  type        = list(string)
  default     = ["tinyland-nix"]
}

variable "lane_allowlist" {
  description = "Stable lane names that pre-create DNS (merge_main / release_tag lanes)."
  type        = list(string)
  default     = []
}

variable "cache_quota_gib" {
  description = "Aggregate cache quota in GiB."
  type        = number
  default     = 50
}

variable "ingress_target" {
  description = "Cluster ingress CNAME target for wildcard PR-env DNS. PUBLIC-SAFE PLACEHOLDER here (ingress.invalid); operator-injected via *.auto.tfvars.local."
  type        = string
}

locals {
  github_repository = "${var.github_org}/${var.spoke_slug}"
  modules_source    = var.gf_modules_source
  modules_ref       = var.gf_modules_ref
}

module "state_namespace" {
  source     = "${local.modules_source}/spoke-state-namespace?ref=${local.modules_ref}"
  spoke_slug = var.spoke_slug

  # Operator-managed inputs are set after the install completes; leave defaults
  # on first apply.
}

module "cache_quota" {
  source     = "${local.modules_source}/spoke-cache-quota?ref=${local.modules_ref}"
  spoke_slug = var.spoke_slug
  cache_gib  = var.cache_quota_gib
}

module "runner_binding" {
  source                 = "${local.modules_source}/spoke-runner-binding?ref=${local.modules_ref}"
  spoke_slug             = var.spoke_slug
  github_repository      = local.github_repository
  allowed_runner_classes = var.allowed_runner_classes
}

module "dns_pr_env" {
  source         = "${local.modules_source}/spoke-dns-pr-env?ref=${local.modules_ref}"
  spoke_slug     = var.spoke_slug
  brand_domain   = var.brand_domain
  lane_names     = var.lane_allowlist
  ingress_target = var.ingress_target
}

module "blahaj_app_install" {
  count = var.blahaj_installation_id > 0 ? 1 : 0

  source            = "${local.modules_source}/spoke-blahaj-app-install?ref=${local.modules_ref}"
  spoke_slug        = var.spoke_slug
  github_repository = local.github_repository
  installation_id   = var.blahaj_installation_id
}

output "state_prefix" {
  description = "S3 state prefix the spoke writes under."
  value       = module.state_namespace.prefix
}

output "wildcard_fqdn" {
  description = "PR-env wildcard FQDN."
  value       = module.dns_pr_env.wildcard_fqdn
}

output "stable_lane_fqdns" {
  description = "Map of stable lane name -> FQDN."
  value       = module.dns_pr_env.stable_lane_fqdns
}

output "cache_namespace" {
  description = "Cache namespace this spoke pushes/fetches under."
  value       = module.cache_quota.attic_namespace
}

output "blahaj_event_type" {
  description = "Blahaj dispatch event_type (only set if installation_id > 0)."
  value       = var.blahaj_installation_id > 0 ? module.blahaj_app_install[0].event_type : ""
}
