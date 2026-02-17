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

output "storage_integration_aws_iam_user_arns" {
  description = "The AWS IAM user ARNs for the AWS storage integrations."
  value       = { for k, v in snowflake_storage_integration_aws.this : k => v.describe_output[0].storage_aws_iam_user_arn[0].value }
}

output "storage_integration_aws_external_ids" {
  description = "The AWS external IDs for the AWS storage integrations."
  value       = { for k, v in snowflake_storage_integration_aws.this : k => v.describe_output[0].storage_aws_external_id[0].value }
}

output "storage_integration_gcs_service_accounts" {
  description = "The GCS service accounts for the GCS storage integrations."
  value       = { for k, v in snowflake_storage_integration_gcs.this : k => v.describe_output[0].storage_gcp_service_account[0].value }
}

output "storage_integration_azure_consent_urls" {
  description = "The Azure consent URLs for the Azure storage integrations."
  value       = { for k, v in snowflake_storage_integration_azure.this : k => v.describe_output[0].azure_consent_url[0].value }
}

output "storage_integration_azure_app_ids" {
  description = "The Azure multi-tenant app IDs for the Azure storage integrations."
  value       = { for k, v in snowflake_storage_integration_azure.this : k => v.describe_output[0].azure_multi_tenant_app_name[0].value }
}

output "aws_storage_integrations" {
  description = "All AWS storage integration resources."
  value       = snowflake_storage_integration_aws.this
}

output "gcs_storage_integrations" {
  description = "All GCS storage integration resources."
  value       = snowflake_storage_integration_gcs.this
}

output "azure_storage_integrations" {
  description = "All Azure storage integration resources."
  value       = snowflake_storage_integration_azure.this
}
