# Example: Single Snowflake Storage Integration
#
# This example demonstrates how to use the snowflake-storage-integration module
# to create a single Snowflake storage integration for AWS S3.

module "storage_integration" {
  source = "../.."

  storage_integration_configs = var.storage_integration_configs
}
