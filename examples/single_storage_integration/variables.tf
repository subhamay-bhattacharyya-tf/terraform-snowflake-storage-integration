# -----------------------------------------------------------------------------
# Terraform Snowflake Storage Integration - Single Integration Example
# -----------------------------------------------------------------------------
# Input variables for the single storage integration example.
# -----------------------------------------------------------------------------

variable "storage_integration_configs" {
  description = "Map of configuration objects for Snowflake storage integrations"
  type = map(object({
    name                      = string
    enabled                   = optional(bool, true)
    storage_provider          = optional(string, "S3")
    storage_aws_role_arn      = string
    storage_allowed_locations = list(string)
    storage_blocked_locations = optional(list(string), [])
    comment                   = optional(string, null)
  }))
  default = {}
}

# Snowflake authentication variables
variable "snowflake_organization_name" {
  description = "Snowflake organization name"
  type        = string
  default     = null
}

variable "snowflake_account_name" {
  description = "Snowflake account name"
  type        = string
  default     = null
}

variable "snowflake_user" {
  description = "Snowflake username"
  type        = string
  default     = null
}

variable "snowflake_role" {
  description = "Snowflake role"
  type        = string
  default     = null
}

variable "snowflake_private_key" {
  description = "Snowflake private key for key-pair authentication"
  type        = string
  sensitive   = true
  default     = null
}
