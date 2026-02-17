# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration Module - Outputs
# -----------------------------------------------------------------------------
# Output values for the Snowflake storage integration module.
# -----------------------------------------------------------------------------

output "storage_integration_names" {
  description = "The names of the created storage integrations."
  value       = { for k, v in snowflake_storage_integration.this : k => v.name }
}

output "storage_integration_aws_iam_user_arns" {
  description = "The AWS IAM user ARNs for the storage integrations."
  value       = { for k, v in snowflake_storage_integration.this : k => v.storage_aws_iam_user_arn }
}

output "storage_integration_aws_external_ids" {
  description = "The AWS external IDs for the storage integrations."
  value       = { for k, v in snowflake_storage_integration.this : k => v.storage_aws_external_id }
}

output "storage_integrations" {
  description = "All storage integration resources."
  value       = snowflake_storage_integration.this
}
