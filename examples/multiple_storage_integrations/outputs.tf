# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration - Multiple Integrations Example
# -----------------------------------------------------------------------------
# Output values for the multiple storage integrations example.
# -----------------------------------------------------------------------------

output "storage_integration_names" {
  description = "The names of the created storage integrations"
  value       = module.storage_integrations.storage_integration_names
}

output "storage_integration_aws_iam_user_arns" {
  description = "The AWS IAM user ARNs for the storage integrations"
  value       = module.storage_integrations.storage_integration_aws_iam_user_arns
}

output "storage_integration_aws_external_ids" {
  description = "The AWS external IDs for the storage integrations"
  value       = module.storage_integrations.storage_integration_aws_external_ids
}

output "aws_storage_integrations" {
  description = "All AWS storage integration resources"
  value       = module.storage_integrations.aws_storage_integrations
}
