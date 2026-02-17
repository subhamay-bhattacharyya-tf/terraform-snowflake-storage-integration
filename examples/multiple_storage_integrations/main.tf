# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration - Multiple Integrations Example
# -----------------------------------------------------------------------------
# This example demonstrates how to use the snowflake-storage-integration module
# to create multiple Snowflake storage integrations using a map of
# configurations.
# -----------------------------------------------------------------------------

module "storage_integrations" {
  source = "../.."

  storage_integration_configs = var.storage_integration_configs
}
