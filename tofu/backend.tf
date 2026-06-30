# OpenTofu state backend.
#
# State lives in an operator-provisioned S3-compatible bucket. The endpoint and
# credentials are ENV / OPERATOR authority — a spoke MUST NOT hard-code them.
# Supply them at init via AWS_* env (AWS_ENDPOINT_URL_S3, AWS_ACCESS_KEY_ID,
# AWS_SECRET_ACCESS_KEY) or `tofu init -backend-config=...`, only ever from a
# gitignored .envrc.local / *.backend.hcl on an apply-capable operator host.
# See tofu/README.md.
#
# DORMANT on this personal spoke: never `tofu init` here — there is no reachable
# backend and the module source is a placeholder.

terraform {
  backend "s3" {
    bucket = "tofu-state"
    key    = "spokes/tinyland-goo/terraform.tfstate"
    region = "us-east-1" # provider-required; the operator S3 plane ignores it

    # endpoint + credentials: env/operator authority (see header + tofu/README.md).

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
