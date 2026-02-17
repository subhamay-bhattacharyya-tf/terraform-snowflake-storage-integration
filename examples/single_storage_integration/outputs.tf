# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration - Single Integration Example
# -----------------------------------------------------------------------------
# Output values for the single storage integration example.
# -----------------------------------------------------------------------------

output "storage_integration_names" {
  description = "The names of the created storage integrations"
  value       = module.storage_integration.storage_integration_names
}

output "aws_storage_integrations" {
  description = "All AWS storage integration resources"
  value       = module.storage_integration.aws_storage_integrations
  sensitive   = true
}
