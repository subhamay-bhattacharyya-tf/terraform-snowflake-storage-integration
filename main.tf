# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration Module - Main
# -----------------------------------------------------------------------------
# Creates and manages one or more Snowflake storage integrations for external
# cloud storage. Uses provider-specific resources for AWS, GCS, and Azure.
# -----------------------------------------------------------------------------

locals {
  # Filter configurations by storage provider
  aws_integrations = {
    for k, v in var.storage_integration_configs : k => v
    if upper(v.storage_provider) == "S3"
  }

  gcs_integrations = {
    for k, v in var.storage_integration_configs : k => v
    if upper(v.storage_provider) == "GCS"
  }

  azure_integrations = {
    for k, v in var.storage_integration_configs : k => v
    if upper(v.storage_provider) == "AZURE"
  }
}

# AWS S3 Storage Integrations
resource "snowflake_storage_integration_aws" "this" {
  for_each = local.aws_integrations

  name                      = each.value.name
  storage_provider          = "S3"
  enabled                   = each.value.enabled
  storage_aws_role_arn      = each.value.storage_aws_role_arn
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_blocked_locations = each.value.storage_blocked_locations
  comment                   = each.value.comment
}

# GCS Storage Integrations
resource "snowflake_storage_integration_gcs" "this" {
  for_each = local.gcs_integrations

  name                      = each.value.name
  enabled                   = each.value.enabled
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_blocked_locations = each.value.storage_blocked_locations
  comment                   = each.value.comment
}

# Azure Storage Integrations
resource "snowflake_storage_integration_azure" "this" {
  for_each = local.azure_integrations

  name                      = each.value.name
  enabled                   = each.value.enabled
  azure_tenant_id           = each.value.azure_tenant_id
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_blocked_locations = each.value.storage_blocked_locations
  comment                   = each.value.comment
}

# Grant privileges on storage integrations to account roles
resource "snowflake_grant_privileges_to_account_role" "storage_integration_grants" {
  for_each = {
    for grant in flatten([
      for si_key, si in var.storage_integration_configs : [
        for g in si.grants : {
          key        = "${si_key}_${g.role_name}"
          role_name  = g.role_name
          privileges = g.privileges
          name       = si.name
        }
      ]
    ]) : grant.key => grant
  }

  account_role_name = each.value.role_name
  privileges        = each.value.privileges

  on_account_object {
    object_type = "INTEGRATION"
    object_name = each.value.name
  }

  depends_on = [
    snowflake_storage_integration_aws.this,
    snowflake_storage_integration_gcs.this,
    snowflake_storage_integration_azure.this
  ]
}
