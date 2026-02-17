# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration - Multiple Integrations Example
# -----------------------------------------------------------------------------
# Output values for the multiple storage integrations example.
# -----------------------------------------------------------------------------

output "storage_integration_names" {
  description = "The names of the created storage integrations"
  value       = module.storage_integrations.storage_integration_names
}

output "aws_storage_integrations" {
  description = "All AWS storage integration resources"
  value       = module.storage_integrations.aws_storage_integrations
  sensitive   = true
}
