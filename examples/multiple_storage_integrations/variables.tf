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
  default = {
    "raw_data_integration" = {
      name                      = "SN_TEST_RAW_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-raw-data-role"
      storage_allowed_locations = ["s3://my-bucket/raw/"]
      storage_blocked_locations = []
      comment                   = "Storage integration for raw data ingestion."
    }
    "processed_data_integration" = {
      name                      = "SN_TEST_PROCESSED_DATA_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-processed-data-role"
      storage_allowed_locations = ["s3://my-bucket/processed/"]
      storage_blocked_locations = []
      comment                   = "Storage integration for processed data."
    }
    "archive_integration" = {
      name                      = "SN_TEST_ARCHIVE_INTEGRATION"
      enabled                   = true
      storage_provider          = "S3"
      storage_aws_role_arn      = "arn:aws:iam::123456789012:role/snowflake-archive-role"
      storage_allowed_locations = ["s3://my-bucket/archive/"]
      storage_blocked_locations = ["s3://my-bucket/archive/restricted/"]
      comment                   = "Storage integration for archived data."
    }
  }
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
