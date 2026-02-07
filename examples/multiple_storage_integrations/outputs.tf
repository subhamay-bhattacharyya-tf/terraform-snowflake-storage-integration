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

output "storage_integrations" {
  description = "All storage integration resources"
  value       = module.storage_integrations.storage_integrations
}
