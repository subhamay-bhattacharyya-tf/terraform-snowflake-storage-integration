# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration Module - Variables
# -----------------------------------------------------------------------------
# Input variables for the Snowflake storage integration module.
# -----------------------------------------------------------------------------

variable "storage_integration_configs" {
  description = "Map of configuration objects for Snowflake storage integrations (external stages)"
  type = map(object({
    name                      = string
    enabled                   = optional(bool, true)
    storage_provider          = optional(string, "S3")
    storage_aws_role_arn      = optional(string, null)
    storage_allowed_locations = list(string)
    storage_blocked_locations = optional(list(string), [])
    comment                   = optional(string, null)
  }))
  default = {}

  validation {
    condition     = alltrue([for k, si in var.storage_integration_configs : length(si.name) > 0])
    error_message = "Storage integration name must not be empty."
  }

  validation {
    condition     = alltrue([for k, si in var.storage_integration_configs : contains(["S3", "GCS", "AZURE"], upper(si.storage_provider))])
    error_message = "Invalid storage_provider. Valid values: S3, GCS, AZURE."
  }

  validation {
    condition     = alltrue([for k, si in var.storage_integration_configs : length(si.storage_allowed_locations) > 0])
    error_message = "storage_allowed_locations must contain at least one location."
  }

  validation {
    condition = alltrue([
      for k, si in var.storage_integration_configs :
      si.storage_provider != "S3" || (si.storage_aws_role_arn != null && can(regex("^arn:aws:iam::", si.storage_aws_role_arn)))
    ])
    error_message = "storage_aws_role_arn must be a valid AWS IAM role ARN when storage_provider is S3."
  }
}
