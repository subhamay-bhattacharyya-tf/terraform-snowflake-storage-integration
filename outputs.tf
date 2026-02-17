# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration Module - Outputs
# -----------------------------------------------------------------------------
# Output values for the Snowflake storage integration module.
# -----------------------------------------------------------------------------

output "storage_integration_names" {
  description = "The names of the created storage integrations."
  value = merge(
    { for k, v in snowflake_storage_integration_aws.this : k => v.name },
    { for k, v in snowflake_storage_integration_gcs.this : k => v.name },
    { for k, v in snowflake_storage_integration_azure.this : k => v.name }
  )
}

output "aws_storage_integrations" {
  description = "All AWS storage integration resources."
  value       = snowflake_storage_integration_aws.this
  sensitive   = true
}

output "gcs_storage_integrations" {
  description = "All GCS storage integration resources."
  value       = snowflake_storage_integration_gcs.this
  sensitive   = true
}

output "azure_storage_integrations" {
  description = "All Azure storage integration resources."
  value       = snowflake_storage_integration_azure.this
  sensitive   = true
}
