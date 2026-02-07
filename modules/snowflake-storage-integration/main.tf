# Snowflake Storage Integration Resource
# Creates and manages one or more Snowflake storage integrations for external cloud storage


resource "snowflake_storage_integration" "this" {
  for_each = var.storage_integration_configs

  name                      = each.value.name
  type                      = "EXTERNAL_STAGE"
  enabled                   = each.value.enabled
  storage_provider          = each.value.storage_provider
  storage_aws_role_arn      = each.value.storage_provider == "S3" ? each.value.storage_aws_role_arn : null
  storage_allowed_locations = each.value.storage_allowed_locations
  storage_blocked_locations = each.value.storage_blocked_locations
  comment                   = each.value.comment
}
